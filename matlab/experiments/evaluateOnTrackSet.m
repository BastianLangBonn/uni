function [ fitness ] = evaluateOnTrackSet( ind, p )
%EVALUATEONTRACKSET Summary of this function goes here
%   Detailed explanation goes here
    fitness = 0;
    if p.isTraining
        for i=1:length(p.iTrain)
            p.track = p.tracks(p.iTrain(i));
            fitness = fitness + evaluateOnTrack(ind, p);
        end
        fitness = fitness / length(p.iTrain);
    else
        for i=1:length(p.iTest)
            p.track = p.tracks(p.iTest(i));
            fitness = fitness + evaluateOnTrack(ind, p);
        end
        fitness = fitness / length(p.iTest);
    end

end

