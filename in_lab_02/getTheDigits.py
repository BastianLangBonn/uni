# -*- coding: utf-8 -*-
"""
Created on Fri May  6 19:25:31 2016

@author: Bastian Lang
"""

import numpy as np
import collections 
from pandas import read_csv
from sknn.mlp import Regressor, Layer
from sklearn.cross_validation import train_test_split

def createInput(counter):
    # Create input list out of most important characters
    result = []
    result.append(counter['Z'])
    result.append(counter['U'])
    result.append(counter['X'])
    result.append(counter['G'])
    result.append(counter['W'])
    result.append(counter['H'])
    result.append(counter['F'])
    result.append(counter['S'])
    result.append(counter['O'])
    result.append(counter['I'])
    return result

def createLabel(number):
    #given a number returns the expected output
    counter = collections.Counter(str(number))
#    print(number)
#    print(counter.elements)
    result = []
    result.append(counter['0'])
    result.append(counter['1'])
    result.append(counter['2'])
    result.append(counter['3'])
    result.append(counter['4'])
    result.append(counter['5'])
    result.append(counter['6'])
    result.append(counter['7'])
    result.append(counter['8'])
    result.append(counter['9'])
    return result


# Read the data
data = read_csv('./training_data.txt',delimiter = ' ', names=('label','data'),converters={'label': lambda x: str(x)})
labels = data.label[:3000]
trainingData = data.data[:3000]

# Preprocess Data
inputs = []
outputs = []
for i in range(trainingData.size):
    counter = collections.Counter(trainingData[i])
    outputs.append(createLabel(labels[i]))
    inputs.append(createInput(counter))
    
inputs = np.asarray(inputs)
outputs = np.asarray(outputs)
#print(inputs)

X_train, X_test, y_train, y_test = train_test_split(inputs, outputs, test_size=0.33, random_state=42)

nn = Regressor(
    layers=[
        Layer("Rectifier", units=100),
        Layer("Linear")],
    learning_rate=0.02,
    n_iter=10)
nn.fit(X_train, y_train)






#trainingData = data[:,0]
#trainingLabels = data[:,1]
#print trainingLabels[0]

