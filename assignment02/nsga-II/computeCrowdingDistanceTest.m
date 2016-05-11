% Unit Test for computeCrowdingDistance

% ARRANGE
p.population = [0,0,1,0,1;...
    0,1,0,0,1;...
    1,0,0,0,0;1,...
    0,1,1,1;...
    0,0,0,0,1;...
    1,1,1,1,1];
p.leadingZeros = [2;1;0;0;4;0];
p.trailingOnes = [1;1;0;3;1;5];
expected = [19/20;0.5;Inf;4/5;Inf;Inf];

% ACT
result = computeCrowdingDistance(p.population);

% ASSERT
if result == expected
    disp('passed');
else
    disp('failed');
end