function [ individual ] = createIndividual( nNodes, weightRange )
%CREATEINDIVIDUAL Creates a neuron individual for ESP
%   
    individual.weights = (rand(1,nNodes)-0.5) * (2*weightRange);
    individual.fitness = 0;
    individual.trials = 0;
    
    % Reduce active connections
    x = rand(1,nNodes);
    x(x<0.75) = 0;
    x(x>=0.75)= 1;

    individual.weights = individual.weights .* x;

end

