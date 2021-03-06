clear;
%% Parameter Settings
%% Baseline Parameters
p(1).population_size = 18;
p(1).number_of_genes = 100;
p(1).crossover_probability = 0.9;
p(1).mutation_probability = 1/p(1).number_of_genes;
p(1).maximum_generations = 150;
name{1} = 'baseline';

%% Triple Population
p(2) = p(1);
p(2).population_size = p(2).population_size * 3;
p(2).maximum_generations = p(2).maximum_generations /3;
name{2} = 'Triple Population';

%% Triple Mutation
p(3) = p(1);
p(3).mutation_probability = p(3).mutation_probability * 3;
name{3} = 'Triple Mutation';

%% One Third Mutation
p(4) = p(1);
p(4).mutation_probability = p(4).mutation_probability / 3;
name{4} = 'One Third Mutation';

%% Triple Generations
p(5) = p(1);
p(5).maximum_generations = p(5).maximum_generations * 3;
p(5).population_size = p(5).population_size /3; % To account for more generations
name{5} = 'Triple Generations';


%% Experiments
tic; %Start a timer
for experiment=1:5
    clear best_fitness median_fitness
    parfor run=1:100
        [best_fitness(run,:), median_fitness(run,:)] = one_max(p(experiment));
    end
    p(experiment).median_best_fitness = median(best_fitness,1);
    p(experiment).median_median_fitness = median(median_fitness,1);
end
toc; %End a timer

%% Showing Results
figure(1); clf; hold on;
for experiment=1:5
    fitness_evaluations = [p(experiment).population_size: p(experiment).population_size : p(experiment).population_size*p(experiment).maximum_generations];
    line_handles(experiment) = plot(fitness_evaluations, p(experiment).median_best_fitness,'-','LineWidth',2);
    plot(fitness_evaluations, p(experiment).median_median_fitness,'--','Color',get(line_handles(experiment),'Color'))
end

legend(line_handles,name,'Location','NorthWest')
xlabel('Function Evaluations');ylabel('Fitness');grid on;
set(gca,'XLim',[0 2500]); title('Parameter Effects')

%% Conclusion
% In the end using one third mutation rate results in the best performance,
% but does not converge as fast as most others.
% Tripling the population resulted in much slower convergence and the
% resulting fitness is still below the baseline and the one third mutation.
% The triple mutation stops improving at slightly above 80 fitness while
% converging about as fast as the baseline. 
% The triple generations does not improve much after reaching 90 fitness,
% but has the fastest convergence rate.
% A mixture of both more generations with repect to population size and a
% high, but decreasing mutation rate over time might be best.
