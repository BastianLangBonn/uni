%% load data
clear;
filename = 'left_arc.csv';
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
plot_poses(center_positions(:,1), center_positions(:,2), theta_radians, 'Right arc: Recorded poses');
Gauss_fit(center_positions);