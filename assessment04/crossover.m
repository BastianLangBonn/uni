function [offspring] = crossover(mates, chanceCrossover)
% CROSSOVER This function performs a crossover between two mates by
% randomly selecting weights from the two mates. If by chance no crossover
% should take place, the fitter mate will be copied.
    if rand > chanceCrossover
        if mates(1).fitness > mates(2).fitness
            offspring = mates(1);
        else
            offspring = mates(2);
        end
    else
        iPartsOfB = randi([0 1], 1,length(mates(1).weights));
        iPartsOfB = (find(iPartsOfB == 1));
        offspring = mates(1);
        offspring.weights(iPartsOfB) = mates(2).weights(iPartsOfB);
        offspring.trials = 0;
        offspring.fitness = 0;
    end
end