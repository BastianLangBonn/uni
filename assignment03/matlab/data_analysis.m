%% load data
clear;
filename = 'forward.csv';
delimiter = ',';
header_lines = 1;
items = importdata(filename, delimiter, header_lines);

index = items.data(:,1);
left_wheel_positions = items.data(:,2:3);
right_wheel_positions = items.data(:,4:5);
center_positions = items.data(:,9:10);
theta_radians = items.data(:,11);
theta_degrees = items.data(:,12);


%% Data analysis
% Left Wheel Position
left_wheel_data = compute_statistical_data(left_wheel_positions);

% Right Wheel Position
right_wheel_data = compute_statistical_data(right_wheel_positions);

% Center Position
center_data = compute_statistical_data(center_positions);

% Theta
theta_radians_data = compute_statistical_data(theta_radians);

theta_degrees_data = compute_statistical_data(theta_degrees);

% Combined movement
complete_data = compute_statistical_data([left_wheel_positions; right_wheel_positions; center_positions]);

%% Data Visualization
% left wheel
left_wheel_data.title = 'Left Wheel Positions';
plot_data(left_wheel_data, 1);

% right wheel
right_wheel_data.title = 'Right Wheel Positions';
plot_data(right_wheel_data, 2);

% center

center_data.title = 'Center of Motion Positions';
plot_data(center_data, 3);
boxplot(center_data.ground(:,2));

% theta
number_of_bins = 20;
theta_radians_data.title = 'Theta in radians';
hist_data(theta_radians_data, number_of_bins, 4);

theta_degrees_data.title = 'Theta in degrees';
hist_data(theta_degrees_data, number_of_bins, 5);

% All movement in one
complete_data.median = [left_wheel_data.median;right_wheel_data.median;center_data.median];
complete_data.mode = [left_wheel_data.mode;right_wheel_data.mode;center_data.mode];
complete_data.mean = [left_wheel_data.mean;right_wheel_data.mean;center_data.mean];

figure(6);
hold on;
plot(complete_data.ground(:,1), complete_data.ground(:,2), 'b.');
plot(complete_data.median(:,1), complete_data.median(:,2), 'rx');
plot(complete_data.mean(:,1), complete_data.mean(:,2), 'gx');
plot(complete_data.mode(:,1), complete_data.mode(:,2), 'kx');
plot(-24.7/2, 0, 'bo');
title('Complete Movement');
xlabel('x in cm');
ylabel('y in cm');
axis([min(complete_data.ground(:,1))-1, max(complete_data.ground(:,1))+1,0, max(complete_data.ground(:,2))+1]);
legend('Complete Movement', 'median', 'mean', 'mode', 'start','Location','SouthEast');


