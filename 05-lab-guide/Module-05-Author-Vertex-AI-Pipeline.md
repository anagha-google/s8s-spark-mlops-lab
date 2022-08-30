
# About

In this module, we will author and test a Vertex AI pipeline to orchestrate the Spark ML model training and prepare for operationalizing the same. The module takes about an hour to complete.

## 1. Where we are in the model development lifecycle

![M5](../06-images/module-5-01.png)   
<br><br>

<hr>

## 2. The lab environment

![M5](../06-images/module-5-02.png)   
<br><br>

<hr>

## 3. The exercise

![M5](../06-images/module-5-03.png)   
<br><br>

<hr>

## 4. About Vertex AI pipelines & support for Spark ML Models in Vertex AI platform
We will use Vertex AI User Managed Notebook environment for this exercise and this is already created for you. When you open JupyterLab, you will also see a pre-created, customized notebook to get quick-started with learning pipeline authoring.

### 4.1. Vertex AI pipelines - basics

Vertex AI Pipelines helps you to automate, monitor, and govern your ML systems by orchestrating your ML workflow in a serverless manner, and storing your workflow's artifacts using Vertex ML Metadata. By storing the artifacts of your ML workflow in Vertex ML Metadata, you can analyze the lineage of your workflow's artifacts — for example, an ML model's lineage may include the training data, hyperparameters, and code that were used to create the model.

Vertex AI Pipelines let you automate, monitor, and experiment with interdependent parts of a ML workflow. Vertex AI ML Pipelines are portable, scalable, and based on containers. Each individual part of your pipeline workflow (for example, creating a dataset or training a model) is defined by code. This code is referred to as a component. Each instance of a component is called a step.

Watch this [short video on vertex AI pipelines](https://youtu.be/Jrh-QLrVCvM) and [read the documentation](https://cloud.google.com/vertex-ai/docs/pipelines/introduction).

### 4.2. What is supported/recommended for Spark ML models in Vertex AI from an MLOps perspective?

| # | Feature/Function | Supported? |  Recommended Product/Service | Workaround | Nuances/Comments | 
| -- | :--- | :--- |:--- |:--- |:--- |
| 1 | Development Environment for Model Training<br>and<br>corressponding Spark Infrastructure| Yes | Vertex AI Workbench Managed Notebook<br>with<br>Dataproc Serverless Spark Interactive Sessions | | Preview as of 8/22|
| 2 | Orchestration solution for Model Training | Yes | Vertex AI Managed Pipelines | | Preview as of 8/22|
| 3 | Development Environment for Model Training Orchestration | Yes | Vertex AI Workbench User-Managed Notebooks | | |
| 4 | Spark Infrastructure for Model Training Orchestration  | Yes | Dataproc Serverless Spark Batches | | |
| 5 | Scheduling solution for Model Training Pipeline  | Yes | Cloud Scheduler<br>calling<br>Cloud Function<br>calling<br>Vertex AI pipeline REST API | | |
| 6 | Model Registry  | No | | Persist to GCS | |
| 7 | Training Dataset  | Yes | Vertex AI managed datasets |  | |
| 8 | Feature Store  | Yes | Vertex AI managed datasets |  | |
| 9 | Model Metadata  | Yes | Vertex AI metadata |  | |
| 10 | Solution for Batch Scoring  | Yes | Dataproc Serverless Spark Batches  |  | Vertex AI batches can be used but requires MLEAP package which does not support recent versions of Spark |
| 11 | Solution for (near) Real Time/Stream Scoring  | Yes | Dataproc Spark on GCE  |  |  |
| 12 | Solution for Online/On-demand Scoring  | Yes | Vertex AI online serving  |  | Requires MLEAP package which does not support recent versions of Spark |
| 13 | Explainability | Yes | with<br>Vertex AI online/batch serving  |  | Requires MLEAP package which does not support recent versions of Spark |
| 14 | Model Monitoring | Yes | with<br>Vertex AI online/batch serving  |  | Requires MLEAP package which does not support recent versions of Spark |

<hr>

## 5. Authoring and operationalizing Vertex AI pipelines

### 5.1. Authoring a pipeline in a notebook - what's involved

![M5](../06-images/module-5-05.png)   
<br><br>

### 5.2. Taking a pipeline developed in a notebook to production - steps involved

![M5](../06-images/module-5-04.png)   
<br><br>

## 6. Review and execute the pre-authored Vertex AI pipeline from the Jupyter notebook

### 6.1. Open the pipeline notebook

![M5](../06-images/module-5-06.png)   
<br><br>

![M5](../06-images/module-5-07.png)   
<br><br>

### 6.2. Install dependencies

Be sure to uncomment the cell that installs dependencies and restarts kernel, once and comment it back.
![M5](../06-images/module-5-08.png)   
<br><br>

### 6.3. Study the notebook
Read through the notebook before you run it.

- Note how it calls all the PySpark batch jobs we tested in module 3
- Note how it uses your network (instead of Vertex AI network)
- Note how it does not use caching at a task/component/step level and at a pipeline job level
- Note how it uses a custom pipeline name

### 6.4. Run the pipeline notebook in entirety


### 6.5. Click on the Pipeline link and study it


### 6.6. Visit the Dataproc Batches UI and monitor the pipeline steps



### 6.7. View the metrics from the model training step



### 6.8. View the plots from the model training step


### 6.9. Study the pipeline JSON - last cell of the notebook



## 7. Test the JSON via Vertex AI pipeline UI




## 8. Edit the JSON for on-demand REST calls & persist in GCS



<hr>

This concludes the module. In the [next module](../05-lab-guide/Module-06-Author-CloudFunction-For-Vertex-AI-Pipeline.md) you will create a Cloud Function to execute the Vertex AI Spark ML pipeline.

<hr>
