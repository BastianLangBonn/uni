function [ paretoFront ] = dominationSort( p )
%DOMINATIONSORT Summary of this function goes here
%   Detailed explanation goes here
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