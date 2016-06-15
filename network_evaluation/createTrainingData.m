clear;
addpath('./../trainingData/');
data = load('data.mat');
data = data.data;
permutation = randperm(length(data));
trainingData = data(permutation(1:50));
save trainingData 'trainingData'