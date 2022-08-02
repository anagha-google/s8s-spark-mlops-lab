# ............................................................
# Hyperparamater tuning
# ............................................................
# This script does hyperparameter tuning of a Random Forest 
# Classification model for the customer churn prediction experiment-
# 1. Reads source data from BigQuery as a source,
# 2. Writes model to GCS
# 3. Captures and persists model metrics to GCS and BigQuery
# 4. Writes model test results to BigQuery
# ............................................................

from pyspark.sql import SparkSession
from pyspark.ml import Pipeline
from pyspark.ml.feature import OneHotEncoder, StringIndexer, VectorAssembler
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.mllib.evaluation import MulticlassMetrics
from pyspark.sql.types import FloatType
import pyspark.sql.functions as F
from pyspark.ml.feature import StringIndexer
import pandas as pd
import sys, logging, argparse
import common_utils

def fnParseArguments():
# {{ Start 
    """
    Purpose:
        Parse arguments received by script
    Returns:
        args
    """
    argsParser = argparse.ArgumentParser()
    argsParser.add_argument(
        '--pipelineID',
        help='Unique ID for the pipeline stages for traceability',
        type=str,
        required=True)
    argsParser.add_argument(
        '--projectNbr',
        help='The project number',
        type=str,
        required=True)
    argsParser.add_argument(
        '--projectID',
        help='The project id',
        type=str,
        required=True)
    argsParser.add_argument(
        '--displayPrintStatements',
        help='Boolean - print to screen or not',
        type=bool,
        required=True)
    return argsParser.parse_args()
# }} End fnparseArguments()

