# Practical Machine Learning at scale with Spark on GCP and Vertex AI


## 1. About

This repo is a hands on lab for [Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html) based machine learning on Google Cloud, powered by Dataproc Serverless Spark and showcases integration with Vertex AI AIML platform. The focus is on demystifying the products and integration (and not about a perfect model), and features a minimum viable end to end machine learning use case.

## 2. Format & Duration
The lab is fully scripted (no research needed), with (fully automated) environment setup, data, code, commands, notebooks, orchestration, and configuration. Clone the repo and follow the step by step instructions for an end to end MLOps experience. Expect to spend a minimum of 5-6 hours to fully understand and execute if new to GCP and the services.

## 3. Level
L300 - framework (Spark), services/products, integration 

## 4. Audience
The intended audience is anyone with (access to Google Cloud and) interest in the usecase, products and features showcased.

## 5. Prerequisites
Knowledge of Apache Spark, Machine Learning, and GCP products would be beneficial but is not entirely required, given the format of the lab. Access to Google Cloud is a must unless you want to just read the content.

## 6. Goal
Simplify your learning and adoption journey of our product stack for scalable data science with - <br> 
1. Just enough product knowledge of Dataproc Serverless Spark & Vertex AI integration for machine learning at scale on Google Cloud<br>
2. Quick start code for ML at scale with Spark that can be repurposed for your data and ML experiments<br>
3. Terraform for provisioning a variety of Google Cloud data services that can be repurposed for your use case<br>

## 7. Use case covered
Telco Customer Churn Prediction with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) and [Spark MLLib, Random Forest Classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier)<br> 

## 8. GCP services used in the lab & rationalization

## 9. Solution Architecture

## 10. Flow of the lab

## 11. The lab modules
Complete the lab modules in a sequential manner. For a better lab experience, read *all* the modules and then start working on them.
| # | Module | 
| -- | :--- |
| 01 |  [Terraform for environment provisioning](05-lab-guide/Module-01-Environment-Provisioning.md)|
| 02 |  [Tutorial on Dataproc Serverless Spark Interactive Sessions for authoring Spark code](05-lab-guide/Module-02-Spark-IDE-on-GCP.md)|
| 03 |  [Author PySpark ML experiments with Serverless Spark Interactive notebooks](../05-lab-guide/Module-03-Author-ML-Experiments-With-Spark-Notebooks.md)|
| 04 |  [Author PySpark ML scripts in preparation for authoring a model training pipeline](../05-lab-guide/Module-04-Author-ML-PySpark-Scripts.md)|
| 05 |  [Author a Vertex AI model training pipeline](../05-lab-guide/Module-05-Author-Vertex-AI-Pipeline.md)|
| 06 |  [Author a Cloud Function that calls your Vertex AI model training pipeline](../05-lab-guide/Module-06-Author-CloudFunction-For-Vertex-AI-Pipeline.md)|
| 07 |  [Create a Cloud Scheduler job that invokes the Cloud Function you created](../05-lab-guide/Module-07-Schedule-VertexAI-Pipeline.md)|
| 08 |  [Author a Cloud Composer Airflow DAG for batch scoring and schedule it](../05-lab-guide/Module-08-Orchestrate-Batch-Scoring.md)|

## 12. Dont forget to 
Shut down/delete resources when done

## 13. Credits
| # | Collaborator | Contribution  | 
| -- | :--- | :--- |
| 1. | Anagha Khanolkar | Creator |
| 2. | Dr. Thomas Abraham | Guidance, testing and feedback |
| 3. | Ivan Nardini<br>Win Woo | Consultation, integration samples, Vertex AI & Spark integration roadmap, & more |

## 14. Contributions welcome
Community contribution to improve the lab is very much appreciated. <br>

