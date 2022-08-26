# Environment setup with Terraform

### 1. Variables
Delcare the variables below for use throughout the lab. 
```
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
BQ_CONNECTOR_JAR_GCS_URI="gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
CLOUD_COMPOSER_IMG_VERSION="composer-2.0.11-airflow-2.2.3"
SPARK_CUSTOM_CONTAINER_IMAGE_TAG="1.0.0"

# Edit for your geo
YOUR_GCP_REGION="us-central1"
YOUR_GCP_ZONE="us-central1-a"
YOUR_GCP_MULTI_REGION="US"
CLOUD_SCHEDULER_TIME_ZONE="America/Chicago"

echo "PROJECT_ID=$PROJECT_ID"
echo "PROJECT_NBR=$PROJECT_NBR"
echo "PROJECT_NAME=$PROJECT_NAME"
echo "VPC_NM=$VPC_NM"
echo "PERSISTENT_HISTORY_SERVER_NM=$PERSISTENT_HISTORY_SERVER_NM"
echo "UMSA_FQN=$UMSA_FQN"
echo "DATA_BUCKET=$DATA_BUCKET"
echo "CODE_BUCKET=$CODE_BUCKET"
```

### Terraform commands

## Terraform init
Terraform init
```
cd ~/${PROJECT_ID}/00-env-setup/
terraform init
```

## Terraform plan
```
cd ~/s8s-spark-mlops/00-env-setup/
terraform plan \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}" \
  -var="cloud_composer_image_version=${CLOUD_COMPOSER_IMG_VERSION}" \
  -var="spark_container_image_tag=${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}" \
  -var="gcp_region=${YOUR_GCP_REGION}" \
  -var="gcp_zone=${YOUR_GCP_ZONE}" \
  -var="gcp_multi_region=${YOUR_GCP_MULTI_REGION}" \
  -var="bq_connector_jar_gcs_uri=${BQ_CONNECTOR_JAR_GCS_URI}" \
  -var="cloud_scheduler_time_zone=${CLOUD_SCHEDULER_TIME_ZONE}"
 ```

## Terraform apply
```
cd ~/s8s-spark-mlops/00-env-setup/
terraform apply \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}"  \
  -var="cloud_composer_image_version=${CLOUD_COMPOSER_IMG_VERSION}" \
  -var="spark_container_image_tag=${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}" \
  -var="gcp_region=${YOUR_GCP_REGION}" \
  -var="gcp_zone=${YOUR_GCP_ZONE}" \
  -var="gcp_multi_region=${YOUR_GCP_MULTI_REGION}" \
  -var="bq_connector_jar_gcs_uri=${BQ_CONNECTOR_JAR_GCS_URI}" \
  -var="cloud_scheduler_time_zone=${CLOUD_SCHEDULER_TIME_ZONE}" \
  --auto-approve
 ```
 
## Terraform destroy
```
cd ~/s8s-spark-mlops/00-env-setup/
terraform destroy \
  -var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}" \
  -var="cloud_composer_image_version=${CLOUD_COMPOSER_IMG_VERSION}" \
  -var="spark_container_image_tag=${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}" \
  -var="gcp_region=${YOUR_GCP_REGION}" \
  -var="gcp_zone=${YOUR_GCP_ZONE}" \
  -var="gcp_multi_region=${YOUR_GCP_MULTI_REGION}" \
  -var="bq_connector_jar_gcs_uri=${BQ_CONNECTOR_JAR_GCS_URI}" \
  -var="cloud_scheduler_time_zone=${CLOUD_SCHEDULER_TIME_ZONE}" \
  --auto-approve
```

## Terrafrom selective execuction sample..
The below is a sample
```
cd ~/s8s-spark-mlops/00-env-setup/
terraform apply -target=null_resource.vai_pipeline_customization \
-var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}"  \
  -var="cloud_composer_image_version=${CLOUD_COMPOSER_IMG_VERSION}" \
  -var="spark_container_image_tag=${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}" \
  -var="gcp_region=${YOUR_GCP_REGION}" \
  -var="gcp_zone=${YOUR_GCP_ZONE}" \
  -var="gcp_multi_region=${YOUR_GCP_MULTI_REGION}" \
  -var="bq_connector_jar_gcs_uri=${BQ_CONNECTOR_JAR_GCS_URI}" \
  -var="cloud_scheduler_time_zone=${CLOUD_SCHEDULER_TIME_ZONE}" \
  --auto-approve
```

## Terrafrom selective replace sample..
The below is a sample
```
cd ~/s8s-spark-mlops/00-env-setup/
terraform apply -replace=google_cloudfunctions2_function.deploy_gcf_vai_pipeline_trigger \
-var="project_id=${PROJECT_ID}" \
  -var="project_name=${PROJECT_NAME}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="org_id=${ORG_ID}"  \
  -var="cloud_composer_image_version=${CLOUD_COMPOSER_IMG_VERSION}" \
  -var="spark_container_image_tag=${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}" \
  -var="gcp_region=${YOUR_GCP_REGION}" \
  -var="gcp_zone=${YOUR_GCP_ZONE}" \
  -var="gcp_multi_region=${YOUR_GCP_MULTI_REGION}" \
  -var="bq_connector_jar_gcs_uri=${BQ_CONNECTOR_JAR_GCS_URI}" \
  -var="cloud_scheduler_time_zone=${CLOUD_SCHEDULER_TIME_ZONE}" \
  --auto-approve
```
