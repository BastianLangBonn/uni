%% Simulate track with simple model
clear;

%% Parameters
mass = 90; % in kg. Needs to be corrected
air_density = 1.225; % in kg/m³
ftp = 150; % Not exactly sure what it is, but needed to compute wheel force
effective_frontal_area = 0.3; % unit?
rolling_resistance_coefficient = 0.005; % unit?
normal_force = mass * 9.81; % in kg*m/s²

%% Read track information
track = importdata('st_augustin_01_2_2km.csv', ';', 0);
travelled_distance = track(:,1);
elevation = track(:,2);

%% Simulate
velocity(1) = 1;
command = 0.01;
time(1) = 0;
slope(length(track)) = 0;
for index=1:length(track)-1
    slope(index) = track(index+1,2)-track(index,2);
    energy(index) = ftp*command/velocity(index) -...
        0.5*1.225*velocity(index)^2 +...
        0.005*9.81*90+...
        9.81*90*slope(index);
    time(index+1)=time(index) + 1/velocity(index);
    velocity(index+1) = velocity(index) + energy(index)/(90*velocity(index));
    
end
energy(length(track)) = ftp*command/velocity(length(track)) -...
        0.5*1.225*velocity(length(track))^2 +...
        0.005*9.81*90+...
        9.81*90*slope(length(track));
figure(1);
hold on;
% plot(travelled_distance, energy);
plot(travelled_distance, velocity);
figure(2);
plot(travelled_distance, slope);
