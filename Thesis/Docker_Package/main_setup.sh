#!/bin/bash

#This script will run the entire pipeline in one go
#It will be deployed in the Docker Image

Rscript application/processing_module.r

sleep 5

python3 application/feature_selection_module.py 

sleep 5

python3 application/correlation_module.py 

sleep 5

python3 application/predictive_analysis_module.py 

#sleep 5

#Rscript application/launch.r
