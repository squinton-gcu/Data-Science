#!/bin/bash

#This script will run the entire pipeline in one go
#It will be deployed in the Docker Image

Rscript Processing_Module.r

sleep 5

python feature_selection_module.py 

sleep 5

python correlation_module.py 

sleep 5

python predictive_analysis_module.py 

sleep 5

Rscript App.R 