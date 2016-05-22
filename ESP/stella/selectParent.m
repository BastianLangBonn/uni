function parent_id = selectParent(breeding_pool, selection_pressure)
%selectParent Selects a parent from a parent pool (tournament selection)
%   Detailed explanation goes here

parent_pool = unique(randi(length(breeding_pool), selection_pressure,1));
    for candidate=1:length(parent_pool)
        fitnesses(candidate) = breeding_pool(parent_pool(candidate)).fitness;
    end
    parent_id = find(fitnesses == min(fitnesses),1);
end