%% Simulate track with simple model
clear;



%% Read track information
track = importdata('Hill.csv', ';', 0);
%track = importdata('./tracks/Ex3.csv', ';', 0);

%% Simulate
command = 0.05;
result = simulateTrackTime(track, command);
    

%% Result
figure(1);clf;
hold on;
subplot(2,2,1);
plot(result.distance, result.energy);
title('energy used over track');
xlabel('distance in m');
ylabel('energy');

subplot(2,2,2);
plot(result.time, result.velocity);
title('velocity over time');
xlabel('time in m');
ylabel('velocity in m/s');

subplot(2,2,3);
plot(result.distance, result.velocity);
title('velocity over track');
xlabel('distance in m');
ylabel('acceleration in m/s^2');

subplot(2,2,4);
plot(result.travelledDistance, result.elevation);
title('Elevation');
xlabel('travelled distance in m');
ylabel('elevation in m');



figure(2);clf;hold on;
colormap(winter);

x = result.time; % displacement 
z = zeros(size(x)); % zero, because not used
y = result.slope; 
col = result.velocity;%1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('velocity over slope over time');
colorbar

