%% Evolutionary Algorithm

% Initialize Population
% Evaluate Population
% Selection
% Recombination

% clear variables
clear;
%% Algorithm Parameters
populationSize = 5;
numberOfGenes = 7;


%% Initialize Population
population = randi([0 1], populationSize, numberOfGenes);

%% Evaluate Population
% Simply count the number of ones in every gene
values = sum(population,2)

%% Selection
% Elitism
[bestIndividuum, index] = max(values)

% Tournament
firstCompetitors = randi(populationSize,populationSize,2);
racketOneWon = values(firstCompetitors(:,1)) > values(firstCompetitors(:,2));
winnerIndizes = [firstCompetitors(racketOneWon,1);firstCompetitors(~racketOneWon,2)];
firstMates = population(winnerIndizes,:);

secondCompetitors = randi(populationSize, populationSize, 2);
racket
