function [ mutatedPopulation ] = mutateRandomly( population, mutationRate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mutatedPopulation = zeros(size(population));
    populationSize = length(population(:,1));
    for index = 1:populationSize
        individual = population(index,:);
        if rand(1) < mutationRate
            indexA = randi(length(population(1,:)));
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

