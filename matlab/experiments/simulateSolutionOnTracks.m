function [] = simulateSolutionOnTracks(ind, p)


for i=1:length(p.tracks)        
    p.track = p.tracks(i);
    [fitness{i}, time{i}, location{i}, speed{i}...
      , energy{i}, command{i}] = evaluateOnTrack(ind, p);
    figure(i); clf;
    subplot(2,2,1);
    plot(command{i});
    title('Command over time');
    xlabel('Command');
    ylabel('Time in s');

    subplot(2,2,2);
    plot(speed{i});
    title('Velocity over time');
    xlabel('Velocity in m/s');
    ylabel('Time in s');
  
    subplot(2,2,3);
    plot(energy{i});
    title('Energy Usage over time');
    xlabel('Energy Usage in Watt');
    ylabel('Time in s');
    
    subplot(2,2,4);
    plot(p.track.elevation);
    title('Track Heightprofile');
    xlabel('Distance in m');
    ylabel('Elevation in m');
    axis([0 p.track.distance(end) 0 70]);

end