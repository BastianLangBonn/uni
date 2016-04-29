function [ best_fitness, median_fitness ] = one_max( p )
%ONE_MAX Summary of this function goes here
%   Detailed explanation goes here
    %% Algorithm Parameters
    population_size = p.population_size;
    number_of_genes = p.number_of_genes;
    crossover_probability = p.crossover_probability;
    mutation_probability = p.mutation_probability;
    maximum_generations = p.maximum_generations;

    %% Determine Mates
    % Given a population, their fitness and the size of the population, this
    % function uses tournament selection to determine mates for crossover.

    function [mates] = tournament_select(population, values, population_size)
        competitors = randi(population_size, population_size, 2);
        first_competitor_won = values(competitors(:,1)) > values(competitors(:,2));
        winner_indizes = [competitors(first_competitor_won,1);competitors(~first_competitor_won,2)];
        mates = population(winner_indizes,:);
    end

    function [fitness] = determine_fitness(population)
        fitness = sum(population, 2);
    end

    %% Evolutionary Algorithm

    %% Initialize Population
    population = randi([0 1], population_size, number_of_genes);

    %% Evolution Loop
    for generation=1:maximum_generations
        %% Evaluate Population
        % Simply count the number of ones in every gene
        fitness = determine_fitness(population);
        [best_fitness(generation), index] = max(fitness);
        best_individuum = population(index,:);
        median_fitness(generation) = median(fitness);

        %% Early Termination
        % Can't do early termination here because of differing numbers of
        % fitness_values in the end
        %if best_fitness(generation) == number_of_genes
        %    break;
        %end

        %% Selection
        % Tournament
        first_mates = tournament_select(population, fitness, population_size);
        second_mates = tournament_select(population, fitness, population_size);

        

        %% Generate Next Generation
        % Crossover
        % Determine if crossover will be done for each pair of mates
        do_crossover = (rand(population_size, 1) < crossover_probability);

        % Combine mate's genes
        index = [1:population_size]';
        crossover_point = randi([1 number_of_genes-1], population_size, 1) .* do_crossover(index);
        next_generation = [first_mates(:,1:crossover_point)...
            second_mates(:,crossover_point+1:number_of_genes)];

        % Elitism
        next_generation(1,:) = best_individuum;

        % Mutate
        % For each gene check if mutation shall appear
        mutate = (rand(population_size, number_of_genes) < mutation_probability);
        % XOR exactly changes 1s to 0s and vice versa if mutate equals 1 and 
        % leaves genes as are if mutate equals 0
        % gene  mutate  result
        %  0      0       0
        %  0      1       1
        %  1      0       1
        %  1      1       0
        next_generation = xor(next_generation, mutate);

        population = next_generation;

    end

end

