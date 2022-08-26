# About

This module covers how to use Vertex AI Workbench's "Managed Notebook Instance" for authoring Spark code in an interactive manner with Dataproc Serverless Spark interactive. This is crucial for the next module where you will run sample machine learning experiments.
<br><br>

We will do Chicago Crimes Analysis in this lab, based off of the Chicago Crimes public dataset in BigQuery.

**Pre-requisite:**
1. Ensure that any preview features are allow-listed by product engineering, ahead of time
2. Provisioning from module 1 needs to be successfully completed

### 1. Varibles you will need for this module

Run the below in Cloud Shell scoped to your project
```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
UMSA_FQN=s8s-lab-sa@$PROJECT_ID.iam.gserviceaccount.com
SPARK_CUSTOM_CONTAINER_IMAGE_URI="gcr.io/$PROJECT_ID/customer_churn_image:1.0.0"
SPARK_BQ_CONNECTOR_PACKAGES="com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2"

echo "PROJECT_ID=$PROJECT_ID"
echo "PROJECT_NBR=$PROJECT_NBR"
echo "UMSA_FQN=$UMSA_FQN"
echo "SPARK_CUSTOM_CONTAINER_IMAGE_URI=$SPARK_CUSTOM_CONTAINER_IMAGE_URI"
echo "SPARK_BQ_CONNECTOR_PACKAGES=$SPARK_BQ_CONNECTOR_PACKAGES"
echo " "
echo " "
```

Author's details:
```
PROJECT_ID=gcp-scalable-ml-workshop
PROJECT_NBR=xxx
UMSA_FQN=s8s-lab-sa@gcp-scalable-ml-workshop.iam.gserviceaccount.com
SPARK_CUSTOM_CONTAINER_IMAGE_URI=gcr.io/gcp-scalable-ml-workshop/customer_churn_image:1.0.0
SPARK_BQ_CONNECTOR_PACKAGES=com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2
```

### 1. Navigate on the Cloud Console to the Vertex AI Workbench, Managed Notebook Instance
Open JupyterLab as shown below

![UMNBS](../06-images/module-1-vai-wb-01.png)   
<br><br>

![UMNBS](../06-images/module-1-vai-wb-mnb-01.png)   
<br><br>

![UMNBS](../06-images/module-1-vai-wb-mnbs-02.png)   
<br><br>


### 2. Open the Chicago Crimes notebook 








