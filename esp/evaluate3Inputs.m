function [ fitness ] = evaluate3Inputs( wMat, targetFitness )
%EVALUATE6INPUTS Summary of this function goes here
%   Detailed explanation goes here
    fitness = feval('twoPole_test',...
                wMat,...
                @RNNet2,...
                targetFitness);

end

