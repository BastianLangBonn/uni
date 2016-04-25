%% Initialize Parameters
maximum_generations = 1000;
population_size = 18;
crossover_rate = 0.9;

%% Read Cities
cities = importdata('cities.csv');
number_of_genes = length(cities.data);
mutation_rate = 1;%/number_of_genes;

%% Compute Distances
distances = zeros(length(cities.data), length(cities.data));
for x = 1:length(cities.data)
    for y = 1:length(cities.data)
        distances(x,y) = sqrt((cities.data(x,2) - cities.data(y,2))^2 +...
            (cities.data(x,3) - cities.data(y,3))^2);
    end
end

%% Initialize population
population = zeros(population_size, length(cities.data));
for index = 1:population_size
    population(index,:) = randperm(length(cities.data));
end

figure(1);
imagesc(population);

best_fitness = zeros(maximum_generations,1);
median_fitness = zeros(maximum_generations,1);
%% Evolution Loop
for generation = 1:maximum_generations
    % Evaluate population
    fitness = -1* evaluate(population, distances);
    [best_fitness(generation), best_index] = max(fitness);
    median_fitness(generation) = median(fitness);
    best_individual = population(best_index,:);
    
    % Tournament Selection
    mates_a = tournament_select(population, fitness, population_size);
    mates_b = tournament_select(population, fitness, population_size);
    
    % Recombination
    population = one_point_crossover(mates_a, mates_b);
    
    % Mutation
    %population = neighbour_mutation(population, mutation_rate);
    population = randomly_mutate(population, mutation_rate);
    
    % Elitism
    population(1,:) = best_individual;
    
    % Plot Parents and Children
    subplot(1,3,1);imagesc(mates_a);xlabel('Genes');ylabel('Individuals');title('ParentsA')
    subplot(1,3,2);imagesc(mates_b);xlabel('Genes');ylabel('Individuals');title('ParentsB')
    subplot(1,3,3);imagesc(population);xlabel('Genes');ylabel('Individuals');title('Children')
    pause(0.1);
end

best_fitness
%cities.data(best_individual,2);
figure(2);
hold on;
plot(cities.data(best_individual,2), cities.data(best_individual,3));
plot(cities.data(:,2), cities.data(:,3),'bo');
plot(cities.data(best_individual(1),2), cities.data(best_individual(1),3),'r.');

figure(3);
hold on;
plot(-1*best_fitness);
plot(-1*median_fitness);
ylabel('travelled distance');
xlabel('generation');
legend('best fitness','median fitness');
