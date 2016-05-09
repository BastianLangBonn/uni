function [ distance ] = computeRouteDistance( population, distances )
%COMPUTEROUTEDISTANCE Computes the distances of all individuals within a
%given population
%   Population: populationSize x genomeSize matrix
%   distances: n x n matrix containing the distances of every city to every
%   other city. Indexes refer to the gene values.
    populationSize = length(population(:,1));
    distance = zeros(populationSize,1);
    for iIndividual = 1:populationSize
        individual = population(iIndividual, :);
        for iGene = 1:length(individual)-1
            distance(iIndividual) = distance(iIndividual) +...
                distances(individual(iGene),individual(iGene+1));
        end
        distance(iIndividual) = distance(iIndividual) +...
            distances(individual(end), individual(1));
    end
end

