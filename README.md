# Practical Machine Learning at scale with Spark on GCP and Vertex AI

##WORK ON HOLD due to team offsite##

## 1. About
This repo is a hands on lab for [Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html) based machine learning on Google Cloud, powered by Dataproc Serverless Spark and showcases integration with Vertex AI. The focus is on demystifying the integration (and not about a perfect model), and features a minimum viable example of telco **Customer Churn Prediction** with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), and using [Random Forest classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier).

## 2. Format
The lab is fully scripted (no research needed), with (fully automated) environment setup, data, code, notebooks, orchestration, commands, and configuration. Clone the repo and follow the step by step instructions for an end to end MLOps experience.

## 3. Level
It is a Level 300 lab, and includes components spanning storage, networking, kubernetes,and a variety of data services. 

## 4. Audience
The intended audience is anyone with access to Google Cloud and interested in the features showcased and want to kick the tires.

## 5. Prerequisites
Knowledge of Spark and Machine Learning would be beneficial.<br> 
Access to Google Cloud is a must.

## 6. Goal
Simplify your learning journey with - <br> 
(a) Just enough product knowledge of Dataproc Serverless Spark & Vertex AI integration for machine learning at scale on Google Cloud<br>
(b) Quick start code for ML at scale with Spark that can be repurposed for your data and experimentation<br>
(c) Terraform for provisioning a variety of Google Cloud data services that can be repurposed for your use case<br>

## 7. What's covered from an ML perspective
Telco Customer Churn Prediction with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) and [Spark MLLib, Random Forest Classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier)<br> 

### 7.1. Train a Spark MLlib model<br> 
 First in PySpark interactive notebooks, then via PySpark scripts<br> 
(a) Preprocessing <br> 
(b) Register managed dataset in Vertex AI<br> 
(c) Train a RandomForest classification model<br> 
(d) Evaluate the model - metrics and plots<br> 
(e) Conditional hyperparameter tuning<br> 
(f) a-e in a Vertex AI managed pipeline <br> 
(g) Event driven orchestration of Vertex AI managed pipeline execution with Cloud Scheduler<br> 

### 7.2. Scoring
(h) Batch scoring with the best model from 1(e), on Dataproc Serverless Spark <br>
(i) Orchestration of batch scoring on Cloud Composer/Apache Airflow <br>
(j) Stream scoring - Work in progress <br> 
(k) Online serving (MLeap, Vertex AI serving) - Will be added based on demand <br>

If you are not seeing a capability core to ML lifecycle, it was likely not supported at the time of the authoring of this lab. Keeping the lab current is best effort. Community contributions are welcome.

## 8. Solution Architecture


## 9. The lab modules
Follow in sequential order.
| # | Module | 
| -- | :--- |
| 01 |  Terraform for environment provisioning |
| 02 |  Preprocessing with serverless Spark interactive & Spark batches |
| 03 |  Model training with serverless Spark interactive & Spark batches |
| 04 |  Hyperparameter tuning  with serverless Spark interactive & Spark batches |
| 05 |  Batch scoring with serverless Spark interactive & Spark batches |
| 06 |  Authoring & testing a model training Vertex AI pipeline via notebook and UI |
| 07 |  Scheduling a model training Vertex AI pipeline with Cloud Scheduler |
| 08 |  Authoring an Airflow DAG for batch scoring and scheduling on Cloud Composer 2 |

## 10. Dont forget to 
Shut down/delete resources when done

## 11. Credits & Resources
| # | Collaborator | Contribution  | 
| -- | :--- | :--- |
| 1. | Anagha Khanolkar | Author - workshop vision, design, code, terraform automation, lab guide |
| 2. | Thomas Abraham | Consultation & testing |
| 3. | Ivan Nardini & Win Woo | Integration samples, Vertex AI & Spark integration expertise, & more |

## 12. Contributions welcome
Community contribution to improve the lab is very much appreciated. <br>

