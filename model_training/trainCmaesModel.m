%% Read Training Data
clear;
addpath('../CMA_ES')
data = load('../simple_model/trainingData.mat');
trainingData = data.data;

evaluationFunction = 'evaluateRecurrentNet';
nInput = 4;
nHidden = 5;
nOut = 2;
parameters.data = trainingData;
parameters.topology = [nInput nHidden nOut];
nCmaesPoints = nInput * nHidden + nHidden * nOut + nHidden + nOut;
    

result = cmaes(evaluationFunction, nCmaesPoints, parameters);