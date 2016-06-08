%% RNNet - Returns activation of all nodes in an RNN after one time step
%
% function a = RNNet (wMat, aMat, input, activation, p)
%
% Given an weight matrix, corresponding activation functions, initial
% input vector, and current node activations, returns activation of all
% nodes after propagating signal ONE TIMESTEP through an RNN.
%

function [a] = RNNet (wMat, input, activation)

    activation(1) = 1; % bias
    activation(2:length(input)+1) = input; % input state
        
    %% HINTS
    % Propagate signal through network one timestep    
    % Apply activation function to neurons (line by line)
    
    % For demonstration purposes, the activation vector is filled with ones
    % Remember that in this case, the last value is the (only) output value
    a = ones(size(activation)); % (so the output is a(end))
    
end
