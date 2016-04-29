function [ offspring ] = onePointCrossover( matesA, matesB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    populationSize = length(matesA(:,1));
    genomeSize = length(matesA(1,:));
    crossoverPoint = randi(genomeSize,populationSize,1);
    
    for index=1:populationSize
        mate_a = matesA(index,:);
        mate_b = matesB(index,:);
        for gene=crossoverPoint:genomeSize
            find(mate_b==mate_a(gene));
        end        
    end
    offspring = matesA;
end

