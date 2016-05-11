% Unit test for computeFitness

population = [0,0,1,0,1];
expectedLeadingZeros = 2;
expetedTrailingOnes = 1;

result = computeFitness(population);

disp(result.leadingZeros(1) == expectedLeadingZeros);
disp(result.trailingOnes(1) == expetedTrailingOnes)