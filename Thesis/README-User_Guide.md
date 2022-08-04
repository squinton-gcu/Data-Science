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
-	Serum metabolites in trauma patients versus healthy volunteers (Fhein, 2019). http://dx.doi.org/10.21228/M8ZH5N
-	Metabolic analysis of rat hippocampus and plasma in response to stress (Zhang, 2018). http://dx.doi.org/10.21228/M8MT2H
-	Metabolites of Alzheimer’s disease in CSF (Peterson, 2014). http://dx.doi.org/10.21228/ M88G6G
-	Metabolites of Alzheimer’s disease in plasma (Peterson, 2014). http://dx.doi.org/10.21228/ M88G6G
This work is supported by NIH grant U2C-DK119886. The modules are in a Docker file on Google Cloud run. The path to the datasets needs to be initialized in the Docker Image file. Once the Docker Image is initialized, the application will run, produce the results and then display the shiny web application. Without the Docker application, each module can be executed one after the other in this order:
1.	Processing Module
2.	Feature Selection Module
3.	Correlation Module
4.	Predictive Analysis Module
5.	Implementation Module

For further detailed information on the modules, please review their own README files. 

#### References
- Acharjee, A., Larkman, J., Xu, Y., Cardoso, V. R., & Gkoutos, G. V. (2020). A random forest based biomarker discovery and power analysis framework for diagnostics research. BMC Medical Genomics, 13(1), 178. https://doi.org/10.1186/s12920-020-00826-6
- Aderemi, A. V., Ayeleso, A. O., Oyedapo, O. O., & Mukwevho, E. (2021). Metabolomics: A Scoping Review of Its Role as a Tool for Disease Biomarker Discovery in Selected Non-Communicable Diseases. Metabolites, 11(7), 418. https://doi.org/10.3390/metabo11070418
- Chang, W., Cheng, J., Allaire, J. J., Sievert, C., Schloerke, B., Xie, Y., Allen, J., McPherson, J., Dipert, A., Borges, B., RStudio, library),  jQuery F. (jQuery library and jQuery U., inst/www/shared/jquery-AUTHORS.txt),  jQuery contributors (jQuery library; authors listed in, inst/www/shared/jqueryui/AUTHORS.txt),  jQuery U. contributors (jQuery U. library; authors listed in, library), M. O. (Bootstrap, library), J. T. (Bootstrap, library), B. contributors (Bootstrap, Twitter, library), I. (Bootstrap, … R), R. C. T. (tar implementation from. (2022). shiny: Web Application Framework for R (1.7.2). https://CRAN.R-project.org/package=shiny
- Clish, C. B. (2015). Metabolomics: An emerging but powerful tool for precision medicine. Molecular Case Studies, 1(1), a000588. https://doi.org/10.1101/mcs.a000588
- Csernansky, J. G., Dong, H., Fagan, A. M., Wang, L., Xiong, C., Holtzman, D. M., & Morris, J. C. (2006). Plasma Cortisol and Progression of Dementia in Subjects With Alzheimer-Type Dementia. American Journal of Psychiatry, 163(12), 2164–2169. https://doi.org/10.1176/ajp.2006.163.12.2164
- Dekermanjian, J., Shaddox, E., N, D., y, Ghosh, D., & Kechris, K. (2022). MAI: Mechanism-Aware Imputation (1.2.0). Bioconductor version: Release (3.15). https://doi.org/10.18129/B9.bioc.MAI
- Difference Between T-test and Linear Regression—Ask Any Difference. (2022, January 22). https://askanydifference.com/difference-between-t-test-and-linear-regression/
- Dubey, A. (n.d.). Feature Selection Using Random forest | by Akash Dubey | Towards Data Science. Retrieved July 8, 2022, from https://towardsdatascience.com/feature-selection-using-random-forest-26d7b747597f
- Feature Selection Using Random Forest. (2017, December 20). https://chrisalbon.com/code/machine_learning/trees_and_forests/feature_selection_using_random_forest/
- Fiehn, O. (6 March 2019). NIH Common Fund's National Metabolomics Data Repository (NMDR) Metabolomics Workbench (PR000756) [Dataset]. http://dx.doi.org/10.21228/M8ZH5N 
- Gonzalez-Covarrubias, V., Martínez-Martínez, E., & del Bosque-Plata, L. (2022). The Potential of Metabolomics in Biomedical Applications. Metabolites, 12(2), 194. https://doi.org/10.3390/metabo12020194
- How to Remove Outliers in R | R-bloggers. (n.d.). Retrieved July 4, 2022, from https://www.r-bloggers.com/2021/09/how-to-remove-outliers-in-r-3/
- Justice, N. J. (2018). The relationship between stress and Alzheimer’s disease. Neurobiology of Stress, 8, 127–133. https://doi.org/10.1016/j.ynstr.2018.04.002
- Larose, C., & Larose, D. (2019). Data Science Using Python and R. John Wiley & Sons, Inc.
- Lee, J. Y., & Styczynski, M. P. (2018). NS-kNN: A modified k-nearest neighbors approach for imputing metabolomics data. Metabolomics, 14(12), 153. https://doi.org/10.1007/s11306-018-1451-8
- Mishra, P., Singh, U., Pandey, C., Mishra, P., & Pandey, G. (2019). Application of student’s t-test, analysis of variance, and covariance. Annals of Cardiac Anaesthesia, 22(4), 407. https://doi.org/10.4103/aca.ACA_94_19
- Mukaka, M. (2012). A guide to appropriate use of Correlation coefficient in medical research. Malawi Medical Journal : The Journal of Medical Association of Malawi, 24(3), 69–71.
- Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., Passos, A., Cournapeau, D., Brucher, M., Perrot, M., & Duchesnay, E. (2011). Scikit-learn: Machine Learning in Python. Journal of Machine Learning Research, 12, 2825–2830.
- Peterson, R. (25 April 2014). NIH Common Fund's National Metabolomics Data Repository (NMDR) Metabolomics Workbench. (PR000045) [Dataset]. http://dx.doi.org/10.21228/ M88G6G
- Ramzai, J. (2021, May 25). Clearly explained: Pearson V/S Spearman Correlation Coefficient. Medium. https://towardsdatascience.com/clearly-explained-pearson-v-s-spearman-correlation-coefficient-ada2f473b8
- scale function—RDocumentation. (n.d.). Retrieved July 12, 2022, from https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/scale
- van den Berg, R. A., Hoefsloot, H. C., Westerhuis, J. A., Smilde, A. K., & van der Werf, M. J. (2006). Centering, scaling, and transformations: Improving the biological information content of metabolomics data. BMC Genomics, 7(1), 142. https://doi.org/10.1186/1471-2164-7-142
- Virtanen, P., Gommers, R., Oliphant, T. E., Haberland, M., Reddy, T., Cournapeau, D., Burovski, E., Peterson, P., Weckesser, W., Bright, J., van der Walt, S. J., Brett, M., Wilson, J., Millman, K. J., Mayorov, N., Nelson, A. R. J., Jones, E., Kern, R., Larson, E., … Vázquez-Baeza, Y. (2020). SciPy 1.0: Fundamental algorithms for scientific computing in Python. Nature Methods, 17(3), 261–272. https://doi.org/10.1038/s41592-019-0686-2
- Wu, S. (2021, June 5). What are the best metrics to evaluate your regression model? Medium. https://towardsdatascience.com/what-are-the-best-metrics-to-evaluate-your-regression-model-418ca481755b
 - Zhang, Z. (7 Feb. 2018). NIH Common Fund's National Metabolomics Data Repository (NMDR) Metabolomics Workbench (PR000627) [Dataset]. http://dx.doi.org/10.21228/M8MT2H 
