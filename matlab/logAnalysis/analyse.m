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
activations = table2array(r(:,3));
speeds = table2array(r(:,4));
power = table2array(r(:,5));
latitudes = table2array(r(:,7));
longitudes = table2array(r(:,8));


figure(1);clf;
plot(speeds)
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