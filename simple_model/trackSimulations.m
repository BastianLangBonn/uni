%% Track Simulations
clear;
% Read track information
track = importdata('test1.csv', ';', 0);
travelledDistance = track(:,1);
elevation = track(:,2);

% Plot Hight Profile
figure(1);clf;hold on;
plot(travelledDistance, elevation);
xlabel('Travelled Distance');
ylabel('Elevation');
title('Track Hight Profile');


% Simulate
r = simulateTrack(track);

figure(2);clf;hold on;
colormap(summer);

x = travelledDistance'; % displacement 
z = zeros(size(x)); % zero, because not used
y = elevation'; %Elevation
col = 1:length(x);  % This is the color, vary with x in this case., for instance velocity
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',6);
title('Power Used on Track')


% figure(2);clf;hold on;
% plot(r.time, r.velocity);
% 
% figure(3);clf;hold on;
% plot(travelledDistance, r.velocity);

