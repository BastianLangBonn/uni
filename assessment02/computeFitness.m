function [ result ] = computeFitness( population, values, weights )
%COMPUTEFITNESS Computes the fitness of the population
%   Computes the number of leading zeros and tailing ones for every
%   individual within the population and stores both values as fields in
%   result.
    for i=1:size(population,1)
%         
%         % Leading zeros
%         result.weight(i) = 0;
%         result.value(i) = 0;
%         for j = 1:size(population,2)
%             
%         end
        individual = population(i,:);
        result.value(i) = individual*values;
        result.weight(i) = 803 - individual*weights;
    end
    
    

end

