function [ output_args ] = plot_data( data,figure_id )
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here
    figure(figure_id);
    hold on;
    plot(data.ground(:,1), data.ground(:,2), 'b.');
    plot(data.median(:,1), data.median(:,2), 'rx');
    plot(data.mean(:,1), data.mean(:,2), 'gx');
    plot(data.mode(:,1), data.mode(:,2), 'kx');
    title(data.title);
    xlabel('x in cm');
    ylabel('y in cm');
    axis([min(data.ground(:,1)), max(data.ground(:,1)),min(data.ground(:,2)), max(data.ground(:,2))]);
    legend(data.title, 'median', 'mean', 'mode');
end
