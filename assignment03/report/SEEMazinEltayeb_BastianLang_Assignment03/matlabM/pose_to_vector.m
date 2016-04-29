function output = pose_to_vector(x, y, theta, scale)
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here
output.X = x;
output.Y = y;
output.U = scale*cos(theta);
output.V = scale*sin(theta);
