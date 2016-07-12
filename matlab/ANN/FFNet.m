%% FFNet - Returns activation of a FFANN given: input, weights, and activation functions
%
% function output = FFNet (wMat, aMat, input, p)
%
% Given an ordered weight matrix, corresponding activation matrix, initial
% input vector, returns the result of a Feed Forward Neural Network in
% vector form. Activations are integers corresponding to activation 
% functions set in 'activationFunctions.m'. The number of outputs are set 
% within the parameter (p) struct.
%
% Note: Bias is treated as any other input and must be set in the input
% vector before passing to this function
%
function output = FFNet (wMat, aMat, input, p)

    numNodes = length(wMat);
    a = [input, zeros(size(input,1),numNodes-p.inputs)];
    
    for i=p.inputs+2:numNodes % skip input and bias
        % get activation for next node in network
        a(:,i) = a*wMat(:,i);
        a(:,i) = p.activate(a(:,i),aMat(i));
    end

    output = a(:,(end+1-p.outputs):end);
    
end
