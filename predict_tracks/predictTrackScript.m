clear;
cmaesRun= load('trainedNetwork.mat');
parameters = cmaesRun.result;
topology = [2 3 2];
wMat = createNetworkFromParameters(parameters, topology);


track = importdata('./../trainingData/simple_tracks/Flat.csv', ';', 0);
motorCommand = 0.7;

r1 = predictTrackWithNetwork(track, wMat, motorCommand);

r2 = simulateTrackTime(track, motorCommand);

%% Result
figure(1);clf;
hold on;
subplot(2,2,1);
plot(r1.distance, r1.energy, 'bx');
plot(r2.distance, r2.energy,'r-');
title('energy used over track');
xlabel('distance in m');
ylabel('energy');

subplot(2,2,2);
plot(r1.time, r1.velocity, 'bx');
plot(r2.time, r2.velocity,'r-')
title('velocity over time');
xlabel('time in s');
ylabel('velocity in m/s');

subplot(2,2,3);
plot(r1.distance, r1.velocity, 'bx');
plot(r2.distance, r2.velocity,'r-');
title('velocity over track');
xlabel('distance in m');
ylabel('acceleration in m/s^2');

subplot(2,2,4);
plot(r1.travelledDistance, r1.elevation, 'bx');
plot(r2.travelledDistance, r2.elevation,'r-');
title('Elevation');
xlabel('travelled distance in m');
ylabel('elevation in m');



figure(2);clf;hold on;
colormap(winter);

x = r1.time; % displacement 
z = zeros(size(x)); % zero, because not used
y = r1.slope; 
col = r1.velocity;%1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('velocity over slope over time');
colorbar

figure(3);clf;hold on;
colormap(winter);

x = r2.time; % displacement 
z = zeros(size(x)); % zero, because not used
y = r2.slope; 
col = r2.velocity;%1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('velocity over slope over time');
colorbar