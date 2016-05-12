function result = isDominating(iA, iB, p)
%ISDOMINATING Checks if individual at position iA is dominating individual
%at position iB
%   An individual dominates another iff one of its fitness values is greater
%   than the other's fitness value while all other fitness values are
%   greater or equal.
    if p.value(iA) > p.value(iB) &&...
            p.weight(iA) >= p.weight(iB)
       result = 1;
    elseif p.weight(iA) > p.weight(iB) &&...
            p.value(iA) >= p.value(iB)
        result =  1;
    else
        result = 0;
    end
end

