```
cd ~/s8s-spark-ml-mvp/00-env-setup

terraform plan \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}" 


terraform apply \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}" \
  -auto-approve
  
terraform destroy \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}" \
  -auto-approve

PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
PROJECT_NAME=`gcloud projects describe ${PROJECT_ID} | grep name | cut -d':' -f2 | xargs`
GCP_ACCOUNT_NAME=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
ORG_ID=`gcloud organizations list --format="value(name)"`
LOCATION=us-central1
VPC_NM=VPC=s8s-vpc-$PROJECT_NBR
SPARK_SERVERLESS_SUBNET=spark-snet
PERSISTENT_HISTORY_SERVER_NM=s8s-sphs-${PROJECT_NBR}
UMSA_FQN=s8s-lab-sa@$PROJECT_ID.iam.gserviceaccount.com
DATA_BUCKET=s8s_data_bucket-${PROJECT_NBR}
CODE_BUCKET=s8s_code_bucket-${PROJECT_NBR}
MODEL_BUCKET=s8s_model_bucket-${PROJECT_NBR}

echo "PROJECT_ID=$PROJECT_ID"
echo "PROJECT_NBR=$PROJECT_NBR"
echo "PROJECT_NAME=$PROJECT_NAME"
echo "VPC_NM=$VPC_NM"
echo "PERSISTENT_HISTORY_SERVER_NM=$PERSISTENT_HISTORY_SERVER_NM"
echo "UMSA_FQN=$UMSA_FQN"
echo "DATA_BUCKET=$DATA_BUCKET"
echo "CODE_BUCKET=$CODE_BUCKET"


# a) DATA ENGINEERING - Vanilla
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_engineering.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-01-data-engineering-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- "01-data-engineering"  $PROJECT_ID "gs://${DATA_BUCKET}/customer_churn_train_data.csv" "s8s-spark-bucket-${PROJECT_NBR}/01-data-engineering" True

# b) DATA ENGINEERING - GCR image
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_engineering.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-01-data-engineering-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
--container-image="gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2" \
-- "01-data-engineering"  $PROJECT_ID "gs://${DATA_BUCKET}/customer_churn_train_data.csv" "s8s-spark-bucket-${PROJECT_NBR}/01-data-engineering" True

# c) DATA ENGINEERING - arg parser
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_engineering.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-01-data-engineering-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
--container-image="gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2" \
-- --appName="01-data-engineering"  --projectID=$PROJECT_ID --rawDatasetBucketFQN="gs://${DATA_BUCKET}/customer_churn_train_data.csv" --sparkBigQueryScratchBucketUri="s8s-spark-bucket-${PROJECT_NBR}/01-data-engineering" --enableDataframeDisplay=True


# a) MODEL TRAINING - Vanilla
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/model_training.py \
--py-files="gs://$CODE_BUCKET/pyspark/" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-02-model-training-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- "02-model-training"  $PROJECT_ID "${PROJECT_ID}.customer_churn_ds.customer_churn_training_data" "${PROJECT_ID}.customer_churn_ds.customer_churn_test_predictions" "s8s-spark-bucket-${PROJECT_NBR}/02-model-training/" "gs://$MODEL_BUCKET/customer-churn-model/" "${PROJECT_ID}.customer_churn_ds.customer_churn_model_feature_importance" True

# b) MODEL TRAINING - with a container image
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/model_training.py \
--py-files="gs://$CODE_BUCKET/pyspark/" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-02-model-training-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
--container-image="gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2" \
-- "02-model-training"  $PROJECT_ID "${PROJECT_ID}.customer_churn_ds.customer_churn_training_data" "${PROJECT_ID}.customer_churn_ds.customer_churn_test_predictions" "s8s-spark-bucket-${PROJECT_NBR}/02-model-training/" "gs://$MODEL_BUCKET/customer-churn-model/" "${PROJECT_ID}.customer_churn_ds.customer_churn_model_feature_importance" True

# c) MODEL TRAINING - with args parser
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/model_training.py \
--py-files="gs://$CODE_BUCKET/pyspark/" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-02-model-training-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
--container-image="gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2" \
-- --appName="02-model-training"  --projectID=$PROJECT_ID --bigQuerySourceTableFQN="${PROJECT_ID}.customer_churn_ds.customer_churn_training_data" --bigQueryModelTestResultsTableFQN="${PROJECT_ID}.customer_churn_ds.customer_churn_test_predictions" --sparkBigQueryScratchBucketUri="s8s-spark-bucket-${PROJECT_NBR}/02-model-training/" --sparkMlModelBucketUri="gs://$MODEL_BUCKET/customer-churn-model/" --bigQueryModelMetricsTableFQN="${PROJECT_ID}.customer_churn_ds.customer_churn_model_metrics" --bigQueryFeatureImportanceTableFQN="${PROJECT_ID}.customer_churn_ds.customer_churn_model_feature_importance" --enableDataframeDisplay=True



================

# BATCH SCORING
gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/batch_scoring.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-03-batch-scoring-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--container-image="gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2" \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- "03-batch-scoring"  $PROJECT_ID "gs://$MODEL_BUCKET/customer-churn-model/" "gs://$DATA_BUCKET/customer_churn_score_data.csv" "${PROJECT_ID}.customer_churn_ds.customer_churn_batch_scoring_results" "s8s-spark-bucket-${PROJECT_NBR}/03-batch-scoring/" True

```
