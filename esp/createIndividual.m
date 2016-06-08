function [individual] = createIndividual(nConnections, weightRange)

    individual.fitness = 0;
    individual.trials  = 0;
    individual.weights = (rand(nConnections,1)-0.5) * (2*weightRange);

    % Reduce active connections
    x = rand(nConnections,1);
    x(x<0.75) = 0;
    x(x>=0.75)= 1;

    individual.weights = individual.weights .* x;

end