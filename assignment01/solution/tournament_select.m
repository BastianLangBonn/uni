%% Determine Mates
% Given a population, their fitness and the size of the population, this
% function uses tournament selection to determine mates for crossover.

function [mates] = tournament_select(population, values, population_size)
    competitors = randi(population_size, population_size, 2);
    first_competitor_won = values(competitors(:,1)) > values(competitors(:,2));
    winner_indizes = [competitors(first_competitor_won,1);competitors(~first_competitor_won,2)];
    mates = population(winner_indizes,:);
end

