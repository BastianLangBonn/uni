function [r] = createWeightMatrizes(...
    population, nodeIndizes)
% Create weight matrizes for a given set of node indizes for each 
% subpopulation
    for i = 1:size(nodeIndizes,1)
        for j = 1:size(nodeIndizes,2)
            r{i}(:,j) = population(j,nodeIndizes(i,j)).weights;
        end
    end    
end