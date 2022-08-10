# Practical Machine Learning at scale with Spark on GCP and Vertex AI

This repo is a hands on lab for [Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html) based machine learning on Google Cloud, powered by Dataproc Serverless Spark and showcases integration with Vertex AI. It is meant to demystify the integration, and features a minimum viable example of telco Customer Churn Prediction with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), and using [Random Forest classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier).

### Format
The lab is fully scripted (no research needed), with environment setup, data, code, notebooks, orchestration, commands, and configuration. Clone the repo and follow the step by step instructions for an end to end MLOps experience.

### Level
It is a Level 300 lab, and includes components spanning storage, networking, kubernetes,and a variety of data services. 

### Audience
The intended audience is anyone with access to Google Cloud and interested in kicking the tires, with ease.

### Prerequisites
Knowledge of Spark and Machine Learning would be beneficial.<br> 
Access to Google Cloud is a must.

### Goal
Simplify your learning journey with
(a) Just enough product knowledge of Dataproc Serverless Spark & Vertex AI integration for machine learning at scale on Google Cloud<br>
(b) Quick start code for ML at scale with Spark that can be repurposed for your data and experimentation<br>
(c) Terraform for provisioning a variety of Google Cloud data services that can be repurposed for your use case<br>

### Featured products in the lab
| # | Product/Feature | Purpose | 
| -- | :--- | :-- |
| 1 |  Google Cloud Storage | Storage of code, notebooks, logs and more |
| 2 |  BigQuery | Transformed data for model training |
| 3 |  Cloud Dataproc Serverless Spark  | End to end ML with Spark MLlib as part of Vertex AI pipeline |
| 4 |  Cloud Dataproc Persistent Spark History Server  | Spark UI and indefinite access to logs from prior executions |
| 5 |  Cloud Composer | Batch scoring job orchestration |
| 6 |  Google Container Registry | Custom container image for Dataproc Serverless Spark |
| 7 |  Vertex AI Managed Notebook instance | Experimentation via interactive serverless Spark notebooks |
| 8 |  Vertex AI Unmanaged Notebok instance | Vertex AI pipeline orchestration development |
| 9 |  Vertex AI Pipelines | Orchestration of PySpark ML tasks |
| 10 |  Vertex AI Managed Datasets | Curated preproocessed data ready to be used for training |
| 11 |  Vertex AI Metadata | Model metrics, and more |

### What is covered?
| # | Modules | Focus | Feature |
| -- | :--- | :-- | :-- |
| 1 | Environment provisioning | Environment Automation With Terraform | N/A |
| 2 | [Lab 1 - Cell Tower Anomaly Detection](lab-01/README.md) | Data Engineering | Serverless Spark Batch from CLI & with Cloud Composer orchestration|
| 3 | [Lab 2 - Wikipedia Page View Analysis](lab-02/README.md) | Data Analysis | Serverless Spark Batch from BigQuery UI |
| 4 | [Lab 3 - Chicago Crimes Analysis](lab-03/README.md) | Data Analysis | Serverless Spark Interactive from Vertex AI managed notebook|
| N | [Resources for Serverless Spark](https://spark.apache.org/docs/latest/) |

### Dont forget to 
Shut down/delete resources when done

### Credits
Some of the labs are contributed by partners, to Google Cloud, or are contributions from Googlers.<br>
Lab 1 - TekSystems<br>
Lab 2 - TekSystems<br>


### Contributions welcome

Community contribution to improve the labs or new labs are very much appreciated.


### WORK IN PROGRESS

1. Clone this repo
2. Provision your environment using Terraform
3. Author Spark ML code in Serverless Spark interactive notebooks
4. Operational Spark ML code into PySpark scripts & test from CLI
5. Author a Vertex AI pipeline for model training from a notebook on User Managed Notebook instance
6. Schedule model training pipeline with Cloud Scheduler
7. Author a Vertex AI pipeline for batch scoring from a notebook on User Managed Notebook instance
8. Author an Airflow DAG that executes a batch scoring Vertex AI pipeline
9. Run the DAG in Cloud Composer
10. Destroy resources upon lab completion


