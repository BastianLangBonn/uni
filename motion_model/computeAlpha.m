data1 = analyzeMotionLog('./logs1/right.log');
data2 = analyzeMotionLog('./logs2/right.log');
data3 = analyzeMotionLog('./logs1/left.log');
data4 = analyzeMotionLog('./logs2/left.log');

%A.ALPHA = SIGMA
Ar = abs([data1.v data1.omega 0 0 0 0;
    0 0 data1.v data1.omega 0 0; 
    0 0 0 0 data1.v data1.omega;
    data2.v data2.omega 0 0 0 0;
    0 0 data2.v data2.omega 0 0;
    0 0 0 0 data2.v data2.omega]);
SIGMAr = [data1.sigma1; data1.sigma2; data1.sigma3; data2.sigma1; data2.sigma2; data2.sigma3];
ALPHAr = inv(Ar)*SIGMAr;

Al = abs([data3.v data3.omega 0 0 0 0;
    0 0 data3.v data3.omega 0 0; 
    0 0 0 0 data3.v data3.omega;
    data4.v data4.omega 0 0 0 0;
    0 0 data4.v data4.omega 0 0;
    0 0 0 0 data4.v data4.omega]);
SIGMAl = [data3.sigma1; data3.sigma2; data3.sigma3; data4.sigma1; data4.sigma2; data4.sigma3];
ALPHAl = pinv(Al)*SIGMAr;

A = vertcat(Ar,Al);
SIGMA = vertcat(SIGMAr, SIGMAl);
ALPHA = pinv(A)*SIGMA;
display(ALPHA);