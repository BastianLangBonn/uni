function [ result ] = simulateTrackTime( track, command )
%SIMULATETRACKTIME Simulate a given track with respect to time
%   Detailed explanation goes here

    %% Parameters
    maxPower = 200; % in W
    
    %% Read track information
    result.travelledDistance = track(:,1);
    result.elevation = track(:,2);
    
    %% Prepare Slope Lookup
    % Compute and store the slope for any given distance-elevation-sample
    result.slopeLookup = containers.Map()
    for sample=1:length(result.travelledDistance)-1
        slope = result.elevation(sample+1) - result.elevation(sample);
        iMax = result.travelledDistance(sample+1);
        index = result.travelledDistance(sample);
        while index < iMax
            result.slopeLookup(int2str(index)) = slope;                       
            index = index + 1;
        end
    end
    % Set last slope-value to 0 
    result.slopeLookup(int2str(result.travelledDistance(end))) = 0;
    
    %% Simulate track
    t = 0;
    x = 0;
    v = 1;
    W = 0;
    counter = 1;
    while x <= result.travelledDistance(end)
        tChange = 0.1;
        xChange = 0.1 * v;
        Fu = maxPower * command / v;
        slope = result.slopeLookup(int2str(round(x)));
        vChange = (Fu - drag(v,slope))/90;
        WChange = Fu * v;
        t = t + tChange;
        x = x + xChange;
        v = v + vChange;
        W = W + WChange;
        
        result.time(counter) = t;
        result.velocity(counter) = v;
        result.command(counter) = command;
        result.slope(counter) = slope;
        result.acceleration(counter) = vChange;
        result.energy(counter) = W;
        result.distance(counter) = x;
        if v <=0
            break
        end
        counter = counter + 1;
    end
    
end

function [result] = drag(velocity, slope)
    %% Parameters
    mass = 90; % in kg. Needs to be corrected
    airDensity = 1.225; % in kg/m^2
    effectiveFrontalArea = 0.3; % unit?
    rollingResistanceCoefficient = 0.005; % unit?
    normalForce = mass * 9.81; % in kg*m/s^2

    result = 0.5 * effectiveFrontalArea * airDensity *...
        velocity * velocity +...
        rollingResistanceCoefficient * normalForce +...
        normalForce * slope;
end

