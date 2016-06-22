% *************************************************************************
% extendTrackbySlope.m
% 
% Extends a track to a given length, keeping the slopes (rather than 
% elevations) constant.
%
% Usage: exportTrackbySlope(trackProfileinMatrixForm, 8192)
%
% *************************************************************************

function extTrack = extendTrackbySlope(track, trackLength)

trackSlope = getSlope(track);
%trackHeight = getHeight(trackSlope);
extTrackSlope = extendSlopeProfile(trackSlope, trackLength);
extTrack = getHeight(extTrackSlope);

subplot(2,2,1);plot(track);title('Original Track');
subplot(2,2,3);plot(trackSlope);title('Original Slope');
subplot(2,2,2);plot(extTrack);title('Extended Track');
subplot(2,2,4);plot(extTrackSlope);title('Extended Slope');

end

