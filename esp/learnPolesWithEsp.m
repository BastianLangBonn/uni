clear;
addpath('simulator');
parameters.topology = [6,2,1];
evaluationFunction = 'twoPoleEvaluation';
parameters.permutationOption = 1;
parameters.elitismOption = 4;
parameters.maximumGenerations = 2500;
parameters.targetFitness = 1000;


r = doEsp(evaluationFunction, parameters);
    

