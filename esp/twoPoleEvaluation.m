function [ r ] = twoPoleEvaluation( p )
%TWOPOLEEVALUATION Summary of this function goes here
%   Detailed explanation goes here
    addpath('simulator');
    r = feval('twoPole_test',...
                p.wMat,...
                @RNNet,...
                1000);
end

