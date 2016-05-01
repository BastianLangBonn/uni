%% Unit test for onePointCrossover function

%% 50/50
mateA = [1,2,3,4];
mateB = [4,3,2,1];
crossoverPoint = 2;
expectedOffspring = [1,2,4,3];
subject = onePointCrossover(mateA, mateB, crossoverPoint);

if subject == expectedOffspring
    disp('50/50: Test Passed')
else
    disp('50/50: Test Failed')
    expectedOffspring
    subject
end

%% 0/100
mateA = [1,2,3,4];
mateB = [4,3,2,1];
expectedOffspring = [4,3,2,1];
crossoverPoint = 0;
subject = onePointCrossover(mateA, mateB, crossoverPoint);

if subject == expectedOffspring
    disp('0/100: Test Passed')
else
    disp('0/100: Test Failed')
    expectedOffspring
    subject
end

%% 100/0
mateA = [1,2,3,4];
mateB = [4,3,2,1];
expectedOffspring = [1,2,3,4];
crossoverPoint = 4;
subject = onePointCrossover(mateA, mateB, crossoverPoint);

if subject == expectedOffspring
    disp('100/0: Test Passed')
else
    disp('100/0: Test Failed')
    expectedOffspring
    subject
end

%% 1/3
mateA = [1,2,3,4];
mateB = [4,3,2,1];
expectedOffspring = [1,4,3,2];
crossoverPoint = 1;
subject = onePointCrossover(mateA, mateB, crossoverPoint);

if subject == expectedOffspring
    disp('1/3: Test Passed')
else
    disp('1/3: Test Failed')
    expectedOffspring
    subject
end
