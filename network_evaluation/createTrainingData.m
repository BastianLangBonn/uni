clear;
addpath('./../trainingData/');
data = load('data.mat');
data = data.data;
permutation = randperm(length(data));
trainingData = data(permutation(1:10));
testData = data(permutation(11:end));
save trainingData 'trainingData'
save testData 'testData'