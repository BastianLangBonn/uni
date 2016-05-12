function [ offspring ] = generateOffspring( p )
%GENERATEOFFSPRING Create offspring for a given population
%   Generates offspring for the given population by using tournament
%   selection, mutation and crossover.

    % Tournament Selection
    
    nMates = round(p.nOffspring/2);
    matesA = tournamentSelect(p.population,...
        p.leadingZeros, nMates);
    matesB = tournamentSelect(p.population,...
        p.leadingZeros, nMates);

    matesC = tournamentSelect(p.population,...
        p.tailingOnes, nMates);
    matesD = tournamentSelect(p.population,...
        p.tailingOnes, nMates);
        
    % Crossover        
    % Combine mate's genes
    index = [1:nMates]';
    doCrossover = (rand(nMates, 1) < p.crossoverProbability);
    crossoverPoint = randi([1 p.nGenes - 1],...
        nMates, 1) .* doCrossover(index);

    offspring = [matesA(:,1:crossoverPoint)...
    matesB(:,crossoverPoint+1:p.nGenes)];

    doCrossover = (rand(nMates, 1) < p.crossoverProbability);
    crossoverPoint = randi([1 p.nGenes - 1],...
        nMates, 1) .* doCrossover(index);

    offspring = [offspring;matesC(:,1:crossoverPoint)...
    matesD(:,crossoverPoint+1:p.nGenes)];

    % Mutation
    % For each gene check if mutation shall appear
    mutate = (rand(size(offspring,1), p.nGenes) <...
        p.mutationProbability);

    offspring = xor(offspring, mutate);

end

