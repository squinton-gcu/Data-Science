Thesis Project - Draft2

## Purpose
The purpose of this data product is to investigate the relationship between stress and Alzheimer’s disease using metabolomics data. This product is a preliminary study to see if biomarkers can be determined to monitor the progression of Alzheimer’s disease (Aderemi et al., 2021; Clish, 2015; Csernansky et al., 2006; Gonzalez-Covarrubias et al., 2022; Justice, 2018). 
## Summary
This product is divided into five modules that will ingest the data, process the data, investigate the data, analyze the data, and produces a user interface. 
## Typical Users
The typical users for this application would be a bioinformatician or a data scientist with background knowledge in predictive modeling, data pipeline modeling, and metabolomics. Knowledge of Python and R are needed as well as the ability of understanding correlation graphs and heatmaps. 
##M odules and Instructions
### Processing Module
The processing module runs in R language as many of the libraries that are used only work in R. The five subfunctions of the processing module include missing value imputation, transformation, z-scaling, and outlier detection. 
The data is loaded from the CSV files, and the missing data is imputed using the MAI package from R that uses a NS-Knn model to add missing values to metabolomics datasets (Dekermanjian et al., 2022; Lee & Styczynski, 2018). The NS-knn imputation method will look ahead to a few values before adding in the missing value. A log2 transformation is then performed on the entire dataset (van den Berg et al., 2006). From there, any outliers are selected using the IQRX1.5 range (How to Remove Outliers in R | R-Bloggers, n.d.). Finally, the data is scaled using an internal function that uses the Z-scale (Scale Function - RDocumentation, n.d.; van den Berg et al., 2006).
The data is then saved as processed.csv.
### Feature Selection Module
The feature selection module is used to remove the excess metabolites that do not show a difference between Alzheimer's and no Alzheimer's as well as stress and no stress. This method runs in python where the main libraries that are used include scipy, sklearn RandomForestClassifier, and sklearn SelectFromModel (Pedregosa et al., 2011; Virtanen et al., 2020). 
The processed data is loaded into Python. It will split the data into a test train for the random forest. It will convert the samples to binary, for example, Alzheimer's versus normal. It will then run the random forest classifier with n_est set at 1000 trees and a random state of 42 to be consistent. The SelectFromModel package is used to pull the top features of about 100 features (Acharjee et al., 2020; Dubey, n.d.; Feature Selection Using Random Forest, 2017). It then applies the student’s t-test and selects the most significant features based on a p-value of 0.05. The t-test is used to only select features that are dramatically different between the two binary values (Difference Between T-Test and Linear Regression - Ask Any Difference, 2022; Mishra et al., 2019). It saves the subset features dataframe with the metabolite data and it saves the list of selected features. 
### Correlation Module 
The correlation module is used to explore the selected features further while also recording the spearman correlation, the logistic correlation pvalues, standard errors, and the RMSE values to help compare the data (Larose & Larose, 2019; Mukaka, 2012; Ramzai, 2021; Wu, 2021). It will determine if there are any similarities in the files between the selected features. For example, it will take the selected features for the stress study, and then check to see if there are any top values in the Alzheimer’s datasets. For those similar features, it will investigate the correlations. 
It saves the correlation metric results in the files, and it saves the subset data in another file that will be used in the user interface module. 
### Predictive Analysis Module
The predictive analysis module will look at the top features from the human trauma list and determine a logistic prediction within the Alzheimer's datasets. It reads in the data from the processing module and the correlation module. For the samples that are similar between the two, it will create a logistic regression predictive model and retrieve f1 score, accuracy, precision, and recall metrics (Larose & Larose, 2019). It will also generate confusion matrices. The results of this module are displayed in a table in the user interface module. 
### User Interface Module
The user interface module runs on a Shiny web application that is currently being hosted on shinyapp.io (Chang et al., 2022). at this link https://squinton2-datascience-gcu.shinyapps.io/implementation_io/
The user interface module displays the three metabolites. These metabolites are extracted during the correlation module. The data is the from the features selected in the trauma dataset and extracted from the features selected in the Alzheimer's dataset. The graphs are generated with ggplot2. The data table that is displayed is generated from the predictive analysis module to display the metrics. The data can sorted. The heatmap displays all selected and similar features across the data. The user can toggle between collection site to show the different results. 
## How to Use
The user can download the data from The Metabolomics Workbench from these four sets:
•	Serum metabolites in trauma patients versus healthy volunteers (Fhein, 2019). http://dx.doi.org/10.21228/M8ZH5N
•	Metabolic analysis of rat hippocampus and plasma in response to stress (Zhang, 2018). http://dx.doi.org/10.21228/M8MT2H
•	Metabolites of Alzheimer’s disease in CSF (Peterson, 2014). http://dx.doi.org/10.21228/ M88G6G
•	Metabolites of Alzheimer’s disease in plasma (Peterson, 2014). http://dx.doi.org/10.21228/ M88G6G
This work is supported by NIH grant U2C-DK119886. The modules are in a Docker file on Google Cloud run. The path to the datasets needs to be initialized in the Docker Image file. Once the Docker Image is initialized, the application will run, produce the results and then display the shiny web application. Without the Docker application, each module can be executed one after the other in this order:
1.	Processing Module
2.	Feature Selection Module
3.	Correlation Module
4.	Predictive Analysis Module
5.	Implementation Module

For further detailed information on the modules, please review their own README files. 
