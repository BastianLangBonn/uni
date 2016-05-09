%% Unit test for twoPointCrossover function

%% 2/3
mateA = [1,2,3,4,5,6,7];
mateB = [7,6,5,4,3,2,1];
pointA = 2;
pointB = 3;
expectedOffspring = [1,2,3,4,5,6,7];
subject = twoPointCrossover(mateA, mateB, pointA, pointB);

if subject == expectedOffspring
    disp('2/3: Test Passed')
else
    disp('2/3: Test Failed')
    expectedOffspring
    subject
end

%% 2/4
mateA = [1,2,3,4,5,6,7];
mateB = [7,6,5,4,3,2,1];
pointA = 2;
pointB = 4;
expectedOffspring = [1,2,4,3,5,6,7];
subject = twoPointCrossover(mateA, mateB, pointA, pointB);

if subject == expectedOffspring
    disp('2/4: Test Passed')
else
    disp('2/4: Test Failed')
    expectedOffspring
    subject
end

%% 0/7
mateA = [1,2,3,4,5,6,7];
mateB = [7,6,5,4,3,2,1];
pointA = 0;
pointB = 7;
expectedOffspring = [7,6,5,4,3,2,1];
subject = twoPointCrossover(mateA, mateB, pointA, pointB);

if subject == expectedOffspring
    disp('0/7: Test Passed')
else
    disp('0/7: Test Failed')
    expectedOffspring
    subject
end
