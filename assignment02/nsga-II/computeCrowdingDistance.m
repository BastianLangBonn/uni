function [ distance ] = computeCrowdingDistance( p )
%COMPUTECROWDINGDISTANCE Summary of this function goes here
%   Detailed explanation goes here
    nPopulation = size(p.population, 1);
    distance = zeros(nPopulation, 1);
    
    
    % Leading Zeros
    % TODO first sort by leading zeros
    [values, index] = sort(p.leadingZeros);
    distance(1) = Inf;
    distance(end) = Inf;
    
    for i=2:nPopulation-1
        distance(i) = distance(i) + ...
            ((p.leadingZeros(i+1) - p.leadingZeros(i-1))/...
            (max(p.leadingZeros) - min(p.leadingZeros)));
    end
    
    % Trailing Ones
    % TODO sort by trailing ones and set first and last to Inf
    for i=2:nPopulation-1
        distance(i) = distance(i) + ...
            ((p.trailingOnes(i+1) - p.trailingOnes(i-1))/...
            (max(p.trailingOnes) - min(p.trailingOnes)));
    end
    
end

