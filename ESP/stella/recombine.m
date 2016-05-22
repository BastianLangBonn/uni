function child = recombine(parentA, parentB, chance_crossover, chance_mutation, mut_range)
%Recombine performs crossover and mutation on two parents to make a child

    % Crossover
    if (rand < chance_crossover)
        b_component = randi([0 1],1,length(parentA.weights));
        b_component = (find(b_component == 1));
        child = parentA;
        child.weights([b_component]) = parentB.weights([b_component]);
    else
        if parentA.fitness > parentB.fitness
            child = parentA;
        else
            child = parentB;
        end
    end
    
    % Mutation
    for i=1:length(child.weights)
       if (rand < chance_mutation)
          child.weights(i) = child.weights(i) + mut_range.*randn;
          
          % Clamp values, and chance of deactivating connection
          if abs(child.weights(i)) < 0.1 || rand < 0.25
              child.weights(i) = 0;
          end
          
          if child.weights(i) > 2.5
              child.weights(i) = 2.5;
          end
          
          if child.weights(i) < -2.5
              child.weights(i) = -2.5;
          end
       end
    end
    
    child.trials  =  0;
    child.fitness = -1;


end