clear;
addpath('simulator');
parameters.topology = [6,2,1];
evaluationFunction = 'twoPoleEvaluation';
parameters.permutationOption = 1;
parameters.elitismOption = 2;
parameters.maximumGenerations = 2500;
parameters.targetFitness = 1000;


r = doEsp(evaluationFunction, parameters);
    

