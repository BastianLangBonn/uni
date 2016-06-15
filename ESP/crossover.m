function [offspring] = crossover(mates, chanceCrossover)
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