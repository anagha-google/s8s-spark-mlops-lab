# Practical Machine Learning at scale with Spark on GCP and Vertex AI

## 1. About
This repo is a hands on lab for [Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html) based machine learning on Google Cloud, powered by Dataproc Serverless Spark and showcases integration with Vertex AI. The focus is on demystifying the integration (and not about a perfect model), and features a minimum viable example of telco **Customer Churn Prediction** with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), and using [Random Forest classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier).

## 2. Format
The lab is fully scripted (no research needed), with (fully automated) environment setup, data, code, notebooks, orchestration, commands, and configuration. Clone the repo and follow the step by step instructions for an end to end MLOps experience.

## 3. Level
It is a Level 300 lab, and includes components spanning storage, networking, kubernetes,and a variety of data services. 

## 4. Audience
The intended audience is anyone with access to Google Cloud and interested in kicking the tires, with ease.

## 5. Prerequisites
Knowledge of Spark and Machine Learning would be beneficial.<br> 
Access to Google Cloud is a must.

## 6. Goal
Simplify your learning journey with - <br> 
(a) Just enough product knowledge of Dataproc Serverless Spark & Vertex AI integration for machine learning at scale on Google Cloud<br>
(b) Quick start code for ML at scale with Spark that can be repurposed for your data and experimentation<br>
(c) Terraform for provisioning a variety of Google Cloud data services that can be repurposed for your use case<br>

## 7. What's covered from an ML perspective
### 7.1. Train a Spark MLlib model<br> 
 First in PySpark interactive notebooks, then via PySpark scripts<br> 
(a) Preprocessing <br> 
(b) Register managed dataset<br> 
(c) Train a RandomForest classification model<br> 
(d) Evaluate the model - metrics and plots<br> 
(e) Conditional hyperparameter tuning<br> 
(f) a-e in a Vertex AI managed pipeline <br> 

### 7.2. Scoring
(f) Batch scoring with the best model from 1(e), on Dataproc Serverless Spark<br>
(g) Orchestration of batch scoring on Cloud Composer/Apache Airflow
(h) Stream scoring - Work in progress<br> 
(i) Online serving (MLeap, Vertex AI serving)<br> 

## 8. Featured products in the lab
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

## 10. Dont forget to 
Shut down/delete resources when done

## 11. Credits & Resources


## 12. Contributions welcome
Community contribution to improve the lab is very much appreciated.






