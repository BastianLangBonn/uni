function Untitled4( cities, r )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    plot([cities.data(r.bestIndividual,2);cities.data(r.bestIndividual(1),2)],...
    [cities.data(r.bestIndividual,3);cities.data(r.bestIndividual(1),3)]);
    plot(cities.data(:,2), cities.data(:,3),'bo');
    plot(cities.data(r.bestIndividual(1),2), cities.data(r.bestIndividual(1),3),'r.');
    xlabel('x-coordinates');
    ylabel('y-coordinates');
    range([0,length(r.bestFitness),0,400]);
    legend('Best found route', 'cities', 'start city');

end

