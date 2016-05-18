function [ result ] = simulateTrackTime( track, command )
%SIMULATETRACKTIME Summary of this function goes here
%   Detailed explanation goes here

    %% Parameters
    maxPower = 200; % in W
    
    %% Read track information
    result.travelledDistance = track(:,1);
    result.elevation = track(:,2);
    
    %% Prepare Slope Lookup
    %result.slope = zeros(result.travelledDistance(end),1);
    result.slopeLookup = containers.Map()
    for i=1:length(result.travelledDistance)-1
        slope = result.elevation(i+1) - result.elevation(i);
        iMax = result.travelledDistance(i+1);
        index = result.travelledDistance(i);
        while index < iMax
            result.slopeLookup(int2str(index)) = slope;                       
            index = index + 1;
        end
    end
    result.slopeLookup(int2str(length(result.travelledDistance))) = 0;
    
    %% Simulate track
    % What about t=0?
    t = 0;
    x = 0;
    v = 1;
    W = 0;
    while x <= result.travelledDistance(length(result.travelledDistance))
        tChange = 1;
        xChange = v;
        Fu = maxPower * command / v;
        slope = result.slopeLookup(int2str(x));
        vChange = (Fu - drag(v,slope))/90;
        WChange = Fu * v;
        t = t + tChange;
        x = x + xChange;
        v = v + vChange;
        W = W + WChange;
        
        result.time(t) = t;
        result.velocity(t) = v;
        result.command(t) = command;
        result.slope(t) = slope;
        result.acceleration(t) = vChange;
        result.energy(t) = W;
        result.distance(t) = x;
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

