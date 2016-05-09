%% Unit test for onePointCrossoverSet

%% Probability 0
% Arrange
matesA = [1,2,3;1,3,2;3,2,1];
matesB = [1,3,2;2,1,3;3,2,1];
probability = 0;
expectedOffspring = matesA;
% Act
subject = onePointCrossoverSet(matesA, matesB, probability);
% Assert

if subject == expectedOffspring
    disp('Probability 0: Test Passed')
else
    disp('Probability 0: Test Failed')
    expectedOffspring
    subject
end

%% Probability 1
% Arrange
matesA = [1,2,3;1,3,2;3,2,1];
matesB = [1,3,2;2,1,3;3,2,1];
probability = 1;
expectedOffspring = matesB;
% Act
subject = onePointCrossoverSet(matesA, matesB, probability);
% Assert

if subject == expectedOffspring
    disp('Probability 0: Test Passed')
else
    disp('Probability 0: Test Failed')
    expectedOffspring
    subject
end