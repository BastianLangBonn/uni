clear;
addpath('sample_code');


nParameters(1) = 2;
nParameters(2) = 10;
nParameters(3) = 50;
evaluationFunction = 'evaluationFunction';

for experiment = 1:3
    clear bestFitness medianFitness worstFitness bestSolution worstSolution
    parameters.title = sprintf('%d Dimensions', nParameters(experiment));
    figure(experiment);clf;
    for run=1:5       
        r = cmaes(evaluationFunction, nParameters(experiment), parameters);
        bestFitness{run} = r.bestFitness;
        medianFitness{run} = r.medianFitness;
%         bestFinalFitness(run) = bestFitness{run}(end);
        worstFitness{run} = r.worstFitness;
        bestSolution(run,:) = r.bestSolution;
        worstSolution(run,:) = r.worstSolution;
        bestFinalFitness(run) = bestFitness{run}(end);
        worstFinalFitness(run) = worstFitness{run}(end);
    end
    [x iBest] = sort(bestFinalFitness);
    [x iWorst] = sort(worstFinalFitness);
    semilogy(bestFitness{iBest(1)});
    hold on;
    semilogy(medianFitness{iBest(1)});
    semilogy(worstFitness{iWorst(end)});
%     overallBestSolution{experiment} = bestSolution{iBest(1)};
    xlabel('Generations');
    ylabel('Error');
    legend('Best Fitness','Mean Fitness', 'Worst Fitness');
    title(parameters.title);
    bestSolutionFound = bestSolution(iBest(1),:)
    bestValue = bestFitness{iBest(1)}(end)
    worstSolutionfound = worstSolution(iWorst(end),:)
    worstValue = worstFitness{iWorst(end)}(end)
    
end

