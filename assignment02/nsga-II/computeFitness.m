function [ fitness ] = computeFitness( population )
%COMPUTEFITNESS Summary of this function goes here
%   Detailed explanation goes here
    for i=1:size(population,1)
        % Leading zeros
        nLeadingZeros = 0;
        while population(i,nLeadingZeros+1) == 0
           nLeadingZeros = nLeadingZeros + 1; 
        end
        
        nTrailingOnes = 0;
        while population(i,end-nTrailingOnes) == 1
            nTrailingOnes = nTrailingOnes + 1;
        end
        
        fitness{i}.leadingZeros = nLeadingZeros;
        fitness{i}.trailingOnes = nTrailingOnes;
    end
    

end

