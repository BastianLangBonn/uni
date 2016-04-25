function [ distance ] = evaluate( population, distances )
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here
    population_size = length(population(:,1));
    distance = zeros(population_size,1);
    for individual_index = 1:population_size
        individual = population(individual_index, :);
        for gene_index = 1:length(individual)-1
            distance(individual_index) = distance(individual_index) +...
                distances(individual(gene_index),individual(gene_index+1));
        end
        distance(individual_index) = distance(individual_index) +...
            distances(individual(end), individual(1));
    end
end

