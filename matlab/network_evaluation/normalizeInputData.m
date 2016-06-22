function [ normalizedData ] = normalizeInputData( data )
%NORMALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
  ranges = [1 1]; %motor command, , slope
  
  normalizedData(:,1) = data(:,1)/ranges(1); 
  normalizedData(:,2) = data(:,2) / ranges(2);

end

