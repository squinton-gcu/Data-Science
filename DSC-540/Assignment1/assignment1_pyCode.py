# programmer - Sophia Quinton
# date - 11-3-21
# class - DSC -540
# assignment - Assignment 1

#libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
import seaborn as sns
from sklearn import datasets, linear_model
from sklearn.model_selection import train_test_split
from statsmodels.stats.outliers_influence import variance_inflation_factor
from sklearn import metrics
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

#Part1 - Tools Readiness
##pandas
##file from (Larose & Larose, 2019)
frame = pd.read_csv("E:/GCU/Graduate Classes/DSC - 540 Machine Learning/Week 1/cereals.csv")
frame.head()

##numpy
rounded_rating = np.round(frame['Rating'][0], 3)
rounded_rating

##matplotlib
plt.boxplot(frame['Rating'])

##scikit-learn
frame_train, frame_test = train_test_split(frame, test_size=0.2, random_state=25)
frame_train.head()
print(len(frame_train))
print(len(frame_test))

#Part2 - Review Predictive Models and Python Proficiency
##read in data
estate = pd.read_csv("E:/GCU/Graduate Classes/DSC - 540 Machine Learning/Week 1/housing.csv")
estate.head()

## view data
plt.scatter(estate['longitude'], estate['latitude'])
plt.show()

plt.boxplot(estate['housing_median_age'])

plt.boxplot(estate['total_rooms'])

plt.boxplot(estate['population'])

plt.boxplot(estate['median_income'])

plt.boxplot(estate['median_housing_value'])

##split data
estate_train, estate_test = train_test_split(estate, test_size=0.2, random_state=25)

##prepare data (GeeksforGeeks, 2020)
test_columns = estate[['longitude', 'latitude', 'housing_median_age', 'total_rooms', 'population', 'median_income']]
vif = pd.DataFrame()
vif["variable"] = test_columns.columns
vif["VIF"] = [variance_inflation_factor(test_columns.values,i) for i in range(test_columns.shape[1])]
vif

##do PCA Analysis
x_estate_train = estate_train[['longitude', 'latitude', 'housing_median_age', 'total_rooms', 'population', 'median_income']]
x_estate_test = estate_test[['longitude', 'latitude', 'housing_median_age', 'total_rooms', 'population', 'median_income']]
y_estate_train = estate_train['median_house_value']
y_estate_test = estate_test['median_house_value']

scaler = StandardScaler()
scaler.fit(x_estate_train)
x_estate_train = scaler.transform(x_estate_train)
x_estate_test = scaler.transform(x_estate_test)

pca = PCA(0.95)
pca.fit(x_estate_train)
x_estate_train = pca.transform(x_estate_train)
x_estate_test = pca.transform(x_estate_test)

##(DataScience+, nd)
map= pd.DataFrame(pca.components_,columns=['longitude', 'latitude', 'housing_median_age', 'total_rooms', 'population', 'median_income'])
plt.figure(figsize=(12,6))
sns.heatmap(map,cmap='twilight')

##scree plot (Zach, 2021)
PC_values = np.arange(pca.n_components_) + 1
plt.plot(PC_values, pca.explained_variance_ratio_)
plt.show()

##run model (Larose & Larose, 2019)
constantX = sm.add_constant(x_estate_train, prepend=True)
estate_model = sm.OLS(y_estate_train, constantX).fit()
estate_model.summary()

##validate data (Larose & Larose, 2019)
constantX_test = sm.add_constant(x_estate_test, prepend=True)
estate_model_test= sm.OLS(y_estate_test, constantX_test).fit()
estate_model_test.summary()

##evaluate model
ypred = estate_model.predict(constantX_test)
##MAE (Larose & Larose, 2019)
print("Model MAE: ", metrics.mean_absolute_error(y_true = y_estate_test, y_pred = ypred))
print("base MAE: ", np.sqrt(metrics.mean_squared_error(y_true = y_estate_test, y_pred = ypred)))

print(estate_model.score(x_estate_test, y_estate_test))

# calculate s or standard deviation (Larose & Larose, 2019)
print("test MSE", np.sqrt(estate_model_test.scale))
print("Model MSE", np.sqrt(estate_model.scale))


