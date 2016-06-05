%% Description
% Use simple data model to create training samples for pretraining of
% vehicle model

clear;
%% Load tracks
tracks = dir('./tracks/*.csv');

%% Simulate tracks
for i = 1:length(tracks)
    disp(['*** Track ' int2str(i)]);
    track = importdata(sprintf('./tracks/%s',tracks(i).name), ';', 0);
    
    
    % Create training data from track
    for k = 1:20
        disp(['***** Command ' num2str(0.05 * k)]);
        result = simulateTrackTime(track, 0.05 * k);
        for j = 1:length(result.velocity)-1             
            index = (i-1)*20+k;            
            % Input values for current time step
            data(index).velocity(j) = result.velocity(j);
            data(index).time(j) = result.time(j+1) - result.time(j);
            data(index).slope(j) = result.slope(j);
            data(index).command(j) = result.command(j);
            % Prediction values for previous timestep
            data(index).energy(j) = result.energy(j+1);
            data(index).resultingVelocity(j) = result.velocity(j+1);            
        end
    end
end

%% Save Matlab Data File
save 'trainingData.mat' data