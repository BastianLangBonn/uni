function [ vErr, wErr, gammaErr ] = motionModel( x,y,theta,v,w,xNew,...
    yNew,thetaNew,deltaT )
%MOTIONMODEL Summary of this function goes here
%   Detailed explanation goes here
    mu = 0.5*((x-xNew)*cos(theta) + (y-yNew)*sin(theta))/...
        ((y-yNew)*cos(theta) - (x-xNew)*sin(theta));
    xCircle = (x+xNew)/2 + mu*(y-yNew);
    yCircle = (y+yNew)/2 + mu*(x-xNew);
    rCircle = sqrt((x-xCircle)^2 + (y-yCircle)^2);
    deltaTheta = atan2(yNew - yCircle, xNew - xCircle) -...
        atan2(y-yCircle, x-xCircle);
    vFinal = deltaTheta/deltaT * rCircle;
    wFinal = deltaTheta/deltaT;
    gamma = (thetaNew - theta)/deltaT - wFinal;
    
    vErr = v - vFinal;
    wErr = w - wFinal;
    gammaErr = gamma;
    

end

