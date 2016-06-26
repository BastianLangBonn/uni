function [ result ] = predictTrackWithNetwork( track, wMat, command )
%PREDICTTRACKWITHNETWORK Summary of this function goes here
%   Detailed explanation goes here
  addpath('./../simple_model/', './../ANN/', './../network_evaluation/');
  activation = zeros(1,size(wMat,1));
  result.travelledDistance = track(:,1);
  result.elevation = track(:,2);
  result.slopeLookup = createSlopeLookup(track(:,1), track(:,2));
  v = 1; % Because simple model also starts with v=1
  t = 0;
  x = 0;
  W = 0;
  c = command;
  s = result.slopeLookup(int2str(x));
  a = 0;
  
  result.command(1) = c;
  result.slope(1) = s;    
  result.time(1) = t;
  result.velocity(1) = v;
  result.energy(1) = W;
  result.distance(1) = x;
  result.acceleration(1) = a;
  
  step = 1;
  while result.distance(step) < result.travelledDistance(end)
    % Compute next timestep's values
    step = step + 1;    
    t = t + 0.1;
    x = x + 0.1 * v; 
    s = result.slopeLookup(int2str(round(x)));
    input = [c, s];
    activation = RNNet(wMat, input, activation);
    a = v - activation(end-1);    
    [v,W] = normalizeOutputData([activation(end-1),activation(end)]);
    if v < 0
      return;
    end
    % Store values
    result.command(step) = c;
    result.slope(step) = s;    
    result.time(step) = t;
    result.velocity(step) = v;
    result.energy(step) = W;
    result.distance(step) = x;
    result.acceleration(step) = a;     

  end
end

