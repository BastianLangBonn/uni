function p = optimalControlParams
%% Running Params
p = NEAT_defaultParams;
activationFunctions;
p.parallel = false;
p.startPlot = 1001;

%% Algorithm Hyperparameters
p.maxGen = p.startPlot-1;
p.popSize= 150;

%% Speciation
p.specType   = 'kmeans';
p.excess     = 1.0;
p.disjoint   = 1.0;
p.weightDif  = 0.5;
p.targetSpec = 5;       % for kmeans speciation
p.dropOffAge = 15;      % gens for species to not improve before dieing

%% Recombination
p.crossoverProb =   0.75;
p.addNodeProb =     0.1;%0.05
p.addConnProb =     0.16;%0.08
p.mutConnProb =     0.25;
p.enableProb =      0.05;
p.disableProb =     0.01;
p.weightCap =       2.00;
p.mutWeightRange =  0.50;

%% Fitness Function
p.fitFun = @evaluateOnTrack;
p.ftp = 168;
p.sampleInd.fitness = 0;
p.peakthreshold = 20;
p.peakMinDistance = 4;

%% Topology:
%       Inputs: current_velocity, desired_average_speed                 (2)
%       elevation diffs @1m, 2m, 4m, 8m, 16m, 32m, 64m, 128m            (8)

p.inputs = 10; 
p.activations = 1; %bias activation
p.activations = [p.activations ones(1,p.inputs)];

p.outputs = 1;
p.activations = [p.activations,1];

p.recurrent = false;
p.display_elite = true;
%% Track
meters = 8192;
track = 0.01*rand(meters,1);
x = 1:1:meters;
hills = 3*(sin(x/136)+1) + 2*(sin(x/333)+1) + 3*(sin(x/500)+1) + 3*(cos(x/300)+1) + 0.1*(cos(x/200)+1);
p.track = track'+hills;
p.slope = (p.track(2:end)-p.track(1:end-1));
p.slope(:,end+1) = p.slope(:,end);
