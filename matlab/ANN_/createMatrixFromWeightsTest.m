%% Unit Test
%% Test Case #1
% nWeights does not match topology
% Assign
clear;
p.points = [1 2 3 4 5 6];
p.topology = [2 2 1];
expected = 'Wrong number of weights';

% Act
actual = createMatrixFromWeights(p);

% Assert
if actual ~= expected
    disp('Error because of wrong number of inputs expected');
else
    disp('Test Case #1 passed');
end

%% Test Case #2
% Return correct weight matrix

% Assign
clear;
p.topology = [2 2 1];
p.points = [1 2 3 4 5 6 7 8 9];
expected = [1 2 0; 3 4 0; 0 0 5; 0 0 6; 7 8 9];

% Act
actual = createMatrixFromWeights(p);

% Assert
if ~isequal(actual,expected)
    disp('Wrong result for Test Case #2');
    disp(actual);
    disp(expected);
else
    disp('Test Case #2 passed');
end