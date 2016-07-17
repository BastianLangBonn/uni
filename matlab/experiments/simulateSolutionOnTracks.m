clear;
folder = './20160716T202428';
files = dir(strcat(folder, '/*.mat'));

for i=1:1%length(files)
   name = files(i).name; 
   var = load(strcat(folder, './', name));
   for track = 1:length(var.p.tracks)
       var.p.track = var.p.tracks(track);
       
      [fitness{track}, time{track}, location{track}, speed{track}...
          , energy{track}, command{track}] = evaluateOnTrack(var.elite(end), var.p);
      figure(track); clf;
      subplot(2,2,1);
      plot(command{track});
      subplot(2,2,2);
      plot(speed{track});
      subplot(2,2,3);
      semilogy(energy{track});
   end
end