clear;
addpath('simulator');
%% Initialize Parameters
% Network Parameters
nInputNodes             = 6;
nHiddenNodes            = 2;
nOutputNodes            = 1;
nSubpopulations         = nHiddenNodes + nOutputNodes; %Inputs not needed
nNodesPerSubpopulation  = 10;
weightRange             = 2.5;
nIncomingConnections    = nInputNodes + nHiddenNodes + nOutputNodes + 1;
nOutgoingConnections    = nHiddenNodes + nOutputNodes;

% EA Parameters
nIndividuals            = nNodesPerSubpopulation * nSubpopulations;
nTrialsPerInd           = 20;
nTrials                 = nTrialsPerInd * nNodesPerSubpopulation;
maximumGenerations      = 250;
chanceCrossover         = 0.85;
chanceMutation          = 0.1;
selectivePressure       = 2; %number of individuals competing in tournament
mutationRange           = 0.2; %sigma of gaussian perturbation

%% Initialize Subpopulations
% Each Node will be represented by only its incoming connections. Its
% outgoing connections will be represented in other nodes as their
% incoming connections.

for trial=1:nSubpopulations
    for j=1:nNodesPerSubpopulation
        population(trial,j) = createIndividual(nIncomingConnections,...
            weightRange);
    end
end

%% Start Evolution Loop
for generation = 1:maximumGenerations    
    for trial=1:nTrialsPerInd
        % Create one permutation for every subpopulation so that every 
        % individual will definetly get picked.        
        order = zeros(nSubpopulations, nNodesPerSubpopulation);
        for j = 1:nSubpopulations
            order(j,:) = randperm(nNodesPerSubpopulation);            
        end
        
        % Create one net for each individual according to order and
        % evaluate net on task.
        weightMatrix = createWeightMatrizes(...
            population, order, nOutgoingConnections);
        for j = 1:length(weightMatrix)
            %twoPole_test( wMat, @RNNet, targetFitness);
            fitness =...
                feval('twoPole_test', weightMatrix{j}.weights,@RNNet, 1000);
            % Update fitness values of participating nodes
            for k = 1:nSubpopulations
                population(k,order(k,j)).fitness =...
                    population(k,order(k,j)).fitness + fitness;
                population(k,order(k,j)).trials =...
                    population(k,order(k,j)).trials + 1;
            end
        end        
    end
    
    % Take average fitness over trials
    for i=1:nSubpopulations
        for j=1:nNodesPerSubpopulation
            population(i,j).fitness =...
                population(i,j).fitness / population(i,j).trials;
            fitness(j) = population(i,j).fitness;
        end
        % Select mates for this subpopulation
        mates = tournamentSelect(population(i,:), selectivePressure);
        
        % Elitism
        [bestFitness, iBestFitness] = sort(fitness);
        population(i,1) = population(i,iBestFitness(end));
        
        % Perform Crossover and mutation on the rest
        for j = 2:size(mates,1)
            population(i,j) = crossover(mates(j,:), chanceCrossover);
            population(i,j) =...
                mutate(population(i,j), chanceMutation, mutationRange);
        end
    end
    
    feval('twoPole_test', weightMatrix{j}.weights,@RNNet, 1000,'vis');
    
    
    
end