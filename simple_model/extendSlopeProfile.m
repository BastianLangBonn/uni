
function extSlopeProfile = extendSlopeProfile(slopeProfile, trackLength)

%interval = round(trackLength/length(slopeProfile));
interval = (trackLength+1)/length(slopeProfile);

s_new = linspace(1,numel(slopeProfile), interval*numel(slopeProfile)-1);

extSlopeProfile = interp1(slopeProfile, s_new);

end