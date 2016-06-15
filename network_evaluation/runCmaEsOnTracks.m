clear;
addpath('./../trainingData/', './../CMA_ES/', './../ESP/');
% nParameters = 24;
p.topology = [3 3 2];
nParameters = (1 + p.topology(1) + p.topology(2) + p.topology(3)) * ...
  (p.topology(2) + p.topology(3));

% X = ones(1,24);
% p.points = X;
% evaluateNetwork(p);

trainingData  = load('trainingData.mat');

p.trainingData = trainingData.trainingData;
result = cmaes('evaluateNetwork', nParameters, p);
p.points = result.bestSolution;
error = evaluateNetwork(p);
semilogy(error,'r*');

data = load('./testData.mat');
% p.testData = data.testData;
p.trainingData = data.testData;
fitness = evaluateNetwork(p);