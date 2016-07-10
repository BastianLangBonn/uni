function [ fitness, energy, power, speed, command ] = evaluateOnTrack( individual, p)
%EVALUATEONTRACK Summary of this function goes here
%   Detailed explanation goes here
    % Calculate Maximum Energy Consumption
    
    fitness = 0;
    wMat = individual.pheno.wMat;
    aMat = individual.pheno.aMat;
    track = p.track;
    slope = p.slope;
    
    energy = 0;
    speed = 0;
    command = 0;
    time = 0;
    fail = false;
    
    %State:
    % 1: time
    % 2: location
    % 3: speed
    % 4: power
    % 5: command
    % 6: slope
    
    state(1) = 0;
    state(2) = 0;
    state(3) = 1.5;
    state(4) = 0;   
   
    
    while state(2) < length(track) - 130 && ~fail
        pos = floor(state(2))+1;
        elevations = track(pos) - track(pos+[1 2 4 8 16 32 64 128]); 
        state(6) = slope(floor(state(2))+1);
        % compute desired velocity
        % Scale values
        % Use scaled values for command computation
        % Use command and state to compute state for next timestep
        
    end
    
    



end

