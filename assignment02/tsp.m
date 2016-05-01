clear;

%% Initialize Parameters
maximumGenerations = 10000;
populationSize = 30;
crossoverRate = 0.9;
nSpecies = populationSize/3;

cities = importdata('cities.csv');
numberOfGenes = length(cities.data);
mutationRate = 1/numberOfGenes;

%% Compute Distances
distances = zeros(length(cities.data), length(cities.data));
for x = 1:length(cities.data)
    for y = 1:length(cities.data)
        distances(x,y) = sqrt((cities.data(x,2) - cities.data(y,2))^2 +...
            (cities.data(x,3) - cities.data(y,3))^2);
    end
end

%% Initialize population
population = zeros(populationSize, length(cities.data));
for index = 1:populationSize
    population(index,:) = randperm(length(cities.data));
end



bestFitness = zeros(maximumGenerations,1);
medianFitness = zeros(maximumGenerations,1);
%% Evolution Loop
tic;
for generation = 1:maximumGenerations
    % Evaluate population
    fitness = -1* computeRouteDistance(population, distances);
    
    % Store fitness information for analysis and elitism
    [bestFitness(generation), best_index] = max(fitness);
    medianFitness(generation) = median(fitness);
    bestIndividual = population(best_index,:);
    
    % Speciate population
    fitness = speciatePopulation(population, fitness, nSpecies);
    
    
    % Tournament Selection
    matesA = tournamentSelect(population, fitness, populationSize);
    matesB = tournamentSelect(population, fitness, populationSize);
    
    % Recombination
    population = onePointCrossoverSet(matesA, matesB, crossoverRate);
    
    % Mutation
    %population = mutateNeighbours(population, mutationRate);
    population = mutateRandomly(population, mutationRate);
    
    % Elitism
    population(1,:) = bestIndividual;
    
    % Plot Parents and Children
%     figure(1);
%     subplot(1,3,1);imagesc(matesA);xlabel('Genes');ylabel('Individuals');title('ParentsA')
%     subplot(1,3,2);imagesc(matesB);xlabel('Genes');ylabel('Individuals');title('ParentsB')
%     subplot(1,3,3);imagesc(population);xlabel('Genes');ylabel('Individuals');title('Children')
%     pause(0.001);
end

bestFitness(end)
%cities.data(best_individual,2);
figure(2);clf;hold on;
plot([cities.data(bestIndividual,2);cities.data(bestIndividual(1),2)],...
    [cities.data(bestIndividual,3);cities.data(bestIndividual(1),3)]);
plot(cities.data(:,2), cities.data(:,3),'bo');
plot(cities.data(bestIndividual(1),2), cities.data(bestIndividual(1),3),'r.');
xlabel('x-coordinates');
ylabel('y-coordinates');
legend('Best found route', 'cities', 'start city');

figure(3);clf;hold on;
plot(-1*bestFitness);
plot(-1*medianFitness);
ylabel('travelled distance in km');
xlabel('generation');
legend('best fitness','median fitness');


% Use Speciation with kmeans
% print city names of best individual