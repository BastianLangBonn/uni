% x = [0 1 2 3 4 5 6 7 8];
% t = [0 0.84 0.91 0.14 -0.77 -0.96 -0.28 0.66 0.99];
% plot(x,t,'o')

% Here feedforwardnet creates a two-layer feed-forward network. The 
% network has one hidden layer with ten neurons.

% net = feedforwardnet(10);
% net = configure(net,x,t);
% y1 = net(x)
% plot(x,t,'o',x,y1,'x')

% The network is trained and then resimulated.

% net = train(net,x,t,'useParallel','yes');
% y2 = net(x)
% plot(x,t,'o',x,y1,'x',x,y2,'*')
clear;
data = importdata('./trackData.csv', ';', 1);
% column 1: currentVelocity
% column 2: passedTime
% column 3: slope
% column 4: command
% column 5: energy
% column 6: resultingVelocity
x = [data.data(:,1)'; data.data(:,2)'; data.data(:,3)'; data.data(:,4)'];
t = [data.data(:,5)'; data.data(:,6)'];

net = feedforwardnet(30);
net = configure(net,x,t);

net = train(net,x,t,'useParallel','yes');
y2 = net(x);

figure(1);clf;
plot(x(2,:),t(1,:),'ro')%,x(2,:),y2(1,:),'*');
xlabel('time')
ylabel('energy')
legend('teacher','result');
figure(2);clf;
plot(x(2,:),t(2,:),'ro',x(2,:),y2(2,:),'*');
xlabel('time')
ylabel('velocity');
legend('teacher','result');