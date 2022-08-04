#!/bin/bash

#This script will run the entire pipeline in one go
#It will be deployed in the Docker Image

Rscript application/Processing_Module.r

sleep 5

python application/feature_selection_module.py 

sleep 5

python application/correlation_module.py 

sleep 5

python application/predictive_analysis_module.py 

sleep 5

bash application/shiny-server.sh
