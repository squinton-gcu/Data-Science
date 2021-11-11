# programmer - Sophia Quinton
# date - 11-10-21
# class - DSC -530
# assignment - Assignment 2

##libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.tools.tools as stattools
from scipy import stats
from sklearn.neighbors import KNeighborsClassifier
from kneed import KneeLocator

##load data (Lecun et. al., 1998) (Laporte, 2016)
from mnist import MNIST
mndata = MNIST('C:/Users/sophi/OneDrive/Desktop/Graduate Classes/DSC - 540 Machine Learning/Week 2/')
images, labels = mndata.load_training()
images_test, labels_test = mndata.load_testing()

#identify the variables in the dataset and define Euclidean distance 
#between an element in test and training
## the labels represent the Y data and the images are the X variables
##(Bhalley, 2020) (Brownlee, 2020)
from math import sqrt
def euclidean_dist(imA, imB):
    #based on the pythagorean theorem
    distance = 0.0
    for i in range(len(imA)-1):
        distance += (imA[i] - imB[i]) **2
    return sqrt(distance)
##calculate the difference between two images example
images_array = np.array(images)
images_test_array = np.array(images_test)
print("Example of calculating the euclidean Distance of two elements training set: ", euclidean_dist(images_array[0], images_array[2]))
print("Example of calculating the euclidean Distance of two elements testing set: ", euclidean_dist(images_test_array[0], images_test_array[2]))
print("Example of calculating the euclidean Distance of two elements from each: ", euclidean_dist(images_array[5], images_test_array[5]))

#K-Nearest neighbor calculations (sklearn, n.d.)
neigh = KNeighborsClassifier(n_neighbors=10)
kModel = neigh.fit(images, labels)

#calculate the distance between the test elements and each of neighbors
##test1
print("Train to neighbors: ", kModel.kneighbors([images_array[0]]))
##test2
print("Test to neighbors: ", kModel.kneighbors([images_test_array[2]]))
##test3
print("Test to neighbors: ", kModel.kneighbors([images_test_array[2]]))

#count the occurence of each digit and find most popular digit
##the number of each digit
def count_occurence(y_data):
    count_list = [0,0,0,0,0,0,0,0,0,0]
    for number in y_data :
        if number == 0:
            count_list[0] += 1
        elif number == 1:
            count_list[1] += 1
        elif number == 2:
            count_list[2] += 1
        elif number == 3:
            count_list[3] += 1
        elif number == 4:
            count_list[4] += 1
        elif number == 4:
            count_list[4] += 1
        elif number == 5:
            count_list[5] += 1
        elif number == 6:
            count_list[6] += 1
        elif number == 7:
            count_list[7] += 1
        elif number == 8:
            count_list[8] += 1
        elif number == 9:
            count_list[9] += 1
        else:
            print("issue!")
    return count_list

train_counter = count_occurence(labels)
for i in range(len(train_counter)):
    print("The number of ", i, "'s", train_counter[i])

##find max
def find_max(list):
    max_num = max(list)
    for i in range(len(list)):
        if max_num == list[i]:
            print("The most popular number is ", i)
find_max(train_counter)

##determine what is in each group
group_1 = []
group_2 = []
group_3 = []
group_4 = []
group_5 = []
group_6 = []
group_7 = []
group_8 = []
group_9 = []
group_9 = []

for sample in range(1,100):
    group = kModel.predict([images[sample]])[0]
    
    if group == 1:
        group_1.append(sample)
    elif group == 2:
        group_2.append(sample)
    elif group == 3:
        group_3.append(sample)
    elif group == 4:
        group_4.append(sample)
    elif group == 5:
        group_5.append(sample)
    elif group == 6:
        group_6.append(sample)
    elif group == 7:
        group_7.append(sample)
    elif group == 8:
        group_8.append(sample)
    elif group == 9:
        group_9.append(sample)
    elif group == 10:
        group_10.append(sample)

def count_occurence_groups(y_data, group):
    count_list = [0,0,0,0,0,0,0,0,0,0]
    for number in group:
        if y_data[number] == 0:
            count_list[0] += 1
        elif y_data[number] == 1:
            count_list[1] += 1
        elif y_data[number] == 2:
            count_list[2] += 1
        elif y_data[number] == 3:
            count_list[3] += 1
        elif y_data[number] == 4:
            count_list[4] += 1
        elif y_data[number] == 5:
            count_list[5] += 1
        elif y_data[number] == 6:
            count_list[6] += 1
        elif y_data[number] == 7:
            count_list[7] += 1
        elif y_data[number] == 8:
            count_list[8] += 1
        elif y_data[number] == 9:
            count_list[9] += 1
        else:
            print("issue!")
    return count_list
    
find_max(count_occurence_groups(labels,group_1))
find_max(count_occurence_groups(labels, group_2))
find_max(count_occurence_groups(labels,group_3))
find_max(count_occurence_groups(labels,group_4))
find_max(count_occurence_groups(labels,group_5))
find_max(count_occurence_groups(labels,group_6))
find_max(count_occurence_groups(labels,group_7))
find_max(count_occurence_groups(labels,group_8))
find_max(count_occurence_groups(labels,group_9))
find_max(count_occurence_groups(labels,group_10))

#identify the test element as the digit as popular
predictions = kModel.predict(images_test)
find_max(count_occurence(predictions))

#calculate error (sklearn.classification_report, nd)(sklearn.confusion_matrix, nd)
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report

scores_y = kModel.score(images_test, labels_test)
conf_matrix = confusion_matrix(np.array(labels_test), predictions)

table_result = pd.crosstab(np.array(labels_test), predictions, rownames = ['Actual'], colnames = ['Predicted'])
table_result['Total'] = table_result.sum(axis=1); table_result.loc['Total'] = table_result.sum()

print(classification_report(np.array(labels_test), predictions))

##(Loukas, 2020)
FP = conf_matrix.sum(axis=0) - np.diag(conf_matrix)
FN = conf_matrix.sum(axis=1) - np.diag(conf_matrix)
TP = np.diag(conf_matrix)
TN = conf_matrix.sum() - (FP + FN + TP)
print("FP: ", FP)
print("FN: ", FN)
print("TP: ", TP)
print("TN: ", TN)

## ROC curve (sklearn-ROC, nd)
from sklearn.metrics import roc_curve, auc
y_score = kModel.predict_proba(images_test)
labels_test_array = np.array(labels_test)

from sklearn.preprocessing import label_binarize
labels_binary = label_binarize(labels_test_array, classes = [0,1,2,3,4,5,6,7,8,9])
n_classes = 10

fpr = dict()
tpr = dict()
roc_auc = dict()
for i in range(10):
    fpr[i], tpr[i], _ = roc_curve(labels_binary[:, i], y_score[:, i])
    roc_auc[i] = auc(fpr[i], tpr[i])

for i in range(10):
    plt.plot(fpr[i], tpr[i], label='ROC curve (area = %0.2f)' % roc_auc[i])
    plt.plot([0,1], [0,1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0,1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic example')
plt.show()
