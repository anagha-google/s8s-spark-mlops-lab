#!/bin/bash

#........................................................................
# Purpose: Copy existing notebooks to Workbench server Jupyter home dir
# (Managed notebook server)
#........................................................................

gsutil cp gs://s8s_notebook_bucket-PROJECT_NBR/pyspark/*.ipynb /home/jupyter/ 
chown jupyter:jupyter /home/jupyter/* 