function [ population ] = nsga2( p )
%NSGA2 Summary of this function goes here
%   Detailed explanation goes here
    % Initialize population
    p.population = randi([0 1], p.nPopulation, p.nGenes);
    
    for generation=1:p.nGenerations
        figure(1);clf;hold on;
        title(sprintf('Parents Generation %d', generation));
        imagesc(p.population);xlabel('Genes');...
            ylabel('Individuals');range([0,p.nGenes,0,p.nPopulation]);
        pause(0.1);
        
        % Evaluation
        fitness = computeFitness(p.population);
        p.leadingZeros = fitness.leadingZeros;
        p.tailingOnes = fitness.tailingOnes;
        
        % Create and evaluate offspring
        offspring = generateOffspring(p);
        fitness = computeFitness(offspring);
        p.leadingZeros = [p.leadingZeros fitness.leadingZeros];
        p.tailingOnes = [p.tailingOnes fitness.tailingOnes];
        
        p.population = [p.population;offspring];
        paretoFronts = dominationSort(p);
        nextPopulation = [];
        i = 1;
        while size(nextPopulation,1) + length(paretoFronts{i}) <=...
                p.nPopulation
            indizes = paretoFronts{i};
            paretoElements = p.population(indizes,:);
            nextPopulation = [nextPopulation; paretoElements];
            i = i + 1;
        end
        if size(nextPopulation,1) ~= p.nPopulation
           distances = computeCrowdingDistance(...
               p.population(paretoFronts{i},:)); 
           
           [sortedDistances, iSortedDistances] = sort(distances,'descend');
           sortedPareto = paretoFronts{i}(iSortedDistances);
           individualsLeft = p.nPopulation - size(nextPopulation,1);
           bestSpacedIndividuals = p.population(...
               sortedPareto(1:individualsLeft),:);
           nextPopulation = [nextPopulation;bestSpacedIndividuals];
        end
        
        p.population = nextPopulation;
        
    end
    population = p.population;
end

