function [ result ] = createMatrixFromWeights( p )
%CREATEMATRIXFROMWEIGHTS Creates a weight matrix for a FFN out of a set
%of weights. Returns an error string if input dimensions mismatch
%   Input: p.topology -> Topology of net. Ex: [2 2 1]
%       p.weights -> Weights in order: InputToHidden, HiddenToOutput, Bias
%       to HiddenAndOutput. Ex: [0.5 0.2 0.4]
    expectedNInput = p.topology(1) * p.topology(2)  + ... %Input to Hidden
        p.topology(2) * p.topology(3) +... %Hidden to Output
        p.topology(2) + p.topology(3); %Bias to Hidden and Output
    
    if expectedNInput ~= length(p.points)
        result = 'Wrong number of weights';
        return
    end
    
    nRows = p.topology(1)+p.topology(2)+1;
    nColumns = p.topology(2)+p.topology(3);
    result = zeros(nRows, nColumns);
    counter = 1;
    % Fill rows representing outgoing connections from inputs
    for row = 1:p.topology(1)
        % Connect input only to hidden
        for i = 1:p.topology(2)
           result(row,i) = p.points(counter);
           counter = counter + 1;
        end
    end
    % Fill rows representing outgoing connections from hidden to output
    for row = p.topology(1)+1:p.topology(1)+p.topology(2)
        % Connect hidden only to output
        for i = p.topology(2)+1:nColumns
            result(row,i) = p.points(counter);
            counter = counter + 1;
        end
    end
    result(nRows,:) = p.points(counter:end);
end

