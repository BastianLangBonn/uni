%% Initialize Parameters
clear;
tic;
% Network
nInput = 5; % [velocity, time, slope, command, bias]
nHidden = 10;
nOutput = 2; % [energy, velocity]
nNodes = nInput + nHidden + nOutput;
weightRange = 2.5;

% ESP
nSubPopulations = nNodes;
nIndividualsSubPopulation = 10;
nGenerations = 250;
nIndividuals = nSubPopulations * nIndividualsSubPopulation;
nTrialsPerIndividual = 10;
nTrials = nTrialsPerIndividual * nIndividualsSubPopulation;

%% Initialization
for i = 1:nSubPopulations
    for j = 1:nIndividualsSubPopulation
        subpopulation(i,j) = createIndividual(nNodes, weightRange);
    end
end

%% Evolution Loop
for generation = 1:nGenerations
    disp(['- Generation ' int2str(generation) ' -']);
    
    %% Evaluation
    
    % Pick one individual from each subpopulation for each trial
    groupings = randi(nIndividualsSubPopulation, nTrials, nSubPopulations);
    
    % Create networks from groupings
    for i=1:nTrials      
       for j=1:nNodes
            wmat(j,:) = subpopulation(j,groupings(i,j)).weights;
            % Set connections TO inputs to 0 
            wmat(:, 1:nInput) = 0;
       end
       network{i} = wmat;
    end
    
    % Produce Predictions and get error
    clear mse;
    parfor trial=1:nTrials
        mse(trial) = evaluate(network{trial}, nInput);
    end
    
end