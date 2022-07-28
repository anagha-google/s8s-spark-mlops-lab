https://google-cloud-pipeline-components.readthedocs.io/en/google-cloud-pipeline-components-1.0.0/google_cloud_pipeline_components.experimental.dataproc.html#google_cloud_pipeline_components.experimental.dataproc.DataprocPySparkBatchOp

com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2

gcr.io/s8s-spark-ml-mlops/dataproc_serverless_custom_runtime:1.0.2


# s8s-spark-mlops

PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
PROJECT_NAME=`gcloud projects describe ${PROJECT_ID} | grep name | cut -d':' -f2 | xargs`
GCP_ACCOUNT_NAME=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
ORG_ID=`gcloud organizations list --format="value(name)"`
LOCATION=us-central1
VPC_NM=s8s-vpc-$PROJECT_NBR
SPARK_SERVERLESS_SUBNET=spark-snet
PERSISTENT_HISTORY_SERVER_NM=s8s-sphs-${PROJECT_NBR}
UMSA_FQN=s8s-lab-sa@$PROJECT_ID.iam.gserviceaccount.com
DATA_BUCKET=s8s_data_bucket-${PROJECT_NBR}
CODE_BUCKET=s8s_code_bucket-${PROJECT_NBR}
MODEL_BUCKET=s8s_model_bucket-${PROJECT_NBR}

gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_preprocessing.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch cli-data-preprocessing-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- --appName=01-data-engineering --projectID=$PROJECT_ID --rawDatasetBucketFQN=gs://${DATA_BUCKET}/customer_churn_train_data.csv --sparkBigQueryScratchBucketUri=s8s-spark-bucket-${PROJECT_NBR}/01-data-preprocessing --enableDataframeDisplay=True


gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_preprocessing.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch customer-churn-01-data-preprocessing-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- ["--appName","01-data-engineering","--projectID",$PROJECT_ID,"--rawDatasetBucketFQN","gs://${DATA_BUCKET}/customer_churn_train_data.csv","--sparkBigQueryScratchBucketUri","s8s-spark-bucket-${PROJECT_NBR}/01-data-preprocessing","--enableDataframeDisplay",True]

gcloud dataproc batches submit pyspark \
gs://$CODE_BUCKET/pyspark/data_preprocessing.py \
--py-files="gs://$CODE_BUCKET/pyspark/common_utils.py" \
--deps-bucket="gs://$CODE_BUCKET/pyspark/" \
--project $PROJECT_ID \
--region $LOCATION  \
--batch cli-data-preprocessing-$RANDOM \
--subnet projects/$PROJECT_ID/regions/$LOCATION/subnetworks/$SPARK_SERVERLESS_SUBNET \
--history-server-cluster=projects/$PROJECT_ID/regions/$LOCATION/clusters/$PERSISTENT_HISTORY_SERVER_NM \
--service-account $UMSA_FQN \
--properties "spark.jars.packages=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
-- "--appName","01-data-engineering","--projectID",$PROJECT_ID,"--rawDatasetBucketFQN","gs://${DATA_BUCKET}/customer_churn_train_data.csv","--sparkBigQueryScratchBucketUri","s8s-spark-bucket-${PROJECT_NBR}/01-data-preprocessing","--enableDataframeDisplay",True
