function [ output_args ] = plot_poses( x, y, theta, name )
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here
    %figure(figure_id);
    hold on;
    scale = 0.5
    vectors = pose_to_vector(x, y, theta + pi/2, scale);
    quiver(vectors.X, vectors.Y, vectors.U, vectors.V, 'b');
    meanV = pose_to_vector(mean(x), mean(y), mean(theta) + pi/2, scale);
    quiver(meanV.X, meanV.Y, meanV.U, meanV.V, 'g');
    medianV = pose_to_vector(median(x), median(y), median(theta) + pi/2, scale);
    quiver(medianV.X, medianV.Y, medianV.U, medianV.V, 'r');
    %plot(poses.ground(:,1), poses.ground(:,2), 'b.');
    %plot(poses.median(:,1), poses.median(:,2), 'rx');
    %plot(poses.mean(:,1), poses.mean(:,2), 'gx');
    %plot(poses.mode(:,1), poses.mode(:,2), 'kx');
    title(name);
    xlabel('x in cm');
    ylabel('y in cm');
    %axis([min(x), max(x),min(y), max(x)]);
    legend('pose', 'mean', 'median');
end

