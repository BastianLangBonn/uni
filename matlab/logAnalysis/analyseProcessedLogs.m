clear;
formatSpec = '%f%C%f%f%f%f%f%f%f';
data = readtable('./processedLogs/1469449613/log.csv','Delimiter',',', ...
    'Format',formatSpec);

timeStamps = table2array(data(:,1));
timePassed = (timeStamps - timeStamps(1))/10.0;
brake = table2array(data(:,2));
activations = table2array(data(:,3));
speeds = table2array(data(:,4));
power = table2array(data(:,5));
latitudes = table2array(data(:,7));
longitudes = table2array(data(:,8));
elevation = table2array(data(:,9));




%% Get indizes where activation is too low while power is high
% These values indicate manual force application
% These should be all values smaller 4.8
iInvalidCoordinates = find(latitudes == 0);
iBrakeActivated = find(brake == 'True');
iTooSmall = find(activations < 4.7);
iPowerGiven = find(power > 0);
iInvalid = intersect(iTooSmall, iPowerGiven);
iInvalid = union(iInvalid, iBrakeActivated);
iInvalid = union(iInvalid, iInvalidCoordinates);
iValid = setdiff(1:length(timeStamps),iInvalid);

%% Create Sample Data
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

%% Create Training Data with resulting values 1 Second ahead
trainingSample = [];
for i=1:length(finalSamples)
    time = finalSamples(i,1);
    for j=i:length(finalSamples)
        if timePassed(j) == time
           slope = finalSamples(j,5) - finalSamples(i,5);
           trainingSample = [trainingSample; finalSamples(i,2) finalSamples(i,3) ...
               slope finalSamples(j,3) finalSamples(j,4)];
        end
    end
end
% activation, speed, slope, resultingSpeed, resultingPower
save('trainingSamples', 'trainingSample');
figure(1);clf;
plot(trainingSample(:,1));
figure(2);clf;
plot(trainingSample(:,2)); 
figure(3);clf;
plot(trainingSample(:,3)) 
figure(4);clf;
plot(trainingSample(:,4)); 
figure(5);clf;
plot(trainingSample(:,5));