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
        result = simulateTrackTime(track, 0.05 * k);
        for j = 1:length(result.velocity)-1
            % Prediction values for previous timestep 
            index = (i-1)*20+k;
            data(index).resultingVelocity(j) = result.velocity(j+1);        
            data(index).energy(j) = result.energy(j+1);
            % Input values for current time step
            data(index).command(j) = result.command(j);
            data(index).slope(j) = result.slope(j);
            data(index).time(j) = result.time(j+1) - result.time(j);
            data(index).currentVelocity(j) = result.velocity(j);
        end
    end
end

%% Create one comulated file
counter = 0;
fileId = fopen('trackData.csv','w');
fprintf(fileId,...
    sprintf('currentVelocity;passedTime;slope;command;energy;resultingVelocity\n'));
for i = 1 : length(data)
    for j = 1 : length(data(i).time)
       fprintf(fileId, sprintf('%.2f;%.2f;%.2f;%.2f;%.2f;%.2f\n',...
           data(i).currentVelocity(j),...
           data(i).time(j),...
           data(i).slope(j),...
           data(i).command(j),...
           data(i).energy(j),...
           data(i).resultingVelocity(j))); 
           counter = counter + 1;
    end
end

%% Save Matlab Data File
save 'trainingData.mat' data