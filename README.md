# Practical Machine Learning at scale with Spark on GCP and Vertex AI


## 1. About
This repo is a hands on lab for [Spark MLlib](https://spark.apache.org/docs/latest/ml-guide.html) based machine learning on Google Cloud, powered by Dataproc Serverless Spark and showcases integration with Vertex AI AIML platform. The focus is on demystifying the products and integration (and not about a perfect model), and features a minimum viable example of telco **Customer Churn Prediction** with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), and using [Random Forest classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier).

## 2. Format
The lab is fully scripted (no research needed), with (fully automated) environment setup, data, code, notebooks, orchestration, commands, and configuration. Clone the repo and follow the step by step instructions for an end to end MLOps experience.

## 3. Level
The level is arguable and depends on the individual's skills and experience with the paradigm, technology and cloud platform. In the author's opinion, the lab is loosely L300. 

## 4. Audience
The intended audience is anyone with access to Google Cloud and interested in the features showcased and want to kick the tires.

## 5. Prerequisites
Knowledge of Apache Spark, Machine Learning, and GCP products would be beneficial but is not entirely required, given the format of the lab. Access to Google Cloud is a must.

## 6. Goal
Simplify your learning and adoption journey of our product stack for scalable data science with - <br> 
(a) Just enough product knowledge of Dataproc Serverless Spark & Vertex AI integration for machine learning at scale on Google Cloud<br>
(b) Quick start code for ML at scale with Spark that can be repurposed for your data and ML experiments<br>
(c) Terraform for provisioning a variety of Google Cloud data services that can be repurposed for your use case<br>

## 7. Use case covered
Telco Customer Churn Prediction with a [Kaggle dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) and [Spark MLLib, Random Forest Classifer](https://spark.apache.org/docs/latest/ml-classification-regression.html#random-forest-classifier)<br> 

## 8. What's covered from an ML perspective<br> 

### 8.1. Authoring Spark Machine Learning Experiments
Dataproc Serveress Spark interactive Jupyter notebooks on Vertex AI Workbench, Managed Notebook instance is the recommended solution for interactive authoring of Spark code, both Data Engineering and Machine Learning. For operationalizing, create pyspark script versions of the code authored in the notebooks. Spark notebook scheduling is not supported yet. <br>

Here is what is covered in the lab:

| Step | Interactive Jupyter Notebook | Command line PySpark script execution | 
| -- | :--- | :--- |
| Preprocessing |  x | x |
| Spark ML Model Training, Metrics, Explainability |  x | x |
| Spark ML Model Hyperparameter Tuning |  x | x |
| Spark ML Model Batch Scoring |  x | x |

### 8.2. Operationalizing Model Training
Vertex AI managed pipelines is the recommended solution for operationalizing/orchestrating Spark ML model training on GCP. We will chain the PySpark scripts from 8.1, into a DAG and run it in a Vertex AI pipeline. The pipeline authoring will be done in a Jupyter notebook on Vertex AI Workbench, User-managed Notebook instance. For scheduling, Cloud Composer cant be used as there is not yet an Airflow operator for Vertex AI pipelines. We will therefore use Cloud Functions for executing the pipeline and Cloud Scheduler for scheduling.<br>

Here is what is covered in the lab:

| # | Operationalizing Step | 
| --- | :--- |
| 1 | Author a Vertex AI pipeline for Spark ML model training in a Jupyter Notebook including registering managed dataset, metrics and plots |
| 2 | Test the pipeline JSON via console | 
| 3 | Create a Cloud Function to launch the pipeline on demand | 
| 4 | Create a Cloud Scheduler job to call the Cloud Function for scheduled Spark ML model training | 
| 5 | Review of artifacts created by the pipeline and traceability | 


### 8.3. Operationalizing Batch Scoring
Cloud Composer is a viable option for batch scoring on Serverless Spark as there is no model monitoring and explainability for Spark batch scoring throuh Vertex AI pipeline orchestration. 

| # | Operationalizing Step | 
| --- | :--- |
| 1 | Author an Apache Airflow DAG for batch scoring, schedule and run it |
| 2 | Test DAG | 

If you are not seeing a capability core to ML lifecycle, it was likely not supported at the time of the authoring of this lab. Keeping the lab current is best effort. Community contributions are welcome.

## 8. Solution Architecture


## 9. The lab modules
Follow in sequential order.
| # | Module | 
| -- | :--- |
| 01 |  Lab guide: [Terraform for environment provisioning](../05-lab-guide/Module-01-Environment-Provisioning.md)<br> Services created: [Pictorial walkthrough](../05-lab-guide/Services-Created.md) |


## 10. Dont forget to 
Shut down/delete resources when done

## 11. Credits & Resources
| # | Collaborator | Contribution  | 
| -- | :--- | :--- |
| 1. | Anagha Khanolkar | Author - workshop vision, design, code, terraform automation, lab guide |
| 2. | Thomas Abraham | Consultation & testing |
| 3. | Ivan Nardini<br>Win Woo | Integration samples, Vertex AI & Spark integration roadmap, & more |

## 12. Contributions welcome
Community contribution to improve the lab is very much appreciated. <br>

