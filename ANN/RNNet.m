function [ a ] = RNNet( wMat, input, activation )

  activation(1) = 1; % Bias
  activation(2:size(input,2)+1) = input(1,:);
  activation = activation * wMat;
  a = tanh(activation);
end

