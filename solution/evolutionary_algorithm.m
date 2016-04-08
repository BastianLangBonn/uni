%% Evolutionary Algorithm

% clear variables
clear;
%% Algorithm Parameters
population_size = 30;
number_of_genes = 10;
crossover_probability = 0.9;
mutation_probability = 1./number_of_genes;
maximum_generations = 100;


%% Initialize Population
population = randi([0 1], population_size, number_of_genes);

figure(1);
imagesc(population);
xlabel('Genes');
ylabel('Individuals');
title('Children');

for generation=1:maximum_generations
    %% Evaluate Population
    % Simply count the number of ones in every gene
    fitness = sum(population,2);
    [best_fitness, index] = max(fitness);
    best_individuum = population(index,:);
    median_fitness = median(fitness);
    
    %% Early Termination
    if best_fitness == number_of_genes
        break;
    end
    
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
    mutate = (rand(population_size, number_of_genes) < mutation_probability);
    next_generation = xor(next_generation, mutate);
    
    population = next_generation;
    
    % View Parents and Children
    subplot(1,3,1);imagesc(first_mates);xlabel('Genes');ylabel('Individuals');title('ParentsA')
    subplot(1,3,2);imagesc(second_mates);xlabel('Genes');ylabel('Individuals');title('ParentsB')
    subplot(1,3,3);imagesc(population);xlabel('Genes');ylabel('Individuals');title('Children')
    pause(0.1);
end

%% Plot Result
figure(2);
clf;
plot(best_fitness);
hold on;
plot(median_fitness);
xlabel('Generations');
ylabel('Fitness');
legend('Max Fitness', 'Median Fitness','Location','SouthEast')
  