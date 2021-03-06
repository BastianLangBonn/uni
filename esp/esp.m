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
maximumGenerations      = 2500;
chanceCrossover         = 0.85;
chanceMutation          = 0.1;
selectivePressure       = 2; %number of individuals competing in tournament
mutationRange           = 0.2; %sigma of gaussian perturbation
targetFitness           = 1000;

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
figure(1);clf;hold on;
%% Start Evolution Loop
generation = 1;
bestOverallNetFitness = 0;
evaluations = 0;
while generation <= maximumGenerations &&...
        bestOverallNetFitness < targetFitness
    
    bestNetFitness(generation) = 0;
    tic;
    for trial=1:nTrialsPerInd
        % Create one permutation for every subpopulation so that every 
        % individual will definetly get picked.        
        order = zeros(nNodesPerSubpopulation, nSubpopulations);
        for j = 1:nSubpopulations
            order(:,j) = randperm(nNodesPerSubpopulation);            
        end
        
        % Create one net for each individual according to order and
        % evaluate net on task.
        weightMatrix = createWeightMatrizes(...
            population, order);
        for j = 1:length(weightMatrix)
            %Evaluate network
            netFitness =...
                feval('twoPole_test',...
                weightMatrix{j},...
                @RNNet,...
                targetFitness);
            evaluations = evaluations + 1;
            
            if netFitness > bestNetFitness(generation)
                bestNetFitness(generation) = netFitness;
                bestNet = weightMatrix{j};
            end
            if bestNetFitness(generation) > bestOverallNetFitness
                bestOverallNetFitness = bestNetFitness(generation);
            end
            
            % Update fitness values of participating nodes
            for k = 1:nSubpopulations
                population(k,order(j,k)).fitness =...
                    population(k,order(j,k)).fitness + netFitness;
                population(k,order(j,k)).trials =...
                    population(k,order(j,k)).trials + 1;
            end
        end        
    end
    toc
    
    
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
        population(i,1).fitness = 0;
        population(i,1).trials = 0;

        % Perform Crossover and mutation on the rest
        for j = 2:size(mates,1)
            population(i,j) = crossover(mates(j,:), chanceCrossover);
            population(i,j) =...
                mutate(population(i,j), chanceMutation, mutationRange);
        end
    end
    plot(bestNetFitness);
    pause(0.01);
    generation = generation + 1;
    display(['Nr Evaluations: ' int2str(evaluations)]);
    display(['Best Net Fitness: ' int2str(bestOverallNetFitness)]);
end
%% Results
% Visualize median and best fitness for the nodes of every
% subpopulation
figure(1);clf;hold on;
colorSet = varycolor(4);
for i=1:nSubpopulations
    lineHandles(i) = plot(bestFitness(i,:),'-','LineWidth',2,'Color',colorSet(i,:));
    plot(medianFitness(i,:),'--','Color',get(lineHandles(i),'Color'));
    name{i} = sprintf('subpopulation %d',i);
end

legend(lineHandles,name,'Location','NorthWest')
xlabel('Generations');ylabel('Time Steps');grid on;
title('Subpopulations Fitness Progression')


% Visualize best network fitness over generations
figure(2);clf;hold on;
plot(bestNetFitness);
xlabel('Generations');ylabel('Time Steps');grid on;
title('Best Network Fitness Progression')

% Visualize network using biograph (First have to make matrix full ranked
nRows = length(bestNet);
addition = zeros(nRows, nRows - size(bestNet,2));
fullRankMatrix = [addition, bestNet];
view(biograph(fullRankMatrix));

feval('twoPole_test', bestNet,@RNNet, 1000,'vis')