function [ mutatedPopulation ] = mutateNeighbours( population, mutationRate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mutatedPopulation = zeros(size(population));
    populationSize = length(population(:,1));
    genomeSize = length(population(1,:));
    for index = 1:populationSize
        individual = population(index,:);
    
        for gene = 1:genomeSize-1
            if (rand(1) <= mutationRate)
                geneA = individual(gene);
                geneB = individual(gene+1);
                individual(gene) = geneB;
                individual(gene+1) = geneA;
            end
        end
        mutatedPopulation(index, :) = individual;
    end

end

