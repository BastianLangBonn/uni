function [ fitness ] = evaluate6Inputs( wMat, targetFitness )
%EVALUATION6INPUTS Summary of this function goes here
%   Detailed explanation goes here
    fitness = feval('twoPole_test',...
                wMat,...
                @RNNet,...
                targetFitness);

end

