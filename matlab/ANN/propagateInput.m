function [ result ] = propagateInput( weightMatrix, input, nOutputs )
%PROPAGATEINPUT Summary of this function goes here
%   Detailed explanation goes here

    nRows = size(weightMatrix,1);
    activation = zeros(1,nRows);
    activation(1:length(input)) = input(:);
    
    for i = 1:size(weightMatrix,2)
        activation = (activation * weightMatrix(:,i))'; 
        activation = arrayfun(@(x)1./(1+exp(-4.9*x)), activation);
    end

    result = activation(end-nOutputs+1:end);
end

