function [ error ] = evaluateNetwork( p )
addpath('./../network_evaluation');
%EVALUATENETWORK Summary of this function goes here
%   Detailed explanation goes here
  counter = 1;
  tic
  for i=1:p.topology(1) + p.topology(2) + p.topology(3) + 1
    for j=1:p.topology(2) + p.topology(3)
      wMat(i,j) = p.points(counter);
      counter = counter + 1;
    end
  end
  
  error = evaluateMultipleTracks(wMat, p.trainingData);
  toc
end

