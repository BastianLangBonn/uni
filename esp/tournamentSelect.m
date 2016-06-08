%% Determine Mates
% Given a population with its fitness and the selective pressure, this
% function uses tournament selection to determine two sets of mates for
% crossover.

function [mates] = tournamentSelect(population, selectivePressure)

    nParents = length(population);
    iCompetitors = randi(length(population), nParents, 2*selectivePressure);
    competitors = population(iCompetitors);
    for i=1:size(competitors,1)
        for j=1:size(competitors,2)
            fitness(i,j) = competitors.fitness;
        end
        [x iMates(i,1)] = max(fitness(i,1:selectivePressure));
        [x iMates(i,2)] = max(fitness(i,selectivePressure+1:end));
    end
    mates(:,1) = population(iMates(:,1));
    mates(:,2) = population(iMates(:,2));
end

