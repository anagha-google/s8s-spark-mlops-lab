
# About

In this module we will create a Cloud Function that executes a Vertex AI pipeline on-demand based off of a pipeline JSON in GCS. This module takes 15 minutes to review, and almost an hour to run.

## 1. Where we are in the model training lifecycle

![M6](../06-images/module-6-01.png)   


<hr>

## 2. The lab environment

![M6](../06-images/module-6-02.png)   


<hr>

## 3. The exercise

![M6](../06-images/module-6-03.png)   

<hr>

## 4. Dependencies

1. Successful testing of pipeline template JSON
2. Customized Vertex AI Spark ML model training template JSON in GCS

We completed #1 in the prior module. #2 is already available for you in GCS.

![M6](../06-images/module-6-04.png)   

<hr>

## 5. Documentation for scheduling Vertex AI pipelines

Read the documentation for schedulng ahead of working on the next step to better understand on-demand execution of a pipeline with a simpler example than the one in the lab.<br>
https://cloud.google.com/vertex-ai/docs/pipelines/schedule-cloud-scheduler

<hr>

## 6. Cloud Function deployment pictorial overview

The folowing is the author's deployment from the Terraform script. Yours should be identical.

![M6](../06-images/module-6-05.png)   
<br><br>

![M6](../06-images/module-6-06.png)   
<br><br>

![M6](../06-images/module-6-07.png)   
<br><br>

![M6](../06-images/module-6-08.png)   
<br><br>

![M6](../06-images/module-6-09.png)   
<br><br>




## 7. Review of the Cloud Function code for executing the Vertex AI Spark ML Model Training Pipeline

### 7.1. What is happening inside the function?


### 7.2. Source code - requirements


### 7.3. Source code - main.py


<hr>

## 7. Execute the Cloud Function and monitor for pipeline execution through completion

<hr>
