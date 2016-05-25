function [mse, fit] = evaluate(network, nImputs)
%EVALUATE evaluates prediction ability of network and returns error
%   Detailed explanation goes here
    mse = 0;
    load('trainingData.mat');
    
    for dataSet = 1:length(data)
        trial = data{dataSet};
        activation = zeros(1,length(network));
        activation(nInputs) = 1; %bias
        prediction = [];
        for timeStep = 1:length(trial)
            activation(nInputs) = 1;
            for i = 1:nInputs-1
               activation(i) = trial(timeStep, i); 
            end
            %TODO: Use different activation functions
            activation = tanh(activation * network);
            prediction(timeStep) = activation(end-nImputs); 
        end
        
        %Scale prediction (which is between -1 and 1) over realistic range
        prediction = 80 + prediction*100;
        
        error = prediction' - trial(:,2);
        mse = mse + mean(error.^2);
        fit{dataSet} = prediction;
    end

    mse = mse/dataSet;
    
end