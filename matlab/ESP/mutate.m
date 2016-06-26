function [individual] = mutate(individual, chanceMutation, mutationRange)
    for i=1:length(individual.weights)
        if (rand < chanceMutation)
            individual.weights(i) =...
                individual.weights(i) + mutationRange.*randn;
        end
    end
end