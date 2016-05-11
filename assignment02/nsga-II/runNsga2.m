clear;
p.nGenerations = 100;
p.nPopulation = 12;
p.nOffspring = 12;
p.nGenes = 5;
p.crossoverProbability = 0.9;
p.mutationProbability = 1 / p.nGenes;

result = nsga2(p);
disp(result);