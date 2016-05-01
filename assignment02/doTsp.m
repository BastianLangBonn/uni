function [ result ] = doTsp( parameters )
%DOTSP Summary of this function goes here
%   Detailed explanation goes here

    %% Initialize Parameters
    %Read data from parameter
    maxGenerations = parameters.maxGenerations;
    populationSize = parameters.populationSize;
    crossoverRate = parameters.crossoverRate;
    nSpecies = parameters.nSpecies;
    useSpeciation = parameters.useSpeciation;
    useRandomMutation = parameters.useRandomMutation;
    useOnePointCrossover = parameters.useOnePointCrossover;
    mutationRate = parameters.mutationRate;
    cities = parameters.cities;



    % Compute Distances
    clear distances;
    distances = zeros(length(cities.data), length(cities.data));
    for x = 1:length(cities.data)
        for y = 1:length(cities.data)
            distances(x,y) = sqrt((cities.data(x,2) - cities.data(y,2))^2 +...
                (cities.data(x,3) - cities.data(y,3))^2);
        end
    end
    
    % Initialize Loop Parameters
    bestFitness = zeros(maxGenerations,1);
    medianFitness = zeros(maxGenerations,1);

    %% Initialize population
    population = zeros(populationSize, length(cities.data));
    for index = 1:populationSize
        population(index,:) = randperm(length(cities.data));
    end

    %% Evolution Loop
    for generation = 1:maxGenerations
        % Evaluate population - fitness is better the smaller the travelled
        % distance
        fitness = -1* computeRouteDistance(population, distances);

        % Store fitness information for analysis and elitism
        [bestFitness(generation), best_index] = max(fitness);
        medianFitness(generation) = median(fitness);
        bestIndividual = population(best_index,:);

        % Speciate population
        if useSpeciation
            fitness = speciatePopulation(population, fitness, nSpecies);
        end
        
        % Tournament Selection
        matesA = tournamentSelect(population, fitness, populationSize);
        matesB = tournamentSelect(population, fitness, populationSize);

        % Recombination
        if useOnePointCrossover
            population = onePointCrossoverSet(matesA, matesB,...
                crossoverRate);
        else
            population = twoPointCrossoverSet(matesA, matesB,...
                crossoverRate);
        end
        
        % Mutation
        if useRandomMutation
            population = mutateRandomly(population, mutationRate);
        else
            population = mutateNeighbours(population, mutationRate);
        end        

        % Elitism
        population(1,:) = bestIndividual;
    end
    
    result.bestIndividual = bestIndividual;
    result.medianFitness = medianFitness;
    result.bestFitness = bestFitness;
    result.bestRoute = cities.textdata(bestIndividual);
    result.cities = cities;

end

