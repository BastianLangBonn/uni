function [ fitness ] = evaluateOnTrackSet( ind, p )
%EVALUATEONTRACKSET Summary of this function goes here
%   Detailed explanation goes here
    fitness = 0;
    for i=1:length(p.iTrain)
        p.track = p.tracks(p.iTrain(i));
        fitness = fitness + evaluateOnTrack(ind, p);
    end
    fitness = fitness / length(p.iTrain);

end

