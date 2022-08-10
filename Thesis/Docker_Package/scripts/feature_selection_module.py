# -*- coding: utf-8 -*-
"""Feature_Selection_Module.ipynb

## Feature Selection Module
This module use random forest and the selection from model from sklearn to help select the top 100 features from each data frame. Then, a student's t-test is applied to help select features that are significant.
"""

import numpy as np
import pandas as pd
from scipy.stats import ttest_ind
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_selection import SelectFromModel
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split


#import data
ALZ_plasma_p = pd.read_csv("application/ALZ_plasma_processed.csv", index_col=0)
ALZ_csf_p = pd.read_csv("application/ALZ_csf_processed.csv", index_col=0)
trauma_rat_p = pd.read_csv("application/trauma_rat_processed.csv", index_col=0)
trauma_human_p = pd.read_csv("application/trauma_human_processed.csv", index_col=0)

def ALZ_selection(dataframe, cutBy, other, num_features=None):
  """
  This is the main function of this module. It does a few different features.
  1. It will split the data frame into a test train for the RF
  2. It will convert the samples to binary ex. AZ vs Normal
  3. It will runn the random forest classifier with n_est of 1000 trees and 
  random statue of 42 to be consistent.
  4. The select from model will pull the top features that the user gives
  5. It compares the accuracy
  6. It then applies the student's t-test and selects the most significant 
  features. 
  User gives 4 values
  the processed dataframe, the two different binary variables to cut from,
  the max number of features from the selection model
  """
  dataframe_t = dataframe.transpose()
  train,test = train_test_split(dataframe_t, test_size=0.25)
  #create y
  y_train_headers = train.index
  Y_train = []
  Y_train_num = []
  for i in y_train_headers:
    if i != None and cutBy in i:
      Y_train.append(cutBy)
      Y_train_num.append(1)
    else:
      Y_train.append(other)
      Y_train_num.append(0)

  y_test_headers = test.index
  Y_test = []
  Y_test_num = []
  for i in y_test_headers:
    if i != None and cutBy in i:
      Y_test.append(cutBy)
      Y_test_num.append(1)
    else:
      Y_test.append(other)
      Y_test_num.append(0)

  RF = RandomForestClassifier(n_estimators = 1000, random_state=42)
  RF.fit(train, Y_train_num)
  SRF = SelectFromModel(RF, max_features = num_features)
  SRF.fit(train, Y_train_num)

  X_import_train = SRF.transform(train)
  X_import_test = SRF.transform(test)

  selected_feat = train.columns[(SRF.get_support())]
  number_features = len(selected_feat)

  RF_import = RandomForestClassifier(n_estimators = 1000, random_state=42)
  RF_import.fit(X_import_train, Y_train_num)
  pred = RF.predict(test)
  RF_accuracy = accuracy_score(Y_test_num, pred)

  y_important_pred = RF_import.predict(X_import_test)
  SEL_accuracy = accuracy_score(Y_test_num, y_important_pred)

  dataframe_t
  dataframe_t_subset = pd.DataFrame()
  for i in selected_feat:
    dataframe_t_subset[i] = (dataframe_t[[i]])
    dataframe_t_subset_headers = dataframe_t_subset.index

  dataframe_t_subset_group = []
  for i in dataframe_t_subset_headers:
    if i != None and cutBy in i:
      dataframe_t_subset_group.append(cutBy)
    else:
      dataframe_t_subset_group.append(other)

  dataframe_t_subset["group"] = dataframe_t_subset_group
  group1 = dataframe_t_subset[dataframe_t_subset['group'] == cutBy]
  group2 = dataframe_t_subset[dataframe_t_subset['group'] == other]

  dataframe_ttest = pd.DataFrame()
  for col in group1.iloc[:,:-1].columns:
    tscore = ttest_ind(group1[col], group2[col])[0]
    pscore = ttest_ind(group1[col], group2[col])[1]
    dataframe_ttest[col] = [tscore, pscore]
  
  dataframe_ttest_t = dataframe_ttest.transpose()
  dataframe_ttest_t = dataframe_ttest_t[dataframe_ttest_t[1] < 0.05]
  dataframe_ttest_t.columns = ["t-score", "p-value"]
  dataframe_ttest_t = dataframe_ttest_t.sort_values(by=['p-value'])
  number_features = len(dataframe_ttest_t)

  return(dataframe_ttest_t, number_features, RF_accuracy, SEL_accuracy)

# run for ALZ datasets
# keep running until there is a good accuracy
ALZ_plasma_RF_accuracy = 0
counter = 0
while ALZ_plasma_RF_accuracy < 0.75:
  ALZ_plasma_features, ALZ_plasma_number_feat, ALZ_plasma_RF_accuracy, ALZ_plasma_SEL_accuracy = ALZ_selection(ALZ_plasma_p, "AD", "N", 500)
  counter += 1
  if counter == 10:
    break

# run for ALZ datasets
ALZ_csf_RF_accuracy = 0
counter = 0
while ALZ_csf_RF_accuracy < 0.75:
  ALZ_csf_features, ALZ_csf_number_feat, ALZ_csf_RF_accuracy, ALZ_csf_SEL_accuracy = ALZ_selection(ALZ_csf_p, "AD", "N", 500)
  counter += 1
  if counter == 10:
    break

