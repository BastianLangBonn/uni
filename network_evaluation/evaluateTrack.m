function [ fitness ] = evaluateTrack( weightMatrix, input, expectedOutput )
%EVALUATETRACK Summary of this function goes here
%   Detailed explanation goes here

  activation = zeros(1,size(weightMatrix,1));
  for step = 1:length(input)
    activation(1) = 1; % Bias
    activation(2:size(input,2)+1) = input(step,:);
    activation(size(input,2)+2:end) = activation * weightMatrix;
    activation = tanh(activation);
    output(step,:) = activation(end-size(expectedOutput,2)+1:end);
    error(step,:) = output(step,:) - expectedOutput(step,:);
  end
  fitness = mean([error(:,1).^2;error(:,2).^2]);
  

end

