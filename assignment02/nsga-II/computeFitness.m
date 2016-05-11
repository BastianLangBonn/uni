function [ result ] = computeFitness( population )
%COMPUTEFITNESS Summary of this function goes here
%   Detailed explanation goes here
    for i=1:size(population,1)
        % Leading zeros
        nLeadingZeros = 0;
        while nLeadingZeros +1  < size(population,2) &&...
                population(i,nLeadingZeros+1) == 0
           nLeadingZeros = nLeadingZeros + 1; 
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

