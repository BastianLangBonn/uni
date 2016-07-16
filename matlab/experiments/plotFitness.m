clear;
trackFiles = dir('./fitness*.csv');

for i=1:length(trackFiles)
   figure(i);clf;hold on;
   name = trackFiles(i).name; 
   fitness = importdata(name);
   for j=1:size(fitness,1)
      plot(fitness(j,:)); 
   end
end
