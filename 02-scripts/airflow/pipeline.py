# ======================================================================================
# ABOUT
# This script orchestrates the execution of batch scoring 
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

# Read environment variables into local variables
project_id = models.Variable.get("project_id")
region = models.Variable.get("region")
subnet=models.Variable.get("subnet")
phs_server=Variable.get("phs")
code_bucket=Variable.get("code_bucket")
bq_dataset=Variable.get("bq_dataset")
umsa=Variable.get("umsa")

# Define DAG name
dag_name= "customer_churn_prediction"

# User Managed Service Account FQN
service_account_id= umsa+"@"+project_id+".iam.gserviceaccount.com"

# PySpark script to execute
scoring_script= "gs://"+code_bucket+"/scripts/pyspark/batch_scoring.py"


# This is to add a random suffix to the serverless Spark batch ID that needs to be unique each run 
# ...Define the random module
S = 10  # number of characters in the string.
# call random.choices() string module to find the string in Uppercase + numeric data.
ran = ''.join(random.choices(string.digits, k = S))

BATCH_ID = "airflow-"+str(ran)

BATCH_CONFIG1 = {
    "pyspark_batch": {
        "main_python_file_uri": scoring_script,
        "args": [
          code_bucket
        ],
        "jar_file_uris": [
      "gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
    ]
    },
    "environment_config":{
        "execution_config":{
              "service_account": service_account_id,
            "subnetwork_uri": subnet
            },
        "peripherals_config": {
            "spark_history_server_config": {
                "dataproc_cluster": f"projects/{project_id}/regions/{region}/clusters/{phs_server}"
                }
            },
        },
}

with models.DAG(
    dag_name,
    schedule_interval=None,
    start_date = days_ago(2),
    catchup=False,
) as dag_serverless_spark_batch_scoring:
    customer_churn_prediction = DataprocCreateBatchOperator(
        task_id="Predict_Customer_Churn",
        project_id=project_id,
        region=region,
        batch=BATCH_CONFIG1,
        batch_id=BATCH_ID 
    )

    customer_churn_prediction 
