%% Example call to the Rastrigin function (2D example)
% Evolutionary Computation: Theory and Praxis (ECTA)
% BRSU: Bonn-Rhein-Sieg University of Applied Sciences
% Alexander Hagg
num_samples = 10000;
dimensions = 2;

% I prefer a Latin Hypercube sampling but this is only an example
input = 12 * lhsdesign(num_samples,dimensions) - 6;
output = rastr(input);

plot3(input(:,1),input(:,2),output,'x');
hold on;
title('2D Rastrigin Function');
ax = gca;
ax.XLabel.String = 'X';
ax.YLabel.String = 'Y';
ax.ZLabel.String = 'f(X,Y)';

ax.FontSize = 24