print("plasma features: ", ALZ_plasma_number_feat, "plasma no select accuracy: ", ALZ_plasma_RF_accuracy, "plasma select accuracy: ", ALZ_plasma_SEL_accuracy)
print("csf features: ", ALZ_csf_number_feat, "csf no select accuracy: ", ALZ_csf_RF_accuracy, "csf select accuracy: ", ALZ_csf_SEL_accuracy)

#run trauma datasets
trauma_rat_p2 = trauma_rat_p.filter(regex='aline')
trauma_rat_RF_accuracy = 0
counter = 0
while trauma_rat_RF_accuracy < 0.75:
  trauma_rat_features, trauma_rat_number_feats, trauma_rat_RF_accuracy, trauma_rat_SEL_accuracy = ALZ_selection(trauma_rat_p2, "CMUS", "N", 100)
  if counter == 10:
    break
print("rat features: ", trauma_rat_number_feats, "rat no select accuracy: ", trauma_rat_RF_accuracy, "rat select accuracy: ", trauma_rat_SEL_accuracy)

trauma_human_RF_accuracy = 0
counter = 0
while trauma_human_RF_accuracy < 0.75:
  trauma_human_features, trauma_human_number_feats, trauma_human_RF_accuracy, trauma_human_SEL_accuracy = ALZ_selection(trauma_human_p, "Trauma", "N", 100)
  if counter == 10:
    break
print("human features: ", trauma_human_number_feats, "human no select accuracy: ", trauma_human_RF_accuracy, "human select accuracy: ", trauma_human_SEL_accuracy)

#cut samples
def final_cutter(original, features):
  """
  This function will take the original processed dataframe and subset it for
  the selected features of each dataset.
  """
  final_cut = pd.DataFrame()
  originalt = original.transpose()
  for i in features.index:
    final_cut[i] = (originalt[[i]])
  
  return(final_cut)

ALZ_plasma_f_selected = final_cutter(ALZ_plasma_p, ALZ_plasma_features)
ALZ_csf_f_selected = final_cutter(ALZ_csf_p, ALZ_csf_features)
trauma_human_f_selected = final_cutter(trauma_human_p, trauma_human_features)
trauma_rat_f_selected = final_cutter(trauma_rat_p, trauma_rat_features)

#save p-values
ALZ_plasma_features.to_csv("application/ALZ_plasma_tp-scores.csv")
ALZ_csf_features.to_csv("application/ALZ_csf_tp-scores.csv")
trauma_human_features.to_csv("application/trauma_human_tp-scores.csv")
trauma_rat_features.to_csv("application/trauma_rat_tp-scores.csv")

#save subsets
ALZ_plasma_f_selected.to_csv("application/ALZ_plasma_selected_features.csv")
ALZ_csf_f_selected.to_csv("application/ALZ_csf_selected_features.csv")
trauma_human_f_selected.to_csv("application/trauma_human_selected_features.csv")
trauma_rat_f_selected.to_csv("application/trauma_rat_selected_features.csv")

"""## References

Acharjee, A., Larkman, J., Xu, Y., Cardoso, V. R., & Gkoutos, G. V. (2020). A random forest based biomarker discovery and power analysis framework for diagnostics research. BMC Medical Genomics, 13(1), 178. https://doi.org/10.1186/s12920-020-00826-6

Dubey, A. (n.d.). Feature Selection Using Random forest | by Akash Dubey | Towards Data Science. Retrieved July 8, 2022, from https://towardsdatascience.com/feature-selection-using-random-forest-26d7b747597f

Feature Selection Using Random Forest. (2017, December 20). https://chrisalbon.com/code/machine_learning/trees_and_forests/feature_selection_using_random_forest/

Grissa, D., Pétéra, M., Brandolini, M., Napoli, A., Comte, B., & Pujos-Guillot, E. (2016). Feature Selection Methods for Early Predictive Biomarker Discovery Using Untargeted Metabolomic Data. Frontiers in Molecular Biosciences, 3. https://doi.org/10.3389/fmolb.2016.00030

Mishra, P., Singh, U., Pandey, C., Mishra, P., & Pandey, G. (2019). Application of student’s t-test, analysis of variance, and covariance. Annals of Cardiac Anaesthesia, 22(4), 407. https://doi.org/10.4103/aca.ACA_94_19

Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., Passos, A., Cournapeau, D., Brucher, M., Perrot, M., & Duchesnay, E. (2011). Scikit-learn: Machine Learning in Python. Journal of Machine Learning Research, 12, 2825–2830.

Reback, J., Jbrockmendel, McKinney, W., Van Den Bossche, J., Augspurger, T., Roeschke, M., Hawkins, S., Cloud, P., Gfyoung, Sinhrks, Hoefler, P., Klein, A., Terji Petersen, Tratner, J., She, C., Ayd, W., Naveh, S., JHM Darbyshire, Garcia, M., … Battiston, P. (2022). pandas-dev/pandas: Pandas 1.4.2 (v1.4.2) [Computer software]. Zenodo. https://doi.org/10.5281/ZENODO.3509134

Rossum, G. van, & Drake, F. L. (2010). The Python language reference (Release 3.0.1 [Repr.]). Python Software Foundation.


"""

