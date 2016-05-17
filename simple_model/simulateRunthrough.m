%% Simulate track with simple model
clear;



%% Read track information
track = importdata('Hill.csv', ';', 0);
%track = importdata('./tracks/Ex3.csv', ';', 0);

%% Simulate
command = 0.05;
result = simulateTrack(track, command);
    

%% Result
figure(1);clf;
hold on;
subplot(2,2,1);
plot(result.travelledDistance, result.energy);
title('energy used');
xlabel('travelled distance in m');
ylabel('energy');

subplot(2,2,2);
plot(result.travelledDistance, result.velocity);
title('velocity over time');
xlabel('travelled distance in m');
ylabel('velocity in m/s');

subplot(2,2,3);
plot(result.travelledDistance, result.slope);
title('slope over time');
xlabel('travelled distance in m');
ylabel('slope');

subplot(2,2,4);
plot(result.travelledDistance, result.elevation);
title('Elevation');
xlabel('travelled distance in m');
ylabel('elevation');



figure(2);clf;hold on;
colormap(winter);

x = result.travelledDistance'; % displacement 
z = zeros(size(x)); % zero, because not used
y = result.elevation'; %Elevation
col = result.energy;%1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('energy usage based on elevation over time');
colorbar

figure(3);clf;hold on;
colormap(winter);

x = result.travelledDistance'; % displacement 
z = zeros(size(x)); % zero, because not used
y = result.elevation'; %Elevation
col = result.velocity;%1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('Velocity usage based on elevation over time');
colorbar

figure(4);clf;hold on;
plot(result.travelledDistance, result.elevation);
plot(result.travelledDistance, result.velocity);
plot(result.travelledDistance, result.energy);
legend('elevation', 'velocity', 'energy');

figure(5);clf;hold on;
plot(result.time, result.energy);
%% Acceleration
% 