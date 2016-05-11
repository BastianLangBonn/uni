% Unit test for computeFitness

population = [0,0,1,0,1];
expectedLeadingZeros = 2;
expetedTrailingOnes = 1;

result = computeFitness(population);

disp(result{1}.leadingZeros == expectedLeadingZeros);
disp(result{1}.trailingOnes == expetedTrailingOnes)