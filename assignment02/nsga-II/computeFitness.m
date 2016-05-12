function [ result ] = computeFitness( population )
%COMPUTEFITNESS Computes the fitness of the population
%   Computes the number of leading zeros and tailing ones for every
%   individual within the population and stores both values as fields in
%   result.
    for i=1:size(population,1)
        % Leading zeros
        nLeadingZeros = 0;
        while nLeadingZeros +1  < size(population,2) &&...
                population(i,nLeadingZeros+1) == 0
           nLeadingZeros = nLeadingZeros + 1; 
        end
        if population(i,end) == 0 && nLeadingZeros == size(population,2) -1
           nLeadingZeros = size(population, 2); 
        end
        
        nTailingOnes = 0;
        while nTailingOnes < size(population,2) &&...
                population(i,end-nTailingOnes) == 1
            nTailingOnes = nTailingOnes + 1;
        end
        
        result.leadingZeros(i) = nLeadingZeros;
        result.tailingOnes(i) = nTailingOnes;
    end
    

end

