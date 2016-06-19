clear;
addpath('./../trainingData/', './../ESP/',...
  './../network_evaluation/');
% nParameters = 24;
p.topology = [2 3 2];
nParameters = (1 + p.topology(1) + p.topology(2) + p.topology(3)) * ...
  (p.topology(2) + p.topology(3));

initialPoints = randn(1,nParameters) * 2.5;
insigma = 0.2;
OPTS = cmaes;
OPTS.StopFitness=1e-3;
trainingData  = load('./../trainingData/simpleTrainingData.mat');

p.evaluationData = trainingData.data;
result = cmaes('evaluateCmaesNetwork', initialPoints, insigma, OPTS, p); 
% result = cmaes('evaluateNetwork', nParameters, p);
save 'trainedNetwork.mat' result;


error = evaluateCmaesNetwork(result,p);
semilogy(error,'r*');

data = load('testData.mat');
% p.testData = data.testData;
p.trainingData = data.testData;
fitness = evaluateCmaesNetwork(result, p);