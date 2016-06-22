clear;
addpath('./../trainingData/', './../ESP/');
p.topology = [3 1 2];
p.maximumGenerations = 40;
p.targetFitness = 1000-1e-3;
p.permutationOption = 1;
p.elitismOption = 2;
data  = load('./trainingData.mat');
p.trainingData = data.trainingData;
result = doEsp('evaluateNetwork', p);

data = load('./testData.mat');
p.testData = data.testData;

fitness = evaluateNetwork(result.bestNetwork, p.trainingData);
