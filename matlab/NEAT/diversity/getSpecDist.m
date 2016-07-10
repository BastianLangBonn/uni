
function speciesDist = getSpecDist(population,i,p)
    speciesDist = zeros(1,p.popSize);
    for j=1:p.popSize
        speciesDist(j) = species_diff(population(i),population(j),p);
    end
end