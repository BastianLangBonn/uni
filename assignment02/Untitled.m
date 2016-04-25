%% Initialize Parameters
maximum_generations = 100;
population_size = 18;
crossover_rate = 0.9;

%% Read Cities
cities = importdata('cities.csv');
number_of_genes = length(cities.data);
mutation_rate = 1/number_of_genes;

%% Compute Distances
distance = zeros(length(cities.data), length(cities.data));
for x = 1:length(cities.data)
    for y = 1:length(cities.data)
        distance(x,y) = sqrt((cities.data(x,1) - cities.data(y,1))^2 +...
            (cities.data(x,2) - cities.data(y,2))^2+...
            (cities.data(x,3) - cities.data(y,3))^2);
    end
end


randperm(5)