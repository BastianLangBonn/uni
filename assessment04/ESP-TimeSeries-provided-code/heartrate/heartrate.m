function [rmse,output,target,input] = heartrate( wMat, activateNet, tdata)
%HEARTRATE Training data (time series): power vs heartrate
% The objective is to predict the heart rate at the next time step
%   state = [ power t     <- Power given by the training subject
%             rate  t     <- Last heart rate (to be predicted)

%% Initialization
scaling = [ 300 400 ];
activation = zeros(1,length(wMat));

%% Evaluation loop
cumulative_error = 0;
totalSteps = 0;
for experiment=1:length(tdata)
    simLength = size(tdata{experiment},1);
    totalSteps = totalSteps + simLength;
    steps = 1;
    while ( steps < simLength-1)        
        steps = steps + 1;
        state = tdata{experiment}(steps,3);
        %% Action Selection
        scaledInput = state./scaling(2);
        
        activation = feval(activateNet,wMat,[scaledInput],activation);
        
        input(experiment,steps) = state;        
        output(experiment,steps) = activation(end)*scaling(1);        
        target(experiment,steps) = tdata{experiment}(steps,2);
        cumulative_error = cumulative_error + (output(experiment,steps)-target(experiment,steps)).^2;
    end
end

rmse = sqrt(cumulative_error/totalSteps);


