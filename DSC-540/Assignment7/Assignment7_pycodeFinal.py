# programmer - Sophia Quinton
# date - 12-15-21
# class - DSC -540
# assignment - Assignment 7

##libraries
import numpy as np
import pandas as pd
from fcmeans import FCM
from matplotlib import pyplot as plt
from sklearn import datasets
from sklearn.cluster import KMeans
from sklearn.metrics import accuracy_score

##load dataset (Charytoanowicz et. al., 2010)
data = pd.read_csv("C:/Users/sophi/OneDrive/Desktop/Graduate Classes/DSC - 540 Machine Learning/Week 7/Seed_Data.csv")

#kmeans (Pedregosa et. al., 2011)
column_names = data.columns[0:7]
combo_final = []
score_data = pd.DataFrame(columns = ["first", "second", "third"])
for x in range(3):
    scores = []
    for i in column_names:
        for j in column_names:
            if i != j:
                combo = i + " " + j
                combo_final.append(combo)
                Group = data[[i,j]]
                Kmeans_model = KMeans(n_clusters=3)
                label = Kmeans_model.fit_predict(Group)
                accuracy = accuracy_score(data["target"], label)
                scores.append(accuracy)
    if x == 0:
        score_data["first"] = scores
    elif x == 1:
        score_data["second"] = scores
    elif x == 2:
        score_data["third"] = scores
                
                
# LK-P (AskPython, 2020) (Hunter, 2007)
Group = data[["LK", "P"]]
Kmeans_model = KMeans(n_clusters=3)
label = Kmeans_model.fit_predict(Group)
accuracy = accuracy_score(data["target"], label)
print("The accuracy of LK-P: ", accuracy)

# (AskPython, 2020) (Hunter, 2007)
tlabel_0 = data[label == 0]
tlabel_1 = data[label == 1]
tlabel_2 = data[label == 2]
plt.scatter(tlabel_0["C"], tlabel_0["P"], color="green")
plt.scatter(tlabel_1["C"], tlabel_1["P"], color="red")
plt.scatter(tlabel_2["C"], tlabel_2["P"], color="black")
plt.xlabel("Compactness")
plt.ylabel("Perimeter")
plt.show()

# A_Coef - A (AskPython, 2020) (Hunter, 2007)
Group = data[["A_Coef", "A"]]
Kmeans_model = KMeans(n_clusters=3)
label = Kmeans_model.fit_predict(Group)
accuracy = accuracy_score(data["target"], label)
print("The accuracy of LK-P: ", accuracy)

# (AskPython, 2020) (Hunter, 2007)
tlabel_0 = data[label == 0]
tlabel_1 = data[label == 1]
tlabel_2 = data[label == 2]
plt.scatter(tlabel_0["C"], tlabel_0["P"], color="green")
plt.scatter(tlabel_1["C"], tlabel_1["P"], color="red")
plt.scatter(tlabel_2["C"], tlabel_2["P"], color="black")
plt.xlabel("Compactness")
plt.ylabel("Perimeter")
plt.show()

#fuzzy (Dias, 2019)
fcm = FCM(n_clusters=3)
fcm.fit(np.array(Group))
fcm_labels = fcm.predict(np.array(Group))

accuracy = accuracy_score(data["target"], fcm_labels)
print("The fcm is: ", accuracy)

from sklearn.metrics import classification_report
print(classification_report(np.array(data["target"]), label))