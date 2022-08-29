# About
The recommended GCP solution for scalable Spark based ML code interactive authoring is Serverless Spark notebooks on Vertex AI Workbench, Managed Notebooks. In this lab module, we will go through the typical data science/ML engineering work - preprocess data, train & test model, tune model, and do some scoring. Since this lab is focused on demystifying the integration, the notebooks are pre-created for you, so you can quickly understand the integration.

<hr>

## 1. Use case recap
Telco Customer Churn Prediction with a Kaggle dataset and Spark MLLib, Random Forest Classifer

<hr>

## 2. The data used in the experiment
Training and scoring data are available in GCS in the data bucket and the data is in CSV format.

<hr>

## 3. The environment for the module
Vertex AI Workbench, Managed notebook instance. We will reuse kernel created in the prior module.

<hr>

## 4. The architecture for the module

<hr>

## 5. Step 1: Preprocessing

### 5.1. Run the pre-processing notebook

### 5.2. Review the pre-processed data in BigQuery

### 5.3. Visit the Dataproc UI for the session

### 5.4. Visit the Spark History Server UI for the session

### 5.5. Review the notebook equivalent PySpark script in GCS for this step

<hr>

## 6. Step 2: Model Training

### 6.1. Run the model training notebook

### 6.2. Review the model persisted in GCS

### 6.3. Review the model metrics persisted in GCS

### 6.4. Review the model metrics persisted in BigQuery

### 6.5. Review the model feature importance scores persisted in BigQuery

### 6.6. Review the model test results in BigQuery

### 6.7. Review the notebook equivalent PySpark script in GCS for this step

<hr>

## 7. Step 3: Hyperparamater Tuning

### 7.1. Run the model tuning notebook

### 7.2. Review the model persisted in GCS

### 7.3. Review the model metrics persisted in BigQuery

### 7.4. Review the model test results in BigQuery

<hr>

## 8. Step 4: Batch Scoring

<hr>

This concludes the lab module where you learned to author ML experiments on interactive Spark notebooks. Proceed to the next module where you will learn to execute equivalent Spark ML PySpark scripts via command line powered by Dataproc Serverless Spark batches.
