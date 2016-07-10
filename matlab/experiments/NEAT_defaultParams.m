%% Default parameters set as found in original NEAT paper
% Stanley 2009/2002 HyperNEAT/NEAT Publications
%
% Obviously DO change these to suit your problem and tweak them for best
% performance, but here is a good place to start.
% 
% Popsize		100
% Gens          300
% Disjoint      2
% Excess		2
% Weight		1
% CompatThesh	6
% DropOffAge	15 gens
% SurvivThesh   20%
% AddNode		3%
% AddConn		10%
% MutConn		80%
% Min4Elite     5
% CrossPer      75%
% Reenable      25%
%
%%

function p = NEAT_defaultParams
p.parallel = false;
p.alg = 'NEAT';

% Network Parameters
p.recurrent = true;
activationFunctions;    % ANN activation functions
p.actRange = 3;

% Algorithm Parameters
p.maxGen = 1000;
p.popSize= 150;
p.run = @(p)NEAT(p);

% Speciation Parameters
p.specType = 'original';
p.excess    = 1.0;
p.disjoint  = 1.0;
p.weightDif = 0.4;
p.specThresh= 3.0;
p.dropOffAge = 15;

% Selection Parameters
p.cullRatio= 0.2;
p.minForCull= ceil(1/p.cullRatio);
p.minForElitism = 5;
p.tournamentSize = 2;

% Recombination Parameters
p.crossoverProb =   0.90;
p.addNodeProb =     0.03;
p.addConnProb =     0.10;
p.mutConnProb =     0.80;
p.enableProb =      0.25;
p.disableProb =     0.00; 
p.weightCap =       5;
p.mutWeightRange =  1;
p.numActivations =  5;

% Visualization Parameters
displayParams;

% Individual Fitness Information
p.sampleInd.fitness = 0;




    