function [ v W ] = normalizeOutputData( data )
%NORMALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
  ranges = [37 200]; %m/s, energy
  
  v = data(:,1)/ranges(1); 
  W = data(:,2) / ranges(2);

end

