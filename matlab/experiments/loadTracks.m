function [ track ] = loadTracks()
%LOADTRACKS Summary of this function goes here
%   Detailed explanation goes here
    
    %% Load Tracks
    trackFiles = dir('./tracks/*.csv');
    
    for i = 1:length(trackFiles)
        trackName = trackFiles(i).name;
        trackData = importdata(sprintf('./tracks/%s',trackName), ';', 0);
        distance = trackData(:,1);
        elevation = trackData(:,2);
        
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
        track(i).distance = extendedDistance;
        track(i).elevation = extendedElevation;
        slope = (track(i).elevation(2:end)-track(i).elevation(1:end-1));
        slope(:,end+1) = slope(:,end);
        track(i).slope = slope;
        track(i).name = trackName;
    end

end

