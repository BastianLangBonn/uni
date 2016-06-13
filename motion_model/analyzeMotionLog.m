%Read the log file
%file = './logs1/right.log';
function [data] = analyzeMotionLog(file)
read = importdata(file,' ',0);
c = 400 % The number of log entries to be cropped at start and end
e = size(read,1) - c;
data.time = read(c:e,1);
data.x = read(c:e,2);
data.y = read(c:e,3);
data.orientation = read(c:e,4);
data.duration = data.time(end) - data.time(1);

%Make the start at 0,0,0
% Get orientation
    offsetX = data.x(1);
    offsetY = data.y(1);
    offsetOrientation = data.orientation(1) - atan2(data.y(2)-data.y(1),data.x(2)-data.x(1));
    
    
    for j = 1:length(data.time)
        % translate
        data.x(j)= data.x(j) - offsetX;
        data.y(j) = data.y(j) - offsetY;
        data.orientation(j) = data.orientation(j) - offsetOrientation;
        
%         % rotate
%         data.x(j) = cos(-offsetOrientation )*x...
%             - sin(-offsetOrientation)*y;
%         data.y(j) = sin(-offsetOrientation)*x...
%             + cos(-offsetOrientation)*y;
%         data.orientation(j) = orientation;
    end

%Visualize the motion trajectory
% Plot 
figure(1);clf;hold on;
plot(data.x, data.y);
title('Motion Trajectory');
xlabel('x in mm');
ylabel('y in mm');
grid on;

figure(2);clf;hold on;
plot(data.x);
title('X vs Time');
xlabel('Time step');
ylabel('x in mm');
grid on;

figure(3);clf;hold on;
plot(data.y);
title('Y vs Time');
xlabel('Time step');
ylabel('y in mm');
grid on;

figure(4);clf;hold on;
plot(data.orientation);
title('Theta vs Time');
xlabel('Time step');
ylabel('Theta in radiants');
grid on;




%Calculate the motion errors
data.vHat = double.empty(length(data.time)-1,0);
data.omegaHat = double.empty(length(data.time)-1,0);
data.gammaHat = double.empty(length(data.time)-1,0);
data.deltaT = double.empty(length(data.time)-1,0);

for i = 2:length(data.time)
    x = data.x(i-1)
    xNew = data.x(i);
    y = data.y(i-1);
    yNew = data.y(i);
    theta = data.orientation(i-1);
    thetaNew = data.orientation(i);
    deltaT = (data.time(i) - data.time(i-1));
    
    mu = 0.5*((x-xNew)*cos(theta) + (y-yNew)*sin(theta))/...
        ((y-yNew)*cos(theta) - (x-xNew)*sin(theta));
    xCircle = (x+xNew)/2 + mu*(y-yNew);
    yCircle = (y+yNew)/2 + mu*(xNew-x);
    rCircle = sqrt((x-xCircle)^2 + (y-yCircle)^2);
    deltaTheta = angdiff(atan2(yNew - yCircle, xNew - xCircle) ,... %Important .. wrong in the book
        atan2(y-yCircle, x-xCircle));
    data.vHat(i-1) = deltaTheta/deltaT * rCircle;
    data.omegaHat(i-1) = deltaTheta/deltaT;
    data.gammaHat(i-1) = (thetaNew - theta)/deltaT - data.omegaHat(i-1);
        data.deltaT(i-1) = theta;
end

%Visualize the linear velocity
figure(5);clf;hold on;
plot(data.vHat);
title('Linear velocity');
xlabel('Time step');
ylabel('Linear velocity (m/s)');
grid on;

%Visualize the angular velocity
figure(6);clf;hold on;
grid on;
plot(data.omegaHat);
title('Angular velocity');
xlabel('Time step');
ylabel('Angular velocity (rad/s)');

%Visualize the gamma
figure(7);clf;hold on;
grid on;
plot(data.gammaHat);
title('Gamma');
xlabel('Time step');
ylabel('Angular velocity (rad/s)');

data.v = mean(data.vHat);
data.omega = mean(data.omegaHat);
data.gamma = mean(data.gammaHat);
data.sigma1 = std(data.vHat);
data.sigma2 = std(data.omegaHat);
data.sigma3 = std(data.gammaHat);

end
