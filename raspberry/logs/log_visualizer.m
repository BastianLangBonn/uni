data = csvread('./log_copy/processed_log_1467803198.txt');

tooHigh = data(:,8) > 100000;
data(tooHigh,8) = 0;

figure(1); clf;
plot(data(10000:20000,3));
figure(2); clf;
plot(data(10000:20000,4));
figure(3); clf;
plot( data(10000:20000,8));