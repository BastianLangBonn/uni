function [ result ] = doEsp( topology,...
  evaluationFunction,...
  functionParameters )
  %DOESP Input:   topology = [6,2,1] (e.g.)
  %               evaluationFunction = 'twoPole_test' (e.g)
  %               functionParameters: contains all parameters needed for the
  %               evaluation function.
  %% Network Parameters
  nInputNodes             = topology(1);
  nHiddenNodes            = topology(2);
  nOutputNodes            = topology(3);
  % Each individual will be represented as the weights of its incoming
  % connections. Because Bias and Input nodes don't have any incoming
  % connections, they do not need to be modeled as individuals and
  % therefore subpopulations in ESP.
  weightRange             = 2.5;
  nIncomingConnections    =nInputNodes + nHiddenNodes + nOutputNodes + 1;
  nOutgoingConnections    = nHiddenNodes + nOutputNodes;

  %% EA Parameters
  nNodesPerSubpopulation  = 10;
  nTrialsPerInd           = 20;
  maximumGenerations      = 2500;
  chanceCrossover         = 0.85;
  chanceMutation          = 0.1;
  %number of individuals competing in tournament selection
  selectivePressure       = 2;
  mutationRange           = 0.2; %sigma of gaussian perturbation
  targetFitness           = 1000;
  nSubpopulations         = nHiddenNodes + nOutputNodes;
  nIndividuals            = nNodesPerSubpopulation * nSubpopulations;
  nTrials                 = nTrialsPerInd * nNodesPerSubpopulation;


  %% Initialize Subpopulations
  % Each Node will be represented by only its incoming connections. Its
  % outgoing connections will be represented in other nodes as their
  % incoming connections.
  for i=1:nSubpopulations
    for j=1:nNodesPerSubpopulation
      population(i,j) = createIndividual(nIncomingConnections,...
        weightRange);
    end
  end
  
  figure(1); clf; hold on;
  %% Start Evolution Loop
  generation = 1;
  currentBestFitness = 0;
  while generation <= maximumGenerations &&...
      currentBestFitness < targetFitness
    %% Create Random Network Combinations for Evaluation
    permutations =...
      randi(nNodesPerSubpopulation, nTrials, nSubpopulations);
    % Elitism - Ensure that best network from last generation will be 
    % evaluated
    permutations(1,:) = ones(1,nSubpopulations); 
    weightMatrizes = createWeightMatrizes(population, permutations);

    %% Evaluate Networks
    fitness = zeros(1,nTrials);
    parfor trial=1:nTrials
      p = functionParameters;
      p.wMat = weightMatrizes{trial};
      fitness(trial) = feval(evaluationFunction, p);
    end
    
    %% Identify Best Network
    [fitness, iSortedFitness]   = sort(fitness);
    bestNetFitness(generation)   = fitness(end);
    medianNetFitness(generation) = median(fitness);
    iBestRun = iSortedFitness(end);

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
    for i = 1:nSubpopulations
      for j = 1:nNodesPerSubpopulation
        if population(i,j).trials == 0
          population(i,j).fitness = 0;
        else
          population(i,j).fitness =...
            population(i,j).fitness / population(i,j).trials;          
        end
        nodeFitness(i,j) = population(i,j).fitness;
      end
      
      % Select mates for this subpopulation
      mates = tournamentSelect(population(i,:), selectivePressure);
      
      % Elitism
      % Keep Node that participated in best network for each subpopulation
      population(i,1) = population(i,permutations(iBestRun,i));
      population(i,1).trials = 0;
      population(i,1).fitness = 0;

      % Perform Crossover and mutation on the rest
      for j = 2:size(mates,1)
        population(i,j) = crossover(mates(j,:), chanceCrossover);
        population(i,j) =...
          mutate(population(i,j), chanceMutation, mutationRange);
        population(i,j).trials = 0;
        population(i,j).fitness = 0;
      end
    end
    
    %% Get statistical node fitness information
    medianNodeFitness(:,generation) = median(nodeFitness,1);
    bestNodeFitness(:,generation) = max(nodeFitness,[],1);

    currentBestFitness = bestNetFitness(generation);
    bestNet(generation,:,:) = weightMatrizes{iBestRun};
    generation = generation + 1;
    plot(bestNetFitness);
    pause(0.01);
  end
  result.medianNetFitness = medianNetFitness;
  result.bestNetFitness = bestNetFitness;
  result.medianNodeFitness = medianNodeFitness;
  result.bestNodeFitness = bestNodeFitness;
  result.bestNetwork = weightMatrizes{iBestRun};
end

