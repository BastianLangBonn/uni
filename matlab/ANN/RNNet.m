%% RNNet - Returns activation of all nodes in an RNN after one time step
%
% function a = RNNet (wMat, aMat, input, activation, p)
%
% Given an weight matrix, corresponding activation functions, initial
% input vector, and current node activations, returns activation of all
% nodes after propagating signal ONE TIMESTEP through an RNN.
%

function a = RNNet (wMat, aMat, input, activation, p)

    activation(1) = 1; % bias
    activation(2:length(input)+1) = input; % input state
        
    % Propagate signal through network one timestep
    activation = activation*wMat;
    
    % Apply activation functions
   for i=1:length(activation) % skip input and bias
        % get activation for next node in network
        a(:,i) = p.activate(activation(:,i),aMat(i));
   end   
        
end
