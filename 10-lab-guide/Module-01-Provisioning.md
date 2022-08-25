# About

This module covers environment provisioning for the workshop. This module takes ~50 minutes to complete. 
<br>
Note:<br> 
1. Ensure services in use in the workshop are available in the location of your preference and modify the variables in step 2.4.1 to reflect the same.
2. Get any preview services allow-listed
3. Some of the organization policies many not apply for your company, modify appropriately
4. The lab is intended for each attendee to have a full environment to themselves with "shared nothing"
5. Terraform state is deliberately local for simplicity

## 1. Details about the environment that is setup by this module

| # | Services provisioned | Purpose  | 
| -- | :--- | :--- |
| 1. | VPC network | Many services in this workshop are VPC native |
| 2. | Subnet | Same as above |
| 3. | Reserved IP | For Private Service Access for Vertex AI Managed Notebook with BYO network |
| 4. | VPC peering | To peer our VPC from #1 with that of Vertex AI tenant for Vertex AI Managed Notebook with BYO network |
| 5. | Firewall rules | For Dataproc Spark Serverless |
| 6. | Google Cloud Storage | Buckets for data, code, notebooks, pipelines, models, and more |
| 7. | Persistent Spark History Server | For troubleshooting Dataproc Serverless Spark jobs |
| 8. | BigQuery | For curated data for model training and prediction results, model metrics, feature important scores and more |
| 9. | Vertex AI Workbench - User Managed Notebook Server | For authoring Vertex AI pipeline for MLOps |
| 10. | Vertex AI Workbench - Managed Notebook Server | For interactive Serverless Spark notebooks  |
| 11. | Google Container Registry |  For Serverless Spark custom container images |
| 12. | Cloud Composer | For orchestrating batch scoring |
| 13. | Dataproc Metastore | Placeholder for future evolution of the workshop |
| 14. | Google Cloud Function  | To execute VAI pipeline for model training |
| 15. | Cloud Scheduler | To invoke the cloud function on schedule to train models |

Further:
| # | Other tasks in the Terraform | Purpose  | 
| -- | :--- | :--- |
| 16. | Enable Google APIs | For using services |
| 17. | Update Organization policies | For provisioning services without errors |
| 18. | Create User Managed Service Account  | For all operations |
| 19. | Grant IAM permissions  | To self and to the service account |
| 20. | Customize code  | Update various attributes within PySpark code, bash scripts, notebooks and more to reflect your deployment |
| 21. | Upload Airflow DAG  | To Cloud Composer DAG folder<br> for ease |
| 22. | Upload precreated (customized for your deployment) notebooks  | - To Vertex AI Managed Notebook instance<br> - To Vertex AI User-Managed Notebook instance <br> for ease|
| 23. | Upload Vertex AI pipeline authoring notebook  | To Cloud Composer DAG folder |
| 24. | Create Custom Spark Container image  | To simplify lab experience |

and more..

Lets get started!



## 2. Create the environment

### 2.1. Create a directory in Cloud Shell for the workshop
```
cd ~
mkdir gcp-spark-mllib-workshop
```

### 2.2. Clone the workshop git repo
```
cd ~/gcp-spark-mllib-workshop
git clone https://github.com/anagha-google/s8s-spark-mlops.git
```

### 2.3. Navigate to the Terraform provisioning directory
```
cd ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup
```

### 2.4. Provision the environment

#### 2.4.1. Define variables for use
Modify the below as appropriate for your deployment..e.g. region, zone etc.
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
YOUR_GCP_REGION="us-central1"
YOUR_GCP_ZONE="us-central1-a"
YOUR_GCP_MULTI_REGION="US"
BQ_CONNECTOR_JAR_GCS_URI="gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
CLOUD_COMPOSER_IMG_VERSION="composer-2.0.11-airflow-2.2.3"
SPARK_CUSTOM_CONTAINER_IMAGE_TAG="1.0.0"
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

### 2.4.2. Initialize Terraform
Needs to run in cloud shell from ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup
```
terraform init
```

#### 2.4.3. Review the Terraform deployment plan
Needs to run in cloud shell from ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup
```
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

#### 2.4.4. Provision the environment
Needs to run in cloud shell from ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup
```

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

#### 2.4.5. For selective replacement of specific services/units of deployment
Needs to run in cloud shell from ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup<br>
If -target does not work, try -replace
```
terraform apply -target=google_notebooks_instance.mnb_server_creation \
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

#### 2.4.6. To destroy the deployment
You can (a) shutdown the project altogether in GCP Cloud Console or (b) use Terraform to destroy. Use (b) at your own risk as its a little glitchy while (a) is guaranteed to stop the billing meter pronto.
<br>
Needs to run in cloud shell from ~/gcp-spark-mllib-workshop/s8s-spark-mlops/00-env-setup
```
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

#### 2.4.7. Glitches/nuances
1. Cloud Composer 2<br>
If you edit the Terraform and run apply, Cloud Composer2 attempts to update the network and fails the deployment. <br>
Workaround: Delete Cloud Composer manually and then rerun



## 4. What's in the next module
In the next module, we will learn how to use Serverless Spark interactive notebooks for machine learning model development with Spark MLLib on Dataproc Serverless Spark.
