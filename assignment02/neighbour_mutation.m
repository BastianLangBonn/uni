function [ mutated_population ] = neighbour_mutation( population, mutation_rate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mutated_population = zeros(size(population));
    for index = 1:length(population(:,1))
        individual = population(index,:);
    
        for gene = 1:length(individual)-1
            if (rand(1) < (mutation_rate-1))
                gene_a = individual(gene);
                gene_b = individual(gene+1);
                individual(index_a) = gene_b;
                individual(index_b) = gene_a;
            end
        end
        mutated_population(index, :) = individual;
    end

end

