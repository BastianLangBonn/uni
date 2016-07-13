function [ fitness, time, location, speed, energy, command ] = evaluateOnTrack( individual, p)
%EVALUATEONTRACK Summary of this function goes here
%   Detailed explanation goes here
    % Calculate Maximum Energy Consumption
    
    fitness = 0;
    wMat = individual.pheno.wMat;
    aMat = individual.pheno.aMat;
    track = p.track;
    slope = p.track.slope;
    desiredTime = p.track.desiredTime;
    
    energy = 0;
    location = 0;
    speed = 0.15;
    command = 0;
    time = 0;
    fail = false;
    
    %State:
    % 1: time
    % 2: location
    % 3: speed
    % 4: energy
    % 5: command
    % 6: slope
    
    state(1) = time;
    state(2) = location;
    state(3) = speed;
    state(4) = energy;   
   
    
    while state(2) < track.distance(end) - 130 && ~fail
        pos = floor(state(2))+1;
        elevations = track.elevation(pos) - track.elevation(pos+[1 2 4 8 16 32 64 128]); 
        state(6) = slope(pos);
        
        % compute desired velocity
        timeLeft = desiredTime - state(1);
        distanceRemaining = length(track) - state(2);
        desiredVelocity = distanceRemaining / timeLeft;
        
        % Scale values
        % Assuming 14m/s as upper boundary for speed (~50km/h)
        MaximumInterestingSpeed = 14;
        scaledSpeed = state(3) / MaximumInterestingSpeed; 
        if scaledSpeed > 1.0
            scaledSpeed = 1.0;
        end
            
        scaledAverageVelocity = desiredVelocity / MaximumInterestingSpeed;
        if scaledAverageVelocity > 1.0
            scaledAverageVelocity = 1.0;
        end
        
        maximumInterestingElevation = 12;
        scaledElevations = elevations / maximumInterestingElevation;
        scaledElevations(scaledElevations > 1.0) = 1.0;
        
        input = [scaledSpeed, scaledAverageVelocity, scaledElevations]; 
        
        % Use scaled values for command computation
        output = FFNet(wMat,aMat,input,p);
        
        % Crop output
        if output > 1.0
            output = 1.0;
        elseif output < 0.0
            output = 0.0;
        end
        state(5) = output;
        
        % Use command and state to compute state for next timestep
        state = computeNextTimeStep(state);
        
        %% Check new state
        % Fail if evaluation is taking too long
        if state(1) > 2*desiredTime
            fail = true;
            disp('Took too long');
            break;
        end
        
        % Fail if velocity is getting too low
        if state(3) < 1.0
           disp('Moving too slow');
           fail = true;
           break;
        end
        
        time(end+1) = state(1);
        location(end+1) = state(2);
        speed(end+1) = state(3);    
        energy(end+1) = state(4);    
        command(end+1) = state(5);
        
    end
    
    if fail
        fitness = eps; 
    else
        excessTime = time(end) - desiredTime;
        if excessTime < 0
            timePenalty = 0;
        else
            timePenalty = excessTime^2;
        end
        fitness = p.track.maximumPower - energy(end) - timePenalty; 
    end



end

