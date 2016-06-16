%% RNNet - Returns activation of all nodes in an RNN after one time step
%
% function a = RNNet (wMat, aMat, input, activation, p)
%
% Given an weight matrix, corresponding activation functions, initial
% input vector, and current node activations, returns activation of all
% nodes after propagating signal ONE TIMESTEP through an RNN.
%

function [a] = RNNet (wMat, input, activation)

    % Add Bias
    activation(1) = 1;
    % Override input elements with new input values
    activation(2:length(input)+1) = input; % input state
        
    % Compute net input and activation for only the relevant elements
    activation(length(input)+2:end) = activation * wMat;
    activation(length(input)+2:end) = tanh(activation(length(input)+2:end));
    
    % For demonstration purposes, the activation vector is filled with ones
    % Remember that in this case, the last value is the (only) output value
    a = activation; % (so the output is a(end))
    
end
