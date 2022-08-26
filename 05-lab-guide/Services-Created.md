# About

The following are the services that get provisioned in your environment. 

## 1. IAM
A User Managed Service Account (UMSA) is created and granted requisite permissions and the lab attendee is granted permissions to impersonate the UMSA. There are a few other permissions granted to the default Google Managed Service Accounts of some services as requried. The Terraform main.tf is a good read to understand the permissions.

![IAM](../06-images/module-1-iam-01.png)   
<br><br>

![IAM](../06-images/module-1-iam-02.png)   
<br><br>

![IAM](../06-images/module-1-iam-03.png)   
<br><br>

![IAM](../06-images/module-1-iam-04.png)   
<br><br>


## 2. Networking
The following networking components are created as part of Terraform deployment-

### 2.1. VPC

![VPC](../06-images/module-1-networking-01.png)   
<br><br>

![VPC](../06-images/module-1-networking-02.png)   
<br><br>

### 2.2. Subnet with private google access

![VPC](../06-images/module-1-networking-03.png)   
<br><br>

### 2.3. Firewall rule for Data Serverless Spark

![VPC](../06-images/module-1-networking-05.png)   
<br><br>


### 2.4. Reserved IP for VPC peering with Vertex AI tenant network for Vertex AI workbench, managed notebook instance for BYO network

![VPC](../06-images/module-1-networking-04.png)   
<br><br>


### 2.5. VPC peering with Vertex AI tenant network for Vertex AI workbench, managed notebook instance for BYO network

![VPC](../06-images/module-1-networking-06.png)   
<br><br>

![VPC](../06-images/module-1-networking-07.png)   
<br><br>

![VPC](../06-images/module-1-networking-08.png)   
<br><br>

## 3. Cloud Storage

### 3.1. Buckets created
A number of buckets are created by te Terraform and some buckets are created by the GCP products. The following is a listing of buckets created as part of the deployment with Terraform.

![GCS](../06-images/module-1-storage-01.png)   
<br><br>

![GCS](../06-images/module-1-storage-02.png)   
<br><br>

### 3.2. The Data Bucket



### 3.3. The Code Bucket

The following is the author's code bucket content-
```
# Cloud Composer - Airflow DAG
gs://s8s_code_bucket-569379262211/airflow/pipeline.py

# Shell Script for building custom container image for Serverless Spark
gs://s8s_code_bucket-569379262211/bash/build-container-image.sh

# Post startup shell scripts to upload Jupyter notebooks in GCS to Vertex AI workbench notebook server instances
gs://s8s_code_bucket-569379262211/bash/mnbs-exec-post-startup.sh
gs://s8s_code_bucket-569379262211/bash/umnbs-exec-post-startup.sh

# Pyspark scripts for Spark Machine Learning
gs://s8s_code_bucket-569379262211/pyspark/batch_scoring.py
gs://s8s_code_bucket-569379262211/pyspark/common_utils.py
gs://s8s_code_bucket-569379262211/pyspark/hyperparameter_tuning.py
gs://s8s_code_bucket-569379262211/pyspark/model_training.py
gs://s8s_code_bucket-569379262211/pyspark/preprocessing.py

# Cloud Functions source code
gs://s8s_code_bucket-569379262211/cloud-functions/function-source.zip
gs://s8s_code_bucket-569379262211/cloud-functions/main.py
gs://s8s_code_bucket-569379262211/cloud-functions/requirements.txt
```

### 3.4. The Notebook Bucket

```
# PySpark development notebooks
gs://s8s_notebook_bucket-569379262211/pyspark/batch_scoring.ipynb
gs://s8s_notebook_bucket-569379262211/pyspark/hyperparameter_tuning.ipynb
gs://s8s_notebook_bucket-569379262211/pyspark/model_training.ipynb
gs://s8s_notebook_bucket-569379262211/pyspark/preprocessing.ipynb

# Vertex AI pipeline development notebook
gs://s8s_notebook_bucket-569379262211/vai-pipelines/customer_churn_training_pipeline.ipynb
```

### 3.5. The Pipeline Bucket

The customized (for your environment) JSON for scheduling a Vertex AI pipeline.
```
gs://s8s_pipeline_bucket-569379262211/templates/customer_churn_vai_pipeline_template.json
```

### 3.6. The Functions Bucket

Cloud Functions source code
```
gs://s8s_functions_bucket-569379262211/function-source.zip
```

### 3.6. The rest of the buckets
Are empty and used for peristing logs and/or MLOps artifacts



## 4. BigQuery

## 5. Persistent Spark History Server

## 6a. Vertex AI Workbench - User Managed Notebook Server 

## 6b. Vertex AI Workbench - User Managed Notebook Server - Jupyter Notebook

## 7a. Vertex AI Workbench - Managed Notebook Server 

## 7b. Vertex AI Workbench - Managed Notebook Server - Jupyter Notebooks

## 8a. Google Container Registry

## 8b. Google Container Registry - Container Image

## 9a. Cloud Composer

## 9b. Cloud Composer - Airflow variables

## 9c. Cloud Composer - Airflow DAG

## 10. Google Cloud Function

## 11. 	Cloud Scheduler

## 12. Customized Vertex AI pipeline JSON in GCS
