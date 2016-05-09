function [ newFitness ] = speciatePopulation( ...
    population, fitness, nSpecies )
%SPECIATEPOPULATION Uses kmeans to speciate the population and accordingly
%adapts the population's fitness
    newFitness = zeros(size(fitness));
    [iCluster, cluster] = kmeans(population, nSpecies);
    sizeSpecies = zeros(nSpecies,1);
    for i = 1:nSpecies
       sizeSpecies(i,1) = sum(iCluster == i); 
    end
    for i = 1:length(population(:,1))
        newFitness(i,1) = fitness(i,1) / sizeSpecies(iCluster(i),:);        
    end

end

