function result = isDominating(iA, iB, p)
%ISDOMINATING Checks if individual at position iA is dominating individual
%at position iB
    if p.leadingZeros(iA) > p.leadingZeros(iB) &&...
            p.trailingOnes(iA) >= p.trailingOnes(iB)
       result = 1;
    elseif p.trailingOnes(iA) > p.trailingOnes(iB) &&...
            p.leadingZeros(iA) >= p.leadingZeros(iB)
        result =  1;
    else
        result = 0;
    end
end

