function p = optimalControlParams
%% Running Params
p = NEAT_defaultParams;
activationFunctions;
p.parallel = true;
p.startPlot = 4;

%% Algorithm Hyperparameters
p.maxGen = 500;%p.startPlot-1;
p.popSize= 60;

%% Speciation
p.specType   = 'kmeans';
p.excess     = 1.0;
p.disjoint   = 1.0;
p.weightDif  = 0.5;
p.targetSpec = 3;       % for kmeans speciation
p.dropOffAge = 25;      % gens for species to not improve before dieing

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
p.fitFun = @evaluateOnTrackSet;
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
p.tracks = loadTracks();

%% Compute average time
for i=1:length(p.tracks)
    p.tracks(i).desiredTime = p.tracks(i).distance(end) / 5.5;
    [t,x,v,w, fail] = simulateTrackWithCommand(p.tracks(i), 1.0);
    p.tracks(i).maximumPower = w(end);
    if fail
       disp(p.tracks(i).name); 
    end
end

indizes = randperm(length(p.tracks));
p.iTrain = indizes(1:end-5);
p.iTest = indizes(end-4:end);
p.isTraining = true;

