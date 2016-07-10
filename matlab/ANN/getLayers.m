%% getLayers - Returns logical matrix indicating layers of each node in a FFANN
%
%   function layMat = getLayers(individual)
%
%   Returns a logical matrix, where rows indicate the node number and 
%   columns indicate the layer of the node. 
%

function [layMat] = getLayers(ind)

[order, wMat] = getNodeOrder(ind);
connMat = logical(wMat);
layMat = false(size(connMat));

% Add input nodes to first layer
layMat(:,1) = (sum(connMat)==0);
inputs = sum(sum(layMat));

% Non-input node is 2nd layer
current_layer = 2;

for i=inputs+1:length(connMat)
    % Is current node destination of any nodes in current layer?
    if sum(layMat(connMat(:,i),current_layer))
        % If it is then we've reached the next layer, otherwise we are
        % still in the same layer
        current_layer = current_layer+1;
    end
    layMat(i,current_layer) = true;    
end

layMat = layMat(:,[1:current_layer]);

end