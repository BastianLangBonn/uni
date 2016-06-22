function [ slopeLookup ] = createSlopeLookup( travelledDistance, elevation )
%% Prepare Slope Lookup
    % Compute and store the slope for any given distance-elevation-sample
    slopeLookup = containers.Map();
    for sample=1:length(travelledDistance)-1
        slope = elevation(sample+1) - elevation(sample);
        iMax = travelledDistance(sample+1);
        index = travelledDistance(sample);
        while index < iMax
            slopeLookup(int2str(index)) = slope;                       
            index = index + 1;
        end
    end
    % Set last slope-value to 0 
    slopeLookup(int2str(travelledDistance(end))) = 0;


end

