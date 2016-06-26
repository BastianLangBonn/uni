
function heightProfile = getHeight(slopeProfile)

heightProfile(1) = 0;

for i=2:length(slopeProfile)
    heightProfile(i) = heightProfile(i-1) + slopeProfile(i-1);
end

heightProfile = heightProfile - min(heightProfile);

end