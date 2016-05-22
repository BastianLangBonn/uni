function [mse, fit] = evaluate(network, num_inputs, tdata, varargin)
%EVALUATE evaluates prediction ability of network and returns error
%   Detailed explanation goes here
    mse = 0;
    
    for data_set = 1:length(tdata)
        trial = tdata{data_set};
        activation = zeros(1,length(network));
        activation(end-1) = 1; %bias
        prediction = [];
        for tsteps = 1:length(trial)
            activation(end-1) = 1;
            activation(end) = trial(tsteps,end);
            activation = tanh(activation * network);
            %activation = tanh( (activation/10) * net)
            prediction(tsteps) = activation(end-num_inputs); 
        end
        
        %Scale prediction (which is between -1 and 1) over realistic range
        prediction = 80 + prediction*100;
        
        error = prediction' - trial(:,2);
        mse = mse + mean(error.^2);
        fit{data_set} = prediction;
    end

    mse = mse/data_set;
    
end