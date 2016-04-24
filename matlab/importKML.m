% *************************************************************************
% importKML.m
% 
% Imports KML file of GPS data into strategy file usable by the Stella
% framework. Custom tracks can be obtained from this site:
%
%   http://www.radroutenplaner.nrw.de/RRP_sprachen_02.html
%
% After plotting a track on this website click 'Download/Show GPS Track'
% and choose KML format. Note the length of the track, and enter the
% length in meters along with the track name.
%
% Usage: importKML('myDownloadedTrack', 15000)
%
%   Note:   This function assumes that the kml file is in the tracks folder
%           below the execution folder.
%
% *************************************************************************

function importKML(filename, meters)

gps = importdata([filename, '.kml']);
trackName = gps{4}(17:end-7);
ele = [];
for i=1:length(gps)
    %Find coordinate blocks
    if ( length(gps{i}) > 20)
        if (strcmp( gps{i}(7:19), '<coordinates>'))
            display('Coordinate cell found')
            coord = gps{i};
            coord(1:19) = [];
            coord(end:-1:end-13) = [];
            coord = str2num(coord);
            coord = coord(3:3:end);
            ele = [ele,coord];
        end
    end
end

%Scale coordinates to track length
scale = (meters)/(length(ele)-1);
displacement = ceil(([0:scale:meters]));
CSVroute = [displacement;(ele./2)];

outputFile = [trackName, '.csv'];
fid = fopen(outputFile,'wt');
fprintf(fid,'%d; %d \n', CSVroute);
fclose(fid);

%Plot imported elevation profile
test = importdata(outputFile, ';');
plot(test(:,1),test(:,2))

end
