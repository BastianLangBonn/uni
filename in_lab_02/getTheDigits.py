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
import pickle
import matplotlib.pyplot as plt


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

def trainModel():
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
    
    pickle.dump(nn, open('nn.pkl', 'wb'))
    
    predictTest = nn.predict(X_test)
    
    error = predictTest - y_test

    plt.plot(error)
    plt.ylabel('prediction error')
    plt.show()

def loadModel(filename):
    return pickle.load(open(filename, 'rb'))

def convertToNumber(modelOutput):
    result = []
    for i in range(10):
        for j in range(int(round(modelOutput[i]))):
            result.append(str(i))
    return result

def predictFile(filename):

    nn = loadModel('nn.pkl')
    data = np.genfromtxt(filename,dtype='str')
    y = data[:,0]
    X = data[:,1]
    inputs = []
    for element in X:
        counter = collections.Counter(element)
        inputs.append(createInput(counter))
    X = np.asarray(inputs)
    predictions = nn.predict(X)
    result = []
    for element in predictions:
        result.append(''.join(convertToNumber(element)))
             
    error = y == result
    print(y[0])
    print(result[0])
    print(error)
    plt.plot(error)
    plt.ylabel('prediction error')
    plt.show()
        
    return result

def writeFile(data, filename):
    f = open(filename, 'w')
    for i in range(len(data)):
        
        f.write('case #{}: {}\n'.format(i+1, ''.join(data[i])))
        
#trainModel()
data = predictFile('validation.txt')
writeFile(data, 'validation.out')
