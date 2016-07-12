%% getFitness - Assigns fitness to individual based on fitness function designated in parameter file.
%
% Wrapper that calls fitness function designated in parameter file, use
% this to assign fitness components for visualization, or scale raw fitness
% scores.
%
% function ind = getFitness(ind, p)
%

function ind = getFitness(ind, p)

%% XOR
if strcmp(func2str(p.fitFun), 'xor_test')
    fitness = (4-p.fitFun(ind,p)).^2; %XOR
    ind.fitness = fitness;
end

%% 2 Pole Balancing
if strcmp(func2str(p.fitFun), 'twoPole_test')
    [fitness, ind.steps] = p.fitFun(ind,p);
    ind.fitness = fitness;
end

%% 2 Pole Balancing
if strcmp(func2str(p.fitFun), 'running_test_2')
    [fitness, energy, power, speed, command] = p.fitFun(ind, p);
    ind.fitness = fitness;
end

%% Optimal Control
if strcmp(func2str(p.fitFun), 'evaluateOnTrackSet')
    [fitness] = p.fitFun(ind, p);
    ind.fitness = fitness;
end

end