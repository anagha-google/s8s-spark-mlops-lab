# About

The following are the services that get provisioned in your environment. 

## 1. IAM

## 2. Networking
The following networking components are created as part of Terraform deployment-
1. VPC
![VPC](../06-images/module-1-networking-01.png)   
<br><br>
2. Subnet with private google access
![VPC](../06-images/module-1-networking-02.png)   
<br><br>
3. Firewall rule for Data Serverless Spark

<br><br>
4. Reserved IP for VPC peering with Vertex AI tenant network for Vertex AI workbench, managed notebook instance with BYO network

<br><br>
5. VPC peering with Vertex AI tenant network for Vertex AI workbench, managed notebook instance with BYO network

<br><br>

## 3. Cloud Storage

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
