function [ result ] = simulateTrack( track, command )
%SIMULATETRACK Summary of this function goes here
%   Detailed explanation goes here

    %% Parameters
    mass = 90; % in kg. Needs to be corrected
    airDensity = 1.225; % in kg/m�
    ftp = 200; % Not exactly sure what it is, but needed to compute wheel force
    effectiveFrontalArea = 0.3; % unit?
    rollingResistanceCoefficient = 0.005; % unit?
    normalForce = mass * 9.81; % in kg*m/s�

    %% Read track information
    result.travelledDistance = track(:,1);
    result.elevation = track(:,2);

    %% Simulate
    result.velocity(1) = 1;
    result.command = command;
    result.time(1) = 0;
    result.slope(length(track)) = 0;
    result.acceleration(1) = 0;
    result.energy(1) = 0;
    for index=1:length(track)-1
        result.slope(index) = track(index+1,2)-track(index,2);
        
        F = ftp*result.command/result.velocity(index) -...
            (0.5*effectiveFrontalArea * airDensity *...
            result.velocity(index)^2 +...
            rollingResistanceCoefficient*normalForce+...
            normalForce*result.slope(index));
        
        %result.energy(index+1) = F;
        result.energy(index+1) = ftp*result.command/result.velocity(index);
        
        deltaTime = 1/result.velocity(index);
        result.time(index+1)=result.time(index) + deltaTime;
        
        deltaVelocity = F/(mass*result.velocity(index));
        result.velocity(index+1) = result.velocity(index) + deltaVelocity;
        
        result.acceleration(index+1) = deltaVelocity/deltaTime;
    end

end

