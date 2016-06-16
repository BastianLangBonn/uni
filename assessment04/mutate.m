function [individual] = mutate(individual, chanceMutation, mutationRange)
% MUTATE Function that performs mutation on an individual. Randomly varies
% each weight with a certain chance within a given range.
    for i=1:length(individual.weights)
        if (rand < chanceMutation)
            individual.weights(i) =...
                individual.weights(i) + mutationRange.*randn;
        end
    end
end