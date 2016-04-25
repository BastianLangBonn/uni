function [ mutated_population ] = randomly_mutate( population, mutation_rate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mutated_population = zeros(size(population));
    for index = 1:length(population(:,1))
        individual = population(index,:);
        if rand(1) < mutation_rate
            index_a = randi(length(population(1,:)));
            index_b = index_a;
            while index_a == index_b
                index_b = randi(length(population(1,:)));
            end
            gene_a = individual(index_a);
            gene_b = individual(index_b);
            individual(index_a) = gene_b;
            individual(index_b) = gene_a;
        end
        mutated_population(index, :) = individual;
    end
end

