data = importdata('items.csv')
weights = data.data(:,1);
values = data.data(:,2);

% population = randi([0 1], 1, p.nGenes);
population = zeros(1,p.nGenes);

result = computeFitness(population, values, weights);

result.weight == 0
result.value == 0

A = ones(1,p.nGenes);
computeFitness(A, values, weights)