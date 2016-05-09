function [ offspring ] = twoPointCrossover( mateA, mateB, pointA, pointB )
%TWOPOINTCROSSOVER Summary of this function goes here
%   Detailed explanation goes here
    partA = [mateA(1:pointA),mateA(pointB+1:end)];
    % Find values in mateB that are not in partA and keep their order
    missingPart = setdiff(mateB, partA, 'stable'); 
    
    offspring = [mateA(1:pointA), missingPart, mateA(pointB+1:end)];

end

