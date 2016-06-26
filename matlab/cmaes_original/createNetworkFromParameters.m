function [wMat]= createNetworkFromParameters(parameters, topology)
%CREATENETWORKFROMPARAMETERS Creates a square weight matrix given the
%weights to the hidden and output layers and the network topology.

  dimension = 1 + sum(topology);
  wMat = zeros(dimension,dimension);
  counter = 1;
  for i=1:dimension
    for j=dimension - (topology(2) + topology(3)) + 1:dimension
      wMat(i,j) = parameters(counter);
      counter = counter + 1;
    end
  end

end