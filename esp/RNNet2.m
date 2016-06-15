function [ a ] = RNNet2( wMat, input, activation )
%RNNET2 Summary of this function goes here
%   Detailed explanation goes here

    % Fix initial activation size
    %if length(activation) > 
    
    % Only take bias plus three non velocity values
    activation(1:4) = [input(1) input(2) input(4) input(6)];
        
    %% HINTS
    % Propagate signal through network one timestep    
    % Apply activation function to neurons (line by line)
    activation(5:end) = activation * wMat;
    activation(5:end) = tanh(activation(5:end));
    
    % For demonstration purposes, the activation vector is filled with ones
    % Remember that in this case, the last value is the (only) output value
    a = activation; % (so the output is a(end))


end

