function [ normalizedData ] = normalizeOutputData( data )
%NORMALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
  ranges = [37 200]; %m/s, energy
  
  normalizedData(:,1) = data(:,1)/ranges(1); 
  normalizedData(:,2) = data(:,2) / ranges(2);

end

