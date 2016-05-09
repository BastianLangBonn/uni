function [ offspring ] = twoPointCrossoverSet( matesA, matesB,...
    crossoverProbability)
%TWOPOINTCROSSOVERSET Summary of this function goes here
%   Detailed explanation goes here
    offspring = zeros(size(matesA));
    doCrossover = rand(length(matesA(:,1)),1)<crossoverProbability;
    genomeLength = length(matesA(1,:));
    for index = 1:length(matesA(:,1))
        if doCrossover(index,1)
            crossoverPointA = randi([0, genomeLength-2]);
            crossoverPointB = randi([crossoverPointA+1, genomeLength-1]);
            offspring(index,:) = twoPointCrossover(...
                matesA(index,:),...
                matesB(index,:),...
                crossoverPointA,...
                crossoverPointB);
        else
            offspring(index,:) = matesA(index,:);
        end
    end

end

