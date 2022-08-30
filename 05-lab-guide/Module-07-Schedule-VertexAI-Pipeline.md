
# About

This module covers creating a Cloud Scheduler job to trigger the Vertex AI Spark ML model training pipeline via the Cloud Function we created in the prior module. The approximate time for the module content review is 15 minutes but the pipeline execution could take an hour.

## 1. Where we are in the SparK ML model lifecycle

![M8](../06-images/module-7-01.png)   
<br><br>

## 2. The lab environment

![M8](../06-images/module-7-02.png)   
<br><br>

## 3. The exercise

![M8](../06-images/module-7-03.png)   
<br><br>

## 4. Review the Cloud Scheduler job configuration

A Cloud Scheduler job has been precreated for you that calls the Cloud Function which inturn calls the Vertex AI Spark ML pipeline we created in module 5. Lets walk through the setup in the author's environment.

![CS](../06-images/module-1-cloud-scheduler-01.png)   
<br><br>

![CS](../06-images/module-1-cloud-scheduler-02.png)   
<br><br>

![CS](../06-images/module-1-cloud-scheduler-03.png)   
<br><br>

![CS](../06-images/module-1-cloud-scheduler-04.png)   
<br><br>

![CS](../06-images/module-1-cloud-scheduler-05.png)   
<br><br>

## 5. Run the Cloud Scheduler job manually to test it

![M8](../06-images/module-7-04.png)   
<br><br>

## 6. Monitor the exeuction through completion of the pipeline execution
~ 1 hour

![M8](../06-images/module-7-05.png)   
<br><br>

![M8](../06-images/module-7-06.png)   
<br><br>

![M8](../06-images/module-7-07.png)   
<br><br>

