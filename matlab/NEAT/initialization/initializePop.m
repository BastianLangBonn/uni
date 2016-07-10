%% InitializePop - Creates initial NEAT population
% _Node Genes
% 1-Node ID
% 2-Type (1=input, 2=output 3=hidden 4=bias)
% 3-Activation Function
%
% _Connection Genes
% 1-Innovation Number
% 2-Source
% 3-Destination
% 4-Weight
% 5-Enabled?
%
% _Innovation Record
% 1-Innovation Number
% 2-Source
% 3-Destination
% 4-New Node
% 5-Generation
%
%

function [pop,innovation]=initializePop(p)

%% Create base individual
ind = p.sampleInd;

% Create Nodes
ind.nodes(1,:) = [1:(p.inputs+p.outputs+1)];
ind.nodes(2,:) = [4, ones(1,p.inputs), 2*ones(1,p.outputs)]; % Bias, Inputs, Outputs
ind.nodes(3,:) = p.activations;

% Create Connections
numberOfConnections = (p.inputs+1)*p.outputs;
ins = [1:p.inputs+1]; % IDs of input nodes
outs = p.inputs+1 + [1:p.outputs];

ind.conns(1,:) = [1:numberOfConnections];
ind.conns(2,:) = repmat(ins,1,length(outs)); % Once source for every destination
ind.conns(3,:) = sort(repmat(outs,1,length(ins)))';
ind.conns(4,:) = 2.*(rand(1,numberOfConnections)-0.5).*p.weightCap;
ind.conns(5,:) = ones(1,numberOfConnections);

% Initialize struct values
ind.fitness = 0;
ind.birth = 1;
ind.species = 0;
ind.pheno = [];


%% Create Population of base individuals
for i=1:p.popSize
    pop(i) = ind;
    pop(i).conns(4,:) = 2.*(rand(1,numberOfConnections)-0.5).*p.weightCap;
end

%% Create Innovation Record
innovation = zeros(5,numberOfConnections);
innovation(4,end) = ind.nodes(1,end);
innovation([1:3],:) = ind.conns([1:3],:);
end














