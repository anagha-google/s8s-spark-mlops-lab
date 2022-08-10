#!/bin/bash

#........................................................................
# Purpose: Copy existing notebooks to Workbench server Jupyter home dir
# (User-managed notebook server)
#........................................................................

gsutil cp gs://s8s_notebook_bucket-PROJECT_NBR/vai-pipelines/*.ipynb /home/jupyter/ 
chown jupyter:jupyter /home/jupyter/* 