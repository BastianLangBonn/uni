function [ fitness ] = evaluateNetwork( weightMatrix, trainingData )
%   addpath('./../network_evaluation/','./../trainingData/');
%EVALUATENETWORK Summary of this function goes here
%   Detailed explanation goes here
%   trainingData = load('./../trainingData/trainingData.mat');
  fitness = 1000 - evaluateMultipleTracks(weightMatrix, trainingData);
end

