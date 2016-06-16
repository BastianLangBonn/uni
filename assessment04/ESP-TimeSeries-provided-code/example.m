load('cycling1.mat');
trainSet = tdata(1:3);
testSet = tdata(4);

wMat =   [  0   -0.5   0   0.6; ...
            0    0.7   0   -0.9; ...
            0    0     0   0; ...
            0.6  0.4   0   0]; ...

[rmse,predictions,targets,inputs] = heartrate(wMat, @RNNet, tdata(1:3));

% This plots the first time series  
plot(inputs(1,:));hold on;
plot(predictions(1,:));
plot(targets(1,:));
legend('Power','Predicted Heartrate', 'Measured Heartrate');

hold off;
