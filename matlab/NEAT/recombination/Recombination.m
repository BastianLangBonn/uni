%% Recombination - Produce new population via crossover and mutation. Wrapper with execution timer.
%
% [pop, innovation] = recombination(species, p, innovation, gen)
%
recom_start = tic;

[pop, innovation] = recombine(species, p, innovation, gen);

recom_time(gen) = toc(recom_start);