def fnMain(logger, args):
# {{ Start main

    # 1a. Arguments
    pipelineID = args.pipelineID
    projectNbr = args.projectNbr
    projectID = args.projectID
    displayPrintStatements = args.displayPrintStatements

    # 1b. Variables 
    appBaseName = "customer-churn-model"
    appNameSuffix = "hyperparameter-tuning"
    appName = f"{appBaseName}-{appNameSuffix}"
    modelBaseNm = appBaseName
    modelVersion = pipelineID
    bqDatasetNm = f"{projectID}.customer_churn_ds"
    operation = appNameSuffix
    bigQuerySourceTableFQN = f"{bqDatasetNm}.training_data"
    bigQueryModelTestResultsTableFQN = f"{bqDatasetNm}.test_predictions"
    bigQueryModelMetricsTableFQN = f"{bqDatasetNm}.model_metrics"
    modelBucketUri = f"gs://s8s_model_bucket-{projectNbr}/{modelBaseNm}/{operation}/{modelVersion}"
    metricsBucketUri = f"gs://s8s_metrics_bucket-{projectNbr}/{modelBaseNm}/{operation}/{modelVersion}"
    scratchBucketUri = f"s8s-spark-bucket-{projectNbr}/{appBaseName}/pipelineId-{pipelineID}/{appNameSuffix}/"
    pipelineExecutionDt = datetime.now().strftime("%Y%m%d%H%M%S")

    # Other variables, constants
    SPLIT_SEED = 6
    SPLIT_SPECS = [0.8, 0.2]
    MAX_DEPTH = [5, 10, 15]
    MAX_BINS = [24, 32, 40]
    N_TREES = [25, 30, 35]
    N_FOLDS = 5

    # 1c. Display input and output
    if displayPrintStatements:
        print("Starting hyperparameter tuning for *Customer Churn* experiment")
        print(".....................................................")
        print(f"The datetime now is - {pipelineExecutionDt}")
        print(" ")
        print("INPUT PARAMETERS")
        print(f"....pipelineID={pipelineID}")
        print(f"....projectID={projectID}")
        print(f"....projectNbr={projectNbr}")
        print(f"....displayPrintStatements={displayPrintStatements}")
        print(" ")
        print("EXPECTED SETUP")  
        print(f"....BQ Dataset={bqDatasetNm}")
        print(f"....Model Training Source Data in BigQuery={bigQuerySourceTableFQN}")
        print(f"....Scratch Bucket for BQ connector=gs://s8s-spark-bucket-{projectNbr}") 
        print(f"....Model Bucket=gs://s8s-model-bucket-{projectNbr}")  
        print(f"....Metrics Bucket=gs://s8s-metrics-bucket-{projectNbr}") 
        print(" ")
        print("OUTPUT")
        print(f"....Model in GCS={modelBucketUri}")
        print(f"....Model metrics in GCS={metricsBucketUri}")  
        print(f"....Model metrics in BigQuery={bigQueryModelMetricsTableFQN}")      
        print(f"....Model test results in BigQuery={bigQueryModelTestResultsTableFQN}")

    try:
        # 2. Spark config
        print('....Setting Spark config')
        spark = SparkSession.builder.appName(appName).getOrCreate()
        # Spark configuration setting for writes to BigQuery
        spark.conf.set("parentProject", projectID)
        spark.conf.set("temporaryGcsBucket", scratchBucketUri)
        spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")

        # 3. Pre-process training data
        print('....Data pre-procesing')
        dataPreprocessingStagesList = []
        # 3a. Create and append to pipeline stages - string indexing and one hot encoding
        for eachCategoricalColumn in common_utils.CATEGORICAL_COLUMN_LIST:
            # Category indexing with StringIndexer
            stringIndexer = StringIndexer(inputCol=eachCategoricalColumn, outputCol=eachCategoricalColumn + "Index")
            # Use OneHotEncoder to convert categorical variables into binary SparseVectors
            encoder = OneHotEncoder(inputCols=[stringIndexer.getOutputCol()], outputCols=[eachCategoricalColumn + "classVec"])
            # Add stages.  This is a lazy operation
            dataPreprocessingStagesList += [stringIndexer, encoder]

        # 3b. Convert label into label indices using the StringIndexer and append to pipeline stages
        labelStringIndexer = StringIndexer(inputCol="churn", outputCol="label")
        dataPreprocessingStagesList += [labelStringIndexer]

        # 4. Feature engineering
        print('....Feature engineering')
        featureEngineeringStageList = []
        assemblerInputs = common_utils.NUMERIC_COLUMN_LIST + [c + "classVec" for c in common_utils.CATEGORICAL_COLUMN_LIST]
        featuresVectorAssembler = VectorAssembler(inputCols=assemblerInputs, outputCol="features")
        featureEngineeringStageList += [featuresVectorAssembler]

        # 5. Model training
        print('....Model training')
        modelTrainingStageList = []
        rfClassifier = RandomForestClassifier(labelCol="label", featuresCol="features")
        modelTrainingStageList += [rfClassifier]

       # 6. Create a model training pipeline for stages defined
        print('....Instantiating pipeline model')
        pipeline = Pipeline(stages=dataPreprocessingStagesList + featureEngineeringStageList + modelTrainingStageList)   

        # 7. Hyperparameter tuning & cross validation
        print('....Hyperparameter tuning & cross validation')
        parameterGrid = (ParamGridBuilder()
                    .addGrid(modelTrainingStageList[0].maxDepth, MAX_DEPTH)
                    .addGrid(modelTrainingStageList[0].maxBins, MAX_BINS)
                    .addGrid(modelTrainingStageList[0].numTrees, N_TREES)
                    .build())

        evaluator = BinaryClassificationEvaluator(labelCol="label")
        crossValidatorPipeline = CrossValidator(estimator=pipeline,
                                        estimatorParamMaps=parameterGrid,
                                        evaluator=evaluator,
                                        numFolds=N_FOLDS)

        # 8. Read training data
        print('....Reading training dataset')
        inputDF = spark.read \
            .format('bigquery') \
            .load(bigQuerySourceTableFQN)


        # Typecast some columns to the right datatype
        inputDF = inputDF.withColumn("partner", inputDF.partner.cast('string')) \
            .withColumn("dependents", inputDF.dependents.cast('string')) \
            .withColumn("phone_service", inputDF.phone_service.cast('string')) \
            .withColumn("paperless_billing", inputDF.paperless_billing.cast('string')) \
            .withColumn("churn", inputDF.churn.cast('string')) \
            .withColumn("monthly_charges", inputDF.monthly_charges.cast('float')) \
            .withColumn("total_charges", inputDF.total_charges.cast('float'))

        # 9. Split to training and test datasets
        print('....Splitting the dataset')
        trainDF, testDF = inputDF.randomSplit(SPLIT_SPECS, seed=SPLIT_SEED)

        # 10. Fit the model; Takes tens of minutes, repartition as needed
        trainDF.repartition(300)
        pipelineModel = crossValidatorPipeline.fit(trainDF)

        # 11. Persist model to GCS
        pipelineModel.write().overwrite().save(modelBucketUri)

        # 12. Test the model with the test dataset
        print('....Testing the model')
        predictionsDF = pipelineModel.transform(testDF)
        predictionsDF.show(2)

        # 13. Persist model testing results to BigQuery
        predictionsWithPipelineIdDF = predictionsDF.withColumn("pipeline_id", lit(pipelineID)) \
                                        .withColumn("model_version", lit(pipelineID)) \
                                        .withColumn("pipeline_execution_dt", lit(pipelineExecutionDt)) \
                                        .withColumn("operation", lit(operation)) 

        predictionsWithPipelineIdDF.write.format('bigquery') \
        .mode("overwrite")\
        .option('table', bigQueryModelTestResultsTableFQN) \
        .save()

        def fnCaptureModelMetrics(predictionsDF, labelColumn, operation):
            """
            Get model metrics
            Args:
                predictions: predictions
                labelColumn: target column
                operation: train or test
            Returns:
                metrics: metrics
                
            Anagha TODO: This function if called from common_utils fails; Need to researchy why
            """
            
            metricLabels = ['area_roc', 'area_prc', 'accuracy', 'f1', 'precision', 'recall']
            metricColumns = ['true', 'score', 'prediction']
            metricKeys = [f'{operation}_{ml}' for ml in metricLabels] + metricColumns

            # Instantiate evaluators
            bcEvaluator = BinaryClassificationEvaluator(labelCol=labelColumn)
            mcEvaluator = MulticlassClassificationEvaluator(labelCol=labelColumn)

            # Capture metrics -> areas, acc, f1, prec, rec
            area_roc = round(bcEvaluator.evaluate(predictionsDF, {bcEvaluator.metricName: 'areaUnderROC'}), 5)
            area_prc = round(bcEvaluator.evaluate(predictionsDF, {bcEvaluator.metricName: 'areaUnderPR'}), 5)
            acc = round(mcEvaluator.evaluate(predictionsDF, {mcEvaluator.metricName: "accuracy"}), 5)
            f1 = round(mcEvaluator.evaluate(predictionsDF, {mcEvaluator.metricName: "f1"}), 5)
            prec = round(mcEvaluator.evaluate(predictionsDF, {mcEvaluator.metricName: "weightedPrecision"}), 5)
            rec = round(mcEvaluator.evaluate(predictionsDF, {mcEvaluator.metricName: "weightedRecall"}), 5)

            # Get the true, score, prediction off of the test results dataframe
            rocDictionary = common_utils.fnGetTrueScoreAndPrediction(predictionsDF, labelColumn)
            true = rocDictionary['true']
            score = rocDictionary['score']
            prediction = rocDictionary['prediction']

            # Create a metric values array
            metricValuesArray = [] 
            metricValuesArray.extend((area_roc, area_prc, acc, f1, prec, rec))
            #metricValuesArray.extend((area_roc, area_prc, acc, f1, prec, rec, true, score, prediction))
            
            # Zip the keys and values into a dictionary  
            metricsDictionary = dict(zip(metricKeys, metricValuesArray))

            return metricsDictionary
        # }} End fnCaptureModelmetrics

        # 14. Capture & display metrics
        hyperParameterTunedModelMetrics = fnCaptureModelMetrics(predictionsDF, "label", "test")
        for m, v in hyperParameterTunedModelMetrics.items():
            print(f'{m}: {v}')

        # 15. Persist metrics to BigQuery
        metricsDF = spark.createDataFrame(hyperParameterTunedModelMetrics.items(), ["metric_nm", "metric_value"]) 
        metricsWithPipelineIdDF = metricsDF.withColumn("pipeline_id", lit(pipelineID)) \
                                        .withColumn("model_version", lit(pipelineID)) \
                                        .withColumn("pipeline_execution_dt", lit(pipelineExecutionDt)) \
                                        .withColumn("operation", lit(operation)) 

        metricsWithPipelineIdDF.show()
        metricsWithPipelineIdDF.write.format('bigquery') \
        .mode("overwrite")\
        .option('table', bigQueryModelMetricsTableFQN) \
        .save()

        # 16. Persist metrics to GCS
        blobName = f"{modelBaseNm}/{operation}/{modelVersion}/metrics.json"
        common_utils.fnPersistMetrics(urlparse(metricsBucketUri).netloc, hyperParameterTunedModelMetrics, blobName)

    except RuntimeError as coreError:
            logger.error(coreError)
    else:
        logger.info('Successfully completed model training!')

# }} End fnMain()

def fnConfigureLogger():
# {{ Start 
    """
    Purpose:
        Configure a logger for the script
    Returns:
        Logger object
    """
    logFormatter = logging.Formatter('%(asctime)s - %(filename)s - %(levelname)s - %(message)s')
    logger = logging.getLogger("data_engineering")
    logger.setLevel(logging.INFO)
    logger.propagate = False
    logStreamHandler = logging.StreamHandler(sys.stdout)
    logStreamHandler.setFormatter(logFormatter)
    logger.addHandler(logStreamHandler)
    return logger
# }} End fnConfigureLogger()

if __name__ == "__main__":
    arguments = fnParseArguments()
    logger = fnConfigureLogger()
    fnMain(logger, arguments)