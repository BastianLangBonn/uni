function output = compute_statistical_data( data_set )
%COMPUTE_STATISTICAL_DATA Summary of this function goes here
%   Detailed explanation goes here
    output.ground = data_set;
    output.median = median(data_set,1);
    output.mean = mean(data_set, 1);
    output.mode = mode(data_set,1);
end

