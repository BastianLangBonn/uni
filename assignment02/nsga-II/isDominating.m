function result = isDominating(iA, iB, p)
%ISDOMINATING Checks if individual at position iA is dominating individual
%at position iB
%   An individual dominates another iff one of its fitness values is greater
%   than the other's fitness value while all other fitness values are
%   greater or equal.
    if p.leadingZeros(iA) > p.leadingZeros(iB) &&...
            p.tailingOnes(iA) >= p.tailingOnes(iB)
       result = 1;
    elseif p.tailingOnes(iA) > p.tailingOnes(iB) &&...
            p.leadingZeros(iA) >= p.leadingZeros(iB)
        result =  1;
    else
        result = 0;
    end
end

