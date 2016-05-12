function [ distance ] = computeCrowdingDistance( p )
%COMPUTECROWDINGDISTANCE Computes the crowding distance for a population
%   Given a population and its values for leadingZeros and trailingOnes,
%   this function computes its crowding distance
    nPopulation = size(p.population, 1);
    distance = zeros(nPopulation, 1);
    
    fitness = computeFitness(p.population, p.values, p.weights);
    
    
    
   distance = computeDistanceAccordingGoal(distance, fitness.value);
   distance = computeDistanceAccordingGoal(distance, fitness.weight);
    
   
    
end

function [distance] = computeDistanceAccordingGoal(distance, values)
%COMPUTEDISTANCEACCORDINGGOAL Computes the distance for one goal
    % Sort distance according to goal values
    [sorted, index] = sort(values);
    distance = distance(index);
    
    % Set first and last value to inf
    distance(1) = Inf;
    distance(end) = Inf;
    
    % Create reverse permutation index
    unsorted = 1:length(values);
    reverseIndex(index) = unsorted;
    
    for i=2:length(values)-1
        % Compute distance values w.r.t. sorted list
        distance(i) = distance(i) + ((sorted(i+1) - sorted(i-1))/...
            (max(sorted) - min(sorted)));
    end
    
    % Restore original ordering
    distance = distance(reverseIndex);
end

