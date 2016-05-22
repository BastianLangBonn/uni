%% Read Training Data
clear;
trainingData = importdata('./data/trackData.csv', ';', 1);

%% Train model

x = [trainingData.data(:,1)'; trainingData.data(:,2)';...
    trainingData.data(:,3)'; trainingData.data(:,4)'];
t = [trainingData.data(:,5)'; trainingData.data(:,6)'];

net = feedforwardnet(80);
net = configure(net,x,t);

net = train(net,x,t,'useParallel','yes');
y2 = net(x);