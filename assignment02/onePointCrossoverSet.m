function [ offspring ] = onePointCrossoverSet( matesA, matesB,...
    crossoverProbability )
%ONEPOINTCROSSOVERSET Performs one point crossover on the whole set
%   Detailed explanation goes here
    offspring = zeros(size(matesA));
    doCrossover = rand(length(matesA(:,1)),1)<crossoverProbability;
    crossoverPoints = randi(length(matesA(1,:)),length(matesA(:,1)),1);
    % probability of 0 => take mateA => crossoverPoint = last element
    crossoverPoints = length(matesA(1,:)) - (crossoverPoints.*doCrossover);
    for index = 1:length(matesA(:,1))
        offspring(index,:) = onePointCrossover(...
            matesA(index,:),...
            matesB(index,:),...
            crossoverPoints(index,1));
    end
    

end

