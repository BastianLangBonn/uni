function [ mse ] = evaluateTrack( wMat, track )
%EVALUATETRACK Summary of this function goes here
%   Detailed explanation goes here
  addpath('./../ANN/');
  activation = zeros(1,size(wMat,1));
  nTimesteps = length(track.time);
  
  v = 1; % Because simple model also starts with v=1
  t = 0;
  x = 0;
  W = 0;
  c = track.command(1);
  s = track.slopeLookup(int2str(x));
  a = 0;
  
  command(1) = c;
  slope(1) = s;    
  time(1) = t;
  velocity(1) = v;
  energy(1) = W;
  distance(1) = x;
  acceleration(1) = a;
  
  step = 1;
  while distance(step) < track.travelledDistance(end) &&...
      step < nTimesteps
    % Compute next timestep's values
    step = step + 1;    
    t = t + 0.1;
    x = x + 0.1 * v;
    if x < 0
      x = 0;
    end
    s = track.slopeLookup(int2str(round(x)));
    input = [c, s];
    activation = RNNet(wMat, input, activation);
    a = v - activation(end-1);    
    [v,W] = normalizeOutputData([activation(end-1),activation(end)]);
    % Store values
    command(step) = c;
    slope(step) = s;    
    time(step) = t;
    velocity(step) = v;
    energy(step) = W;
    distance(step) = x;
    acceleration(step) = a;     
    
    % Compute error by comparing to given values
    error(step-1, 1) = track.velocity(step) - velocity(step);
    error(step-1, 2) = track.energy(step) - energy(step);
    error(step-1, 3) = track.distance(step) - distance(step);
    error(step-1, 4) = track.acceleration(step) - acceleration(step);
  end

  mse = mean([error(:,1).^2;error(:,2).^2;error(:,3).^2;error(:,4).^2]);
%   display(mse);
  
end

