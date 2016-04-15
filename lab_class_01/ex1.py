# -*- coding: utf-8 -*-
"""
Created on Tue Apr  5 11:13:15 2016

@author: bastian
"""
import os
import pydotplus
import sklearn.datasets as ds
from sklearn import tree
from sklearn.externals.six import StringIO
from IPython.display import Image


clf = tree.DecisionTreeClassifier()

iris = ds.load_iris()

clf = clf.fit(iris.data, iris.target)
clf.predict(iris.data[:1, :])

with open("iris.dot", 'w') as f:
     f = tree.export_graphviz(clf, out_file=f)
dot_data = StringIO()  
tree.export_graphviz(clf, out_file=dot_data,  
                         feature_names=iris.feature_names,  
                         class_names=iris.target_names,  
                         filled=True, rounded=True,  
                         special_characters=True)  
graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
Image(graph.create_png())