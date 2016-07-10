
function speciesDist = getSpecDist_ltd(pop,i,p)
    speciesDist = zeros(1,length(pop));
    for j=i:length(pop)
        speciesDist(j) = species_diff(pop(i),pop(j),p);
    end
end