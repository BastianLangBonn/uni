% Unit test for computeFitness

population = [0,0,1,0,1];
expectedLeadingZeros = 2;
expetedTailingOnes = 1;

result = computeFitness(population);

disp(result.leadingZeros(1) == expectedLeadingZeros);
disp(result.tailingOnes(1) == expetedTailingOnes)

population = [0,0,0,0,0];
expectedLeadingZeros = 5;
expetedTailingOnes = 0;

result = computeFitness(population);

disp(result.leadingZeros(1) == expectedLeadingZeros);
disp(result.tailingOnes(1) == expetedTailingOnes)

population = [1,1,1,1,1];
expectedLeadingZeros = 0;
expetedTailingOnes = 5;

result = computeFitness(population);

disp(result.leadingZeros(1) == expectedLeadingZeros);
disp(result.tailingOnes(1) == expetedTailingOnes)