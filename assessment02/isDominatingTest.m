% Unit test for isDominating

% Arrange
p.population = [0,0,1,1; 1,0,0,1];
p.leadingZeros = [2;0];
p.trailingOnes = [2;1];
expected = 1;
% Act
result = isDominating(1,2,p);
% Assert
disp(expected == result);

% Act
result = isDominating(2,1,p);

% Assert
disp(0 == result);