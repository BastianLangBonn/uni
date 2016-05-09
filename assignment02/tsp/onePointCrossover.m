function [ offspring ] = onePointCrossover( mateA, mateB, crossoverPoint )
% Does one point crossover on two mates
%   Takes genes of mateA until crossover point, then takes remaining genes
%   in the order of appearance in mateB.

    partA = mateA(1:crossoverPoint);
    % Find values in mateB that are not in partA and keep their order
    missingPart = setdiff(mateB, partA, 'stable'); 
    
    offspring = [partA, missingPart];
    
end

