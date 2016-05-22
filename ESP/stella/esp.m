%% Neuroevolution with Enforced Subpopulations
%
%  Sweat for Science model fitting
%
%% Parallelization

%matlabpool

%% Import Data
clearvars;
tic;
load trainingData.mat; %I cleaned this up a bit, started at 5s and removed negative velocities

%% Set Algorithm Parameters

% Topology Parameters
num_inputs  = 2; % [velocity, bias] WARNING: if this is changed be sure to change network creation below
num_outputs = 1;
num_hidden  = 5;
num_nodes   = num_inputs + num_outputs + num_hidden;
num_subpops = num_nodes;
weight_range= 2.5;

% EA Parameters
num_indPerSubpop    = 10;
num_ind             = num_indPerSubpop * num_subpops;
num_trialsPerInd    = 20;
num_trials          = num_trialsPerInd * num_indPerSubpop;
num_gens            = 250;
chance_crossover    = 0.85;
chance_mutation     = 0.1;
selection_pressure  = 2; %number of individuals competing in tournament
mut_range           = 0.2; %sigma of gaussian perturbation

%% Initialize Individuals
for i=1:num_subpops
    for j=1:num_indPerSubpop
        subpop(i,j) = spawnInd(num_nodes, weight_range);
    end
end

%% Control Loop
for gen=1:num_gens
    display(['*** Generation ' int2str(gen)]);

    %% Evaluate Combinations of Subpops

    % Create groupings
    groupings = randi(num_indPerSubpop, num_trials, num_subpops);    

    % Create networks from groupings
    for i=1:num_trials      
       for j=1:num_nodes
            wmat(j,:) = subpop(j,groupings(i,j)).weights;
            % Set connections TO inputs to 0
            wmat(:,[end, end-1]) = 0; % MAGIC numbers for just two inputs          
       end
       network{i} = wmat;
    end

    % Produce Predictions and get error
    clear mse;
    parfor trial=1:num_trials
    %for trial=1:num_trials
        mse(trial) = evaluate(network{trial}, num_inputs, tdata);
        %mse(trial) = evaluate(network{trial}, num_inputs, test);
    end

    % Assign individual fitness
    for trial=1:num_trials
        for node=1:num_subpops
            subpop(node,groupings(trial,node)).fitness = subpop(node,groupings(trial,node)).fitness + mse(trial);
            subpop(node,groupings(trial,node)).trials = subpop(node,groupings(trial,node)).trials + 1;
        end
    end
    
    % Normalize individual fitness by number of trials
    for ind = 1:num_ind
        if subpop(ind).trials ~= 0
            subpop(ind).fitness = subpop(ind).fitness / subpop(ind).trials;
        else
            subpop(ind).fitness = 1e10; % handle this better ;)
        end
        fit(ind) = subpop(ind).fitness;
    end
    
    %% Gather Data and Plot Results
    record.best_ensemble_fitness(gen)   = min(mse);
    record.best_network{gen}            = network{find(mse == min(mse))};       
    record.individual_fitness(:,gen)    = fit;
    

    %% Selection & Recombination

    for node=1:num_subpops
        % Elitism
        for individuals=1:num_indPerSubpop
            fitnesses(individuals) = subpop(node,individuals).fitness;
        end
        new_pop(1) = subpop(node, find(fitnesses == min(fitnesses),1) );
        record.elite(node,gen) = new_pop(1).fitness;
        new_pop(1).trials = 0;
        new_pop(1).fitness= 1e10;

        % Fill the rest of the population with offspring
        for i=2:num_indPerSubpop
            % Tournament Selection
            parent_a = selectParent(subpop(node,:), selection_pressure);
            parent_b = selectParent(subpop(node,:), selection_pressure);
            while parent_a == parent_b
                parent_b = selectParent(subpop(node,:), selection_pressure);
            end
                        
            % Recombination
            new_pop(i) = recombine(subpop(node,parent_a), subpop(node,parent_b), chance_crossover, chance_mutation, mut_range);              
        end
        
        subpop(node,:) = new_pop;
    end

end
runtime = toc;

figure(1)
subplot(2,1,1)
plot(record.best_ensemble_fitness([50:end])); %skipping the first few genrations -- they are basically random and screw up the graph scaling
title('Best Network Fitness');
subplot(2,1,2);
plot(record.elite(:,[50:end])')
title('Best Node Fitness');

best_gen = find(record.best_ensemble_fitness == min(record.best_ensemble_fitness));
%[mse, predict] = evaluate(record.best_network{best_gen}, num_inputs, test2);
[mse, predict] = evaluate(record.best_network{best_gen}, num_inputs, tdata);
display(['Best network found at generation ' int2str(gen) ' with average MSE: ' num2str(mse)]);
figure(3)
for i=1:12
   subplot(4,3,i)
    plot(predict{i},'g'); hold on;
    %plot(test{i}(:,2), 'b') 
    plot(tdata{i}(:,2), 'b') 
end

display(['Time for optimization: ' num2str(runtime) 's.' ]);
display(['Number of Connections: ' int2str(length(find(x ~= 0)))]);