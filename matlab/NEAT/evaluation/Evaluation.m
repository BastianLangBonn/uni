%% Evaluation - Get evaluation results from all individuals.  Wrapper with execution timer.
%
%

eval_start = tic;

if p.parallel
    parfor i=1:length(pop)
        pop(i) = getFitness(pop(i), p);
    end
else
    for i=1:length(pop)
        pop(i) = getFitness(pop(i), p);
    end
end

eval_time(gen) = toc(eval_start);