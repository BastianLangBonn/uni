clear;
addpath('./../trainingData/', './../ESP/');
p.topology = [3 1 2];
p.maximumGenerations = 2500;
p.targetFitness = 1000;
p.permutationOption = 1;
p.elitismOption = 2;
data  = load('./trainingData.mat');
p.trainingData = data.trainingData;
doEsp('evaluateNetwork', p);


