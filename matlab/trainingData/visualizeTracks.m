%% Load Tracks
clear;
addpath('./../experiments');
%files = dir('./tracks/T*.csv');
tracks= loadTracks();


%% Plot Tracks
for i=1:length(tracks)
    figure(i);clf;hold on;grid on;
    plot(tracks(i).distance, tracks(i).elevation);
%     plot(extendedDistance, extendedElevation);
    xlabel('distance in m');
    ylabel('elevation in m');
    axis([0 tracks(i).distance(end) 0 80]);
    %axis([8090 8110 0 max(tracks(i).elevation)]);
    title(tracks(i).name);
    name = tracks(i).name;
    name = name(1:end-4);
    saveas(figure(i), ['./trackImages/' name '.jpg']);
    tracks(i).maxElevation = max(tracks(i).elevation);
    tracks(i).minElevation = min(tracks(i).elevation);
    tracks(i).elevationRange = tracks(i).maxElevation - ...
        tracks(i).minElevation;
    tracks(i).maxSlope = max(tracks(i).slope);
    tracks(i).minSlope = min(tracks(i).slope);
    tracks(i).trackLength = tracks(i).distance(end);
    disp(['>>>>>TRACK ' name '<<<<<<<']);
    disp(['Max Elevation: ' num2str(tracks(i).maxElevation)]);
    disp(['Min Elevation: ' num2str(tracks(i).minElevation)]);
    disp(['Range Elevation: ' num2str(tracks(i).elevationRange)]);
    disp(['Max Slope: ' num2str(tracks(i).maxSlope)]);
    disp(['Min Slope: ' num2str(tracks(i).minSlope)]);
    disp(['Track Length: ' num2str(tracks(i).trackLength)]);
end
close all;
