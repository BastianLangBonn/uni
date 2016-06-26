
function slopeProfile = getSlope(track)

track2 = [track,0];
slopeProfile = (track2(2:length(track2)) - track);
slopeProfile(end) = slopeProfile(end-1);

end