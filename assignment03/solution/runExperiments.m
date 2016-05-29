%% Initialize Parameters
clear;
evaluationFunction = 'evaluateNacaShape';
p(1).nacaNumber = [0,0,1,2];
name{1} = 'NACA 0012';
p(2).nacaNumber = [5,5,2,2];
name{2} = 'NACA 5522';
p(3).nacaNumber = [9,7,3,5];
name{3} = '9735';

%% Run Experiments
for experiment = 1:3
   clear bestFitness medianFitness bestSolution;
   parfor run = 1:1
      fprintf('Performing exp %d, run %d\n',experiment, run);
      r(run) = cmaes(evaluationFunction, 32, p(experiment));
      bestFitness(run,:) = r(run).bestFitness;
      meanFitness(run,:) = r(run).meanFitness;
      bestSolution(:,run) = r(run).bestSolution;
      
   end
   p(experiment).meanBestFitness = mean(bestFitness,1);
   p(experiment).meanMeanFitness = mean(meanFitness,1);
   [fitness, index] = sort(bestFitness(:,end),1);
   p(experiment).bestSolution = bestSolution(:,index(1));
end

%% Showing Results
figure(1); clf; hold on;
colorSet = varycolor(4);
for i=1:3
    lineHandles(i) = plot(p(i).meanBestFitness,'-','LineWidth',2,'Color',colorSet(i,:));
    plot(p(i).meanMeanFitness,'--','Color',get(lineHandles(i),'Color'));
end
legend(lineHandles,name,'Location','NorthWest')
xlabel('Function Evaluations');ylabel('Mean Square Error');grid on;
%set(gca,'XLim',[0 2500]); 
title('Parameter Effects')


nEvaluationPoints = 256; 

for i=1:3
    nacaNumber = p(i).nacaNumber;
    nacafoil= create_naca(nacaNumber,nEvaluationPoints);
    figure(i+1);
    [foil, nurbs] = pts2ind(p(i).bestSolution,nEvaluationPoints);
    plot(nacafoil(1,:),nacafoil(2,:), 'LineWidth', 3);
    hold on;
    plot(foil(1,:),foil(2,:), 'r', 'LineWidth', 3);
    plot(nurbs.coefs(1,1:end/2),nurbs.coefs(2,1:end/2),'rx', 'LineWidth', 3);
    axis equal;
    axis([0 1 -0.7 0.7]);
    legend('Target Shape', 'Approximated Shape');
    ax = gca;
    ax.FontSize = 24;
    drawnow;
    title(name{i});
    hold off;
end