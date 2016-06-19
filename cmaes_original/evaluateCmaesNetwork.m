function [ error ] = evaluateCmaesNetwork( weights, p )
addpath('./../network_evaluation');
%EVALUATECMAESNETWORK Creates the squared weight matrix out of the given
%weights and calls the function that evaluates the network on the given set
% Input: Trained weights by cmaes, a set of parameters containing the
% topology and a data set to evaluate the network on.
  
  wMat  = createNetworkFromParameters(weights, p.topology);
  error = evaluateMultipleTracks(wMat, p.evaluationData);

end

