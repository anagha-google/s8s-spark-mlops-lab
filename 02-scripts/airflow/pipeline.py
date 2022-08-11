# ======================================================================================
# ABOUT
# This script orchestrates batch scoring 
# ======================================================================================

import os
from airflow.models import Variable
from datetime import datetime
from airflow import models
from airflow.providers.google.cloud.operators.dataproc import (DataprocCreateBatchOperator,DataprocGetBatchOperator)
from datetime import datetime
from airflow.utils.dates import days_ago
import string
import random 

# .......................................................
# Variables
# .......................................................
randomizerCharLength = 10 
randomVal = ''.join(random.choices(string.digits, k = randomizerCharLength))

# {{
# a) For the Airflow operator 
"""
region = models.Variable.get("region")
subnet=models.Variable.get("subnet")
phsServer=Variable.get("phsServer")
containerImageUri=Variable.get("containerImageUri")
bqDataset=Variable.get("bqDataset")
umsaFQN=Variable.get("umsaFQN")
bqConnectorJarUri=Variable.get("bqConnectorJarUri")
# +
# b) For the Spark application
pipelineID=random.randint(1, 10000000)
projectID = models.Variable.get("projectID")
projectNbr = models.Variable.get("projectNbr")
modelVersion=Variable.get("modelVersion")
displayPrintStatements=True
"""
region = "us-central1"
subnet = "spark-snet"
phsServer = "s8s-sphs-505815944775"
containerImageUri = "gcr.io/spark-s8s-mlops/customer_churn_image:1.0.0"
bqDataset = "spark-s8s-mlops.customer_churn_ds"
umsaFQN = "s8s-lab-sa@spark-s8s-mlops.iam.gserviceaccount.com"
bqConnectorJarUri = "gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
# +
# b) For the Spark application

pipelineID=randomVal
projectID = "spark-s8s-mlops"
projectNbr = "505815944775"
modelVersion = "9923"
displayPrintStatements=True

# +
# Define DAG name
airflowDAGName= "customer_churn_prediction"
# +
# PySpark script to execute
scoringScript= "gs://s8s_code_bucket-"+projectNbr+"/pyspark/batch_scoring.py"
commonUtilsScript= "gs://s8s_code_bucket-"+projectNbr+"/pyspark/common_utils.py"
# +
# Arguments string
batchScoringArguments = [f"--pipelineID={pipelineID}", \
        f"--projectID={projectID}", \
        f"--projectNbr={projectNbr}", \
        f"--modelVersion={modelVersion}", \
        f"--displayPrintStatements={displayPrintStatements}" ]

# +
# Batch variables
batchIDPrefix = f"customer-churn-scoring-edo-{pipelineID}"
# }}

# .......................................................
# s8s Spark batch config
# .......................................................

s8sSparkBatchConfig = {
    "pyspark_batch": {
        "main_python_file_uri": scoringScript,
        "python_file_uris": [ commonUtilsScript ],
        "args": batchScoringArguments,
        "jar_file_uris": [ bqConnectorJarUri ]
    },
    "runtime_config": {
        "container_image": containerImageUri
    },
    "environment_config":{
        "execution_config":{
            "service_account": umsaFQN,
            "subnetwork_uri": subnet
            },
        "peripherals_config": {
            "spark_history_server_config": {
                "dataproc_cluster": f"projects/{projectID}/regions/{region}/clusters/{phsServer}"
                }
            }
        }
}


# .......................................................
# DAG
# .......................................................

with models.DAG(
    airflowDAGName,
    schedule_interval=None,
    start_date = days_ago(2),
    catchup=False,
) as scoringDAG:
    customerChurnPredictionStep = DataprocCreateBatchOperator(
        task_id="Predict_Customer_Churn",
        project_id=projectID,
        region=region,
        batch=s8sSparkBatchConfig,
        batch_id=batchIDPrefix 
    )
    customerChurnPredictionStep 
