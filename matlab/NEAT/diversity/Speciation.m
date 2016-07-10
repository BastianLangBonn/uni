%% Speciation - Updates species and population. Wrapper with execution timer.
%
%

speciate_start = tic;

    [species, pop] = speciate(pop, p, species);
    
speciate_time(gen) = toc(speciate_start);