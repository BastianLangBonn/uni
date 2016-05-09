%% MutateNeighboursTest
% Unit test for the function mutateNeighboursTest

%% Rate of 1 reorders population
population = [1,2];
expectedPopulation = [2,1];
mutatedPopulation = mutateNeighbours(population, 1);

if mutatedPopulation == expectedPopulation
    disp('Mutation rate = 1: Test Passed')
else
    disp('Mutation rate = 1: Test Failed')
    expectedPopulation
    mutatedPopulation
end

%% Rate of 0 does not change population at all
expectedPopulation = [1,2];
mutatedPopulation = mutateNeighbours(population,0);

if mutatedPopulation == expectedPopulation
    disp('Mutation rate = 0: Test Passed')
else
    disp('Mutation rate = 0: Test Failed')
    expectedPopulation
    mutatedPopulation
end