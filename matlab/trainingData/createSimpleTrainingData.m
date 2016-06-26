%% Description
% Use simple data model to create training samples for pretraining of
% vehicle model

clear;
addpath('./../simple_model/');
%% Load tracks
tracks = dir('./simple_tracks/*.csv');

%% Simulate tracks
index = 1;
for i = 1:length(tracks)
    track = importdata(sprintf('./simple_tracks/%s',tracks(i).name), ';', 0);
    
    
    % Create training data from track
    for k = 1:20
        result = simulateTrackTime(track, 0.05 * k);
        % Only consider meaningful simulations
        if size(result.velocity,2) > 1 
          data(index) = result;
          display(index);
          index = index + 1;
        end        
    end
end


%% Save Matlab Data File
save 'simpleTrainingData.mat' data;

