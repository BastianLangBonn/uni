%% Determine Mates
% Given a population with its fitness and the selective pressure, this
% function uses tournament selection to determine two sets of mates for
% crossover.

function [parents] = tournamentSelect(population, selectivePressure)

    nParents = size(population,2);
    iCompetitors = randi(nParents, nParents, 2*selectivePressure);
    competitors = population(iCompetitors);
    for i=1:nParents
        for j=1:2*selectivePressure
            fitness(j) = population(iCompetitors(i,j)).fitness;
        end        
        [x iMates(1)] = max(fitness(1:selectivePressure));
        [x iMates(2)] = max(fitness(selectivePressure+1:end));
        
        parents(i,1) = population(iCompetitors(i,iMates(1)));
        parents(i,2) = ...
          population(iCompetitors(i,selectivePressure+iMates(2)));       
    end
end

