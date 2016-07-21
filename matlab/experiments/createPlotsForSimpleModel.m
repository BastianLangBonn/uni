clear;
tracks = loadTracks();

for i=1:length(tracks)
   track = tracks(i);
   [t, x, v, w, fail] = simulateTrackWithCommand(track, 1);
   
   figure(i); clf; hold on;
   
   %% Track 
   
   plot(track.elevation);
   xlabel('Distance in m');
   ylabel('Elevation in m');
   axis([0 tracks(i).distance(end) 20 70])
   saveas(figure(i),['./figures/track',track.name,'.jpg']);
   
   
end
close all