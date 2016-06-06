function [ r ] = concatenateValues( p )
%CONCATENATEVALUES Summary of this function goes here
%   Detailed explanation goes here

    r.time = [];
    r.x = [];
    r.y = [];
    r.orientation = [];
    for i=1:length(p)
        r.time = [r.time p(i).time];
        r.x = [r.x p(i).x];
        r.y = [r.y p(i).y];
        r.orientation = [r.orientation p(i).orientation];
    end
end

