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
    axis([0 tracks(i).distance(end) 0 max(tracks(i).elevation)]);
    %axis([8090 8110 0 max(tracks(i).elevation)]);
    title(tracks(i).name);
    saveas(figure(i), ['./trackImages/' tracks(i).name '.jpg']);
end
close all;
