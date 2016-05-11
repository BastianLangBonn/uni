%% Determine Mates
% Given a population, their fitness and the number of needed mates, this function uses tournament
% selection to determine mates for crossover.

function [mates] = tournamentSelect(population, values, nMates)
    nPopulation = size(population,2);
    competitors = randi(nPopulation, nMates, 2);
    hasFirstCompetitorWon = values(competitors(:,1)) > values(competitors(:,2));
    winnerIndizes = [competitors(hasFirstCompetitorWon,1);competitors(~hasFirstCompetitorWon,2)];
    mates = population(winnerIndizes,:);
end

