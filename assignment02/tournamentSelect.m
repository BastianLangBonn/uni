%% Determine Mates
% Given a population, their fitness and the size of the population, this
% function uses tournament selection to determine mates for crossover.

function [mates] = tournamentSelect(population, values)
    populationSize = length(population(:,1));
    competitors = randi(populationSize, populationSize, 2);
    hasFirstCompetitorWon = values(competitors(:,1)) > values(competitors(:,2));
    winnerIndizes = [competitors(hasFirstCompetitorWon,1);competitors(~hasFirstCompetitorWon,2)];
    mates = population(winnerIndizes,:);
end

