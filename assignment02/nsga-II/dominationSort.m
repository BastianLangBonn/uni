function [ paretoFront ] = dominationSort( p )
%DOMINATIONSORT Divides a population into pareto fronts of increasing
%order.
%   Computes the domination sets and counts for every individual and
%   assigns each individual to the pareto front it belongs to.
%   This is done by checking for each individual the individuals it
%   dominates and is dominated by. If there is no dominating individual,
%   the individual goes into the front. 
%   For every next front the previous fronts get subtracted from each
%   remaining individual's domination counter. Again, if one of the
%   remaining individual's counter decreases to zero, it belongs to the
%   next front.
    [dominationSet{1:size(p.population,1)}] = deal([]);
    nDominators = zeros(size(p.population, 1),1);
    paretoFront{1} = [];
    for i=1:size(p.population,1)
        for j=1:size(p.population,1)
           if i~=j
               if isDominating(i,j,p)
                   dominationSet{i} = [dominationSet{i} j];
               elseif isDominating(j,i,p)
                       nDominators(i) = nDominators(i) + 1;
               end
                   
           end
        end
        
        if nDominators(i) == 0
           paretoFront{1} = [paretoFront{1} i];
        end
    end
    
    i = 1;
    while ~isempty(paretoFront{i});
       temp = [];
       for index = paretoFront{i}
           for dominated = dominationSet{index}
              nDominators(dominated) = nDominators(dominated) - 1;
              if nDominators(dominated) == 0
                 temp = [temp dominated]; 
              end
           end
       end
       i = i + 1;
       paretoFront{i} = temp;
    end
    
end