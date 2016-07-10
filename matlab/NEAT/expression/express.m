%% Express - Converts genotype to weight and activation matrix for neural network
%
%

function pheno = express(ind,p)

ind.conns(4,find(ind.conns(5,:)==0)) = 0.0;

if p.recurrent
    numNodes = size(ind.nodes,2);
    lookup = ind.nodes(1,:);
    wMat = zeros(numNodes);
    [conns, conns] = ismember(ind.conns([2 3],:),lookup); % replace innov# with connIDs
    for i=1:length(conns)
        wMat(conns(1,i),conns(2,i)) = ind.conns(4,i);
    end
    aMat = ind.nodes(3,:);
else
    [order, wMat] = getNodeOrder(ind);
    aMat = ind.nodes(3,order);
    
end

pheno.aMat = aMat;
pheno.wMat = wMat;

end