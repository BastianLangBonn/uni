clear;
addpath('simulator');
topology = [6,2,1];
evaluationFunction = 'twoPoleEvaluation';
permutationOption(1) = 1;
permutationOption(2) = 2;
permutationOption(3) = 1;
permutationOption(4) = 1;
permutationOption(5) = 1;
elitismOption(1) = 1;
elitismOption(2) = 1;
elitismOption(3) = 2;
elitismOption(4) = 3;
elitismOption(5) = 4; % should use no elitism at all
parameters.targetFitness = 1000;

for i=1:5
  clearvars medianNodes bestNet medianNet;
  for j=1:5
    r = doEsp(topology, permutationOption(i), elitismOption(i),...
      evaluationFunction, parameters);
    if length(r.medianNodeFitness) < 2500
      medianNodes(j,:) = ones(1,2500) * 1000;
      medianNodes(j,1:size(r.medianNodeFitness,2)) =...
          mean(r.medianNodeFitness,1);
      bestNet(j,:) = ones(1,2500) * 1000;
      bestNet(j,1:size(r.bestNetFitness,2)) = ...
          r.bestNetFitness;
      medianNet(j,:) = ones(1,2500) * 1000;
      medianNet(j,1:size(r.medianNetFitness,2)) =...
          r.medianNetFitness;
    else
      medianNodes(j,:) = mean(r.medianNodeFitness,1);
      bestNet(j,:) = r.bestNetFitness;
      medianNet(j,:) = r.medianNetFitness;
    end
  end
  meanMedianNodes(i,:) = mean(medianNodes,1);
  meanBestNet(i,:) = mean(bestNet,1);
  meanMedianNet(i,:) = mean(medianNet,1);
end

figure(1); clf; hold on;
for i=1:5  
  plot(meanMedianNodes(i,:));
end
legend('random net','all net',...
  'random nodeElitism','random both', 'random no elitism',...
  'Location','northwest');
title('Mean Median Nodes');

figure(2); clf; hold on;
for i=1:5  
  plot(meanBestNet(i,:));
end
legend('random permutation net',...
  'distributed permutation net',...
  'random node elitism',...
  'random both elitisms',...
  'random no elitism',...
  'Location','northwest');
title('Mean Best Network Fitness');

figure(3); clf; hold on;
for i=1:5  
  plot(meanMedianNet(i,:));
end
legend('random permutation net',...
  'distributed permutation net',...
  'random node elitism',...
  'random both elitisms',...
  'random no elitism',...
  'Location','northwest');
title('Mean Median Network Fitness');