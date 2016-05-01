function [ mutatedPopulation ] = mutateRandomly( population, mutationRate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mutatedPopulation = zeros(size(population));
    populationSize = length(population(:,1));
    for index = 1:populationSize
        individual = population(index,:);
        for indexA = 1:length(individual(1,:))
            if rand(1) < mutationRate
                indexB = indexA;
                while indexA == indexB
                    indexB = randi(length(population(1,:)));
                end
                geneA = individual(indexA);
                geneB = individual(indexB);
                individual(indexA) = geneB;
                individual(indexB) = geneA;
            end
            mutatedPopulation(index, :) = individual;
        end
    end
end

