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
    %% Start Evolution Loop
    generation = 1;
    bestOverallNetFitness = 0;
    while generation <= maximumGenerations &&...
            bestOverallNetFitness < targetFitness
        
        bestNetFitness(generation) = 0;
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
                %Evaluate network
                functionParameters.wMat = weightMatrix{j}.weights;
                netFitness = feval(evaluationFunction, functionParameters);

                if netFitness > bestNetFitness(generation)
                    bestNetFitness(generation) = netFitness;
                    bestNet = weightMatrix{j}.weights;
                end
                if bestNetFitness(generation) > bestOverallNetFitness
                    bestOverallNetFitness = bestNetFitness(generation);
                end
                % Update fitness values of participating nodes
                for k = 1:nSubpopulations
                    population(k,order(k,j)).fitness =...
                        population(k,order(k,j)).fitness + netFitness;
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

            [fitness, iBestFitness] = sort(fitness);
            bestFitness(i,generation) = fitness(end);
            medianFitness(i,generation) = median(fitness);

            % Select mates for this subpopulation
            mates = tournamentSelect(population(i,:), selectivePressure);

            % Elitism
            population(i,1) = population(i,iBestFitness(end));

            % Perform Crossover and mutation on the rest
            for j = 2:size(mates,1)
                population(i,j) = crossover(mates(j,:), chanceCrossover);
                population(i,j) =...
                    mutate(population(i,j), chanceMutation, mutationRange);
            end
        end
        generation = generation + 1;
    end
    result.medianNodeFitness = medianFitness;
    result.bestNodeFitness = bestFitness;
    result.bestNetFitness = bestNetFitness;
    result.bestNetwork = bestNet;
end
