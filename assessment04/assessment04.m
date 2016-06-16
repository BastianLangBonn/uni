%% Clear table
clear;

%% Initialize parameters
load('cycling1.mat');
parameters.topology = [1,3,1];
parameters.permutationOption = 1;
parameters.elitismOption = 2;
parameters.maximumGenerations = 200;
parameters.targetFitness = 1000 - (1e-3);
load('cycling1.mat');
parameters.tdata = tdata(1:3);
%% Running ESP
r = doEsp( parameters);
save r 'r';

%% Run best found network
[rmse,predictions,targets,inputs] = heartrate(r.bestNetwork, @RNNet, tdata(1:3));

%% Vizualization
% This plots the first time series 
figure(2);
plot(inputs(1,:));hold on;
plot(predictions(1,:));
plot(targets(1,:));
legend('Power','Predicted Heartrate', 'Measured Heartrate');
title('First Training Set');
hold off;

figure(3);
plot(inputs(2,:));hold on;
plot(predictions(2,:));
plot(targets(2,:));
legend('Power','Predicted Heartrate', 'Measured Heartrate');
title('Second Training Set');
hold off;

figure(4);
plot(inputs(3,:));hold on;
plot(predictions(3,:));
plot(targets(3,:));
legend('Power','Predicted Heartrate', 'Measured Heartrate');
title('Third Training Set');
hold off;

%% Run on Test Set

[rmse,predictions,targets,inputs] = heartrate(r.bestNetwork, @RNNet, tdata(1:3));

figure(5);
plot(inputs(1,:));hold on;
plot(predictions(1,:));
plot(targets(1,:));
legend('Power','Predicted Heartrate', 'Measured Heartrate');
title('Test Set');
hold off;




