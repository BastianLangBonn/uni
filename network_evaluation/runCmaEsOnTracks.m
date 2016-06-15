clear;
addpath('./../trainingData/', './../CMA_ES/', './../ESP/');
nParameters = 24;
p.topology = [3 1 2];

% X = ones(1,24);
% p.points = X;
% evaluateNetwork(p);

trainingData  = load('trainingData.mat');

p.trainingData = trainingData.trainingData;
cmaes('evaluateNetwork', nParameters, p);

