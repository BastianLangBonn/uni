function [r] = createWeightMatrizes(...
    population, order, nOutgoingConnections)
    for i=1:size(order,2) % nIndividualsPerSubpopulation
        for j=1:size(order,1) % nSubpopulations
            r{i}.weights(:,j) = population(j,order(j,i)).weights;
        end
    end
end