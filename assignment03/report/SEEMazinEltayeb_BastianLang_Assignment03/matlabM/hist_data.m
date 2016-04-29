function [ output_args ] = hist_data( data, number_of_bins, figure_id )
%HIST_DATA Summary of this function goes here
%   Detailed explanation goes here
    figure(figure_id);
    hold on;
    histogram(data.ground, number_of_bins);
    plot([data.mean, data.mean],ylim,'r--','LineWidth',2);
    plot([data.mode, data.mode],ylim,'g--','LineWidth',2);
    plot([data.median, data.median], ylim,'k--','LineWidth',2);
    title(data.title);
    range([min(data.ground), max(data.ground)]);
    legend(data.title, 'mean', 'mode','median');
end

