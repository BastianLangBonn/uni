%% Read Training Data
clear;
trainingData = importdata('./data/trackData.csv', ';', 1);
%load('trainingData.mat');

%% Normalize Data
currentVelocity = trainingData.data(:,1);
velocityRange = max(currentVelocity) - min(currentVelocity);
currentVelocity = currentVelocity/velocityRange;
slope = trainingData.data(:,3);
slope = slope/(max(slope) - min(slope));
command = trainingData.data(:,4);
energy = trainingData.data(:,5);
energy = energy/(max(energy) - min(energy));
resultingVelocity = trainingData.data(:,6);
resultingVelocity = resultingVelocity/velocityRange;


%% Train model
x = [currentVelocity'; slope'; command'];
t = [energy'; resultingVelocity'];

net = feedforwardnet(20);
net = configure(net,x,t);

net = train(net,x,t,'useParallel','yes');
y2 = net(x);

figure(1);clf;
plot(t(1,:),t(2,:),'ro',y2(1,:),y2(2,:),'bo');
xlabel('energy')
ylabel('velocity')
legend('teacher','result');
figure(2);clf;
plot(t(2,:),'ro',y2(2,:),'*');
xlabel('time')
ylabel('velocity');
legend('teacher','result');