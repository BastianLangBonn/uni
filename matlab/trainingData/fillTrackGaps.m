function [ extendedDistance, extendedElevation ] = fillTrackGaps( track )
%FILLTRACKGAPS Summary of this function goes here
%   Detailed explanation goes here
    distance = track(:,1);
    elevation = track(:,2);

    % Fill gaps in distance
    iCounter = 1;
    for iDistance = 2:length(distance)            
        iStart = distance(iDistance -1);
        iEnd = distance(iDistance);
        startElevation = elevation(iDistance-1);
        endElevation = elevation(iDistance);
        elevationRange = endElevation - startElevation;
        extendedDistance(iCounter) = iCounter;
        extendedElevation(iCounter) = startElevation;
        iCounter = iCounter + 1;
        for j = iStart+1:iEnd-1
            extendedDistance(iCounter) = iCounter;
            share = (j - iStart) / (iEnd - iStart);
            extendedElevation(iCounter) = startElevation + share * elevationRange;
            iCounter = iCounter + 1;
        end
    end

end

