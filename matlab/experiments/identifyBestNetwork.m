clear;
addpath('./../ANN');
directories = dir('./2016*T*');
for i=1:length(directories)
    regex = strcat('./',directories(i).name, '/', 'fitness*');
    files = dir(regex);  
    for j=1:length(files)
        clearvars trainFitness testFitness overallFitness
        data = importdata(strcat('./',directories(i).name, '/', files(j).name),',');
        trainFitness(j,:) = data(1,:);
        testFitness(j,:) = data(2,:);
        overallFitness(j,:) = testFitness(j,:);% + trainFitness(j,:);
        [maxRunFitness(j),iMaxRunFitness(j)] = max(overallFitness(j,:), [], 2);
    end
    [maxExperimentFitness(i), iMaxExperimentFitness(i)] = ...
        max(maxRunFitness);
    
end

% Now maxExperimentFitness holds the best fitness for every experiment
% Identify max of them
[overallMaxFitness, iOverallMaxFitness] = max(maxExperimentFitness);
bestExperiment = directories(iOverallMaxFitness).name;
bestRun = iMaxExperimentFitness(iOverallMaxFitness);

% Mixup while saving matrixes ...
wMat = importdata(strcat('./', bestExperiment, '/aMat', num2str(bestRun), '.csv'),',');
aMat = importdata(strcat('./', bestExperiment, '/wMat', num2str(bestRun), '.csv'),',');

ind.pheno.wMat = wMat;
ind.pheno.aMat = aMat;
var = load(strcat('./', bestExperiment, '/vars' , num2str(bestRun), '.mat'));

simulateSolutionOnTracks(ind, var.p);