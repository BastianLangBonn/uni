function [state] = computeNextTimeStep(state)

  maxPower = 200;

%State:
  % 1: time
  % 2: location
  % 3: speed
  % 4: power
  % 5: command
  % 6: slope
  
  tChange = 1;
  xChange = state(3);
  Fu = maxPower * state(5) / state(3);
  vChange = (Fu - drag(state(3), state(6))) / 90;
  wChange = Fu * state(3);
  
  t = state(1) + tChange;
  x = state(2) + xChange;
  v = state(3) + vChange;
  w = state(4) + wChange;
  
  state(1) = t;
  state(2) = x;
  state(3) = v;
  state(4) = w;
  

end

function [result] = drag(velocity, slope)
  %% Parameters
  mass = 90; % in kg.
  airDensity = 1.225; % in kg/m^2
  effectiveFrontalArea = 0.3; % 
  rollingResistanceCoefficient = 0.005; 
  normalForce = mass * 9.81; % in kg*m/s^2

  result = 0.5 * effectiveFrontalArea * airDensity *...
    velocity * velocity +...
    rollingResistanceCoefficient * normalForce +...
    normalForce * slope;
end