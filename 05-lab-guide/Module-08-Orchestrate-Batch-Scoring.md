
# About

This module covers orchestrating Spark ML batch scoring with Apache Airflow on Cloud Composer. Vertex AI pipelines has deliberately not been used as it lacks support for model monitoring and explainability and is not suited for upstream job orchestration typical with batch scoring and that may not be ML related.

## 1. Where we are in the SparK ML model lifecycle

![M8](../06-images/module-8-01.png)   
<br><br>

## 2. The lab environment

![M8](../06-images/module-8-02.png)   
<br><br>

## 3. The exercise

![M8](../06-images/module-8-03.png)   
<br><br>

## 4. Review of the Cloud Composer Environment setup

Module 1 created and configured your Cloud Composer environment, including Airflow variables import and upload of the precreated Apache Airflow DAG into the Cloud Composer DAG bucket. In this section, we will walkthrough the author's environment.

### 4a. Cloud Composer environment

![CC2](../06-images/module-1-composer-01.png)   
<br><br>

![CC2](../06-images/module-1-composer-02.png)   
<br><br>

### 4b. Cloud Composer - Airflow variables

![CC2](../06-images/module-1-composer-03.png)   
<br><br>

![CC2](../06-images/module-1-composer-04.png)   
<br><br>

### 4c. Cloud Composer - Airflow DAG

![CC2](../06-images/module-1-composer-07.png)   
<br><br>

![CC2](../06-images/module-1-composer-08.png)   
<br><br>

### 4d. Cloud Composer - Airflow GUI

![CC2](../06-images/module-1-composer-05.png)   
<br><br>

![CC2](../06-images/module-1-composer-06.png)   
<br><br>


