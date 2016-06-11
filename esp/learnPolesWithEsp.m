clear;
addpath('simulator');
topology = [6,2,1];
evaluationFunction = 'twoPoleEvaluation';

parameters.targetFitness = 1000;
r = doEsp(topology, evaluationFunction, parameters);

figure(1);clf;hold on;
plot(r.medianNetFitness);
plot(r.bestNetFitness);

figure(2); clf; hold on;
plot(r.medianNodeFitness);
plot(r.bestNodeFitness);

feval('twoPole_test', r.bestNetwork, @RNNet, 1000, 'vis');