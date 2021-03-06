function [ result ] = doEsp( evaluationFunction, parameters )
  %DOESP Input:   topology = [6,2,1] (e.g.)
  %               evaluationFunction = 'twoPole_test' (e.g)
  %               functionParameters: contains all parameters needed for the
  %               evaluation function.
  %% Network Parameters
  nInputNodes             = parameters.topology(1);
  nHiddenNodes            = parameters.topology(2);
  nOutputNodes            = parameters.topology(3);
  % Each individual will be represented as the weights of its incoming
  % connections. Because Bias and Input nodes don't have any incoming
  % connections, they do not need to be modeled as individuals and
  % therefore subpopulations in ESP.
  weightRange             = 2.5;
  nIncomingConnections    = nInputNodes + nHiddenNodes + nOutputNodes + 1;
  nOutgoingConnections    = nHiddenNodes + nOutputNodes;

  %% EA Parameters
  nIndividualsPerSubpopulation  = 10;
  nTrialsPerInd           = 20;
  maximumGenerations      = parameters.maximumGenerations;
  chanceCrossover         = 0.85;
  chanceMutation          = 0.1;
  %number of individuals competing in tournament selection
  selectivePressure       = 2;
  mutationRange           = 0.2; %sigma of gaussian perturbation
  targetFitness           = parameters.targetFitness;
  nSubpopulations         = nHiddenNodes + nOutputNodes;
  nIndividuals            = nIndividualsPerSubpopulation * nSubpopulations;
  nTrials                 = nTrialsPerInd * nIndividualsPerSubpopulation;


  %% Initialize Subpopulations
  % Each Node will be represented by only its incoming connections. Its
  % outgoing connections will be represented in other nodes as their
  % incoming connections.
  for i=1:nSubpopulations
    for j=1:nIndividualsPerSubpopulation
      population(i,j) = createIndividual(nIncomingConnections,...
        weightRange);
    end
  end
  
%   figure(1); clf; hold on;
  %% Start Evolution Loop
  generation = 1;
  currentBestFitness = 0;
  while generation <= maximumGenerations &&...
      currentBestFitness < targetFitness
%     display(['*** Generation ' int2str(generation)]);
    %% Create Random Network Combinations for Evaluation
%     tic;
    if 1 == parameters.permutationOption
%       display('Doing random permutation');
      permutations =...
        randi(nIndividualsPerSubpopulation, nTrials, nSubpopulations);
    else
%       display('Doing at least once permutation');
      permutations = zeros(nTrials, nSubpopulations);
      for trial=1:nTrialsPerInd
        % Create one permutation for every subpopulation so that every 
        % individual will definetly get picked.
        for j = 1:nSubpopulations
          index = (trial-1) * nIndividualsPerSubpopulation + 1;
          permutations(index:index + nIndividualsPerSubpopulation - 1,j) =...
            randperm(nIndividualsPerSubpopulation)';            
        end
      end
    end
    
    if parameters.elitismOption == 1 || parameters.elitismOption == 3
      % Elitism - Ensure that best network from last generation will be 
      % evaluated
      permutations(1,:) = ones(1,nSubpopulations); 
    end
    network = createWeightMatrizes(population, permutations);
%     toc
    %% Evaluate Networks
    fitness = zeros(1,nTrials);
    parfor trial=1:nTrials
%       p = functionParameters;
%       p.wMat = network{trial};
%       fitness(trial) = feval(evaluationFunction, p);
      fitness(trial) = feval(evaluationFunction, network{trial}, targetFitness);
%       fitness(trial) = feval('twoPole_test',...
%                 network{trial},...
%                 @RNNet,...
%                 targetFitness);
    end
%     toc;
    
    %% Identify Best Network
    [sortedFitness, iSortedFitness]   = sort(fitness);
    iBestRun = iSortedFitness(end);
    bestNetFitness(generation)   = fitness(iBestRun);
    medianNetFitness(generation) = median(fitness);
    

    %% Assign Fitness to Nodes
    for trial = 1:nTrials
      for subpopulation = 1:nSubpopulations
        population(subpopulation, permutations(trial,subpopulation))...
          .fitness =...
          population(subpopulation, permutations(trial,subpopulation))...
          .fitness + fitness(trial);
        population(subpopulation, permutations(trial,subpopulation))...
          .trials =...
          population(subpopulation, permutations(trial,subpopulation))...
          .trials + 1;
      end
    end
    
    %% Normalize Node Fitness Values
    nodeFitness = zeros(nSubpopulations, nIndividualsPerSubpopulation);
    for i = 1:nSubpopulations
      for j = 1:nIndividualsPerSubpopulation
        if population(i,j).trials == 0
          population(i,j).fitness = 0;
        else
          population(i,j).fitness =...
            population(i,j).fitness / population(i,j).trials;          
        end
        nodeFitness(i,j) = population(i,j).fitness;
      end
    end
    
    %% Generate Offspring
    for i=1:nSubpopulations
      % Select mates for this subpopulation
      mates = tournamentSelect(population(i,:), selectivePressure);   
      % Perform Crossover and mutation
      for j = 1:size(mates,1)
        offspring(i,j) = crossover(mates(j,:), chanceCrossover);
        offspring(i,j) =...
          mutate(offspring(i,j), chanceMutation, mutationRange);
      end
      %% Best Net Elitism
      % Keep Node that participated in best network for each subpopulation
      if parameters.elitismOption == 1 || parameters.elitismOption == 3
        offspring(i,1) = population(i,permutations(iBestRun,i));
        offspring(i,1).fitness = 0;
        offspring(i,1).trials = 0;
      end
      %% Best Nodes Elitism
      if parameters.elitismOption == 2 || parameters.elitismOption == 3
        [sortedNodeFitness iNodeFitness] = sort(nodeFitness,2);
        iBestNodes = iNodeFitness(:,end);
        for j=1:nSubpopulations
          offspring(j,2) = population(j,iBestNodes(j));
          offspring(j,2).fitness = 0;
          offspring(j,2).trials = 0;
        end
      end      
    end
    
    %% Get statistical node fitness information
    medianNodeFitness(:,generation) = median(nodeFitness,1);
    bestNodeFitness(:,generation) = max(nodeFitness,[],1);

    currentBestFitness = bestNetFitness(generation);
%     bestNet(generation,:,:) = network{iBestRun};
    population = offspring;
    generation = generation + 1;
%     plot(bestNetFitness);
%     pause(0.01);
  end
  result.medianNetFitness = medianNetFitness;
  result.bestNetFitness = bestNetFitness;
  result.medianNodeFitness = medianNodeFitness;
  result.bestNodeFitness = bestNodeFitness;
  result.bestNetwork = network{iBestRun};
end

