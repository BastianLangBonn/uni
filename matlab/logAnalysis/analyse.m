clear;

files = dir('./logs/1469449613/data*');
for i=1:length(files)
   names{length(files)-i+1} = files(i).name; 
end
sort(names);
formatSpec = '%f%C%f%f%f%f%f%f%f';
index = 1;
for i=1:length(names)
    data = readtable(['./logs/1469449613/' names{i}],'Delimiter',',', ...
    'Format',formatSpec);
    for j=size(data,1):-1:1
        r(index,:) = data(1,:);
        index = index + 1;
    end
    %data = importdata(['./logs/1469445428/' name], ',')
end

timeStamps = table2array(r(:,1));
timePassed = (timeStamps - timeStamps(1))/10.0;
activations = table2array(r(:,3));
speeds = table2array(r(:,4));
power = table2array(r(:,5));
latitudes = table2array(r(:,7));
longitudes = table2array(r(:,8));
elevation = table2array(r(:,9));

%% Get indizes where activation is too low while power is high
% These values indicate manual force application
% These should be all values smaller 4.8
iTooSmall = find(activations < 4.7);
iPowerGiven = find(power > 0);
iInvalid = intersect(iTooSmall, iPowerGiven);
iValid = setdiff(1:length(timeStamps),iInvalid);

samples = [timePassed(iValid,:) activations(iValid,:)...
    speeds(iValid,:) power(iValid,:) elevation(iValid,:)];

%% Remove duplicate timestep entries
% Ignore all timesteps that already exist
timestamp = -1;
counter = 1;
for i=1:length(samples)
   if samples(i,1) ~= timestamp
       timestamp = samples(i,1);
       finalSamples(counter,:) = samples(i,:);
       counter = counter + 1;
   end
end


figure(1);clf;
plot(timePassed, speeds)
title('speed over time')
xlabel('s');
ylabel('km/h');
figure(2);clf;
plot(activations)
figure(3);clf;
plot(power)
figure(4); clf; 
plot(latitudes)
axis([0 length(latitudes) 50.7 50.8])
figure(5); clf;
plot(longitudes)
axis([0 length(longitudes) 7.15 7.2])
figure(6); clf;
plot(elevation)
axis([0 length(elevation) 55 63])

fileId = fopen('./test.csv','w');
for i=1:length(longitudes)
    if ~latitudes(i) && longitudes(i)
        fprintf(fileId,'%s, %s\n', latitudes(i), longitudes(i));
    end    
end