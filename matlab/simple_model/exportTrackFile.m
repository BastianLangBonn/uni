% *************************************************************************
% exportTrackFile.m
% 
% Converts a 2XN vector into a track file to be used by any of the
% optimization techniques. 
%
% Usage: exportTrackFile(trackProfileinMatrixForm, 'myNewTrack.csv')
%
% *************************************************************************


function exportTrackFile (profile, fileName)

track = [[0:(length(profile)-1)];profile];

fid = fopen(fileName,'wt');
    fprintf(fid,'%d; %d \n',track);
    fclose(fid);
end