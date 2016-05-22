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
            data{index}(1,j) = result.velocity(j);
            data{index}(2,j) = result.time(j+1) - result.time(j);
            data{index}(3,j) = result.slope(j);
            data{index}(4,j) = result.command(j);
            % Prediction values for previous timestep
            data{index}(5,j) = result.energy(j+1);
            data{index}(6,j) = result.velocity(j+1);            
        end
    end
end

%% Create one comulated file
counter = 0;
fileId = fopen('trackData.csv','w');
fprintf(fileId,...
    sprintf('currentVelocity;passedTime;slope;command;energy;resultingVelocity\n'));
for i = 1 : length(data)
    for j = 1 : length(data{i})
       fprintf(fileId, sprintf('%.2f;%.2f;%.2f;%.2f;%.2f;%.2f\n',...
           data{i}(1,j),...
           data{i}(2,j),...
           data{i}(3,j),...
           data{i}(4,j),...
           data{i}(5,j),...
           data{i}(6,j))); 
           counter = counter + 1;
    end
end

%% Save Matlab Data File
save 'trainingData.mat' data