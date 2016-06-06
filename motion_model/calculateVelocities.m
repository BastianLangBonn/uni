function [p] = calculateVelocities(p)

    for i=1:length(p)
        for j=1:length(p(i).time)-1
            x = p(i).x(j);
            y = p(i).y(j);
            theta = p(i).orientation(j);
            xNew = p(i).x(j+1);
            yNew = p(i).y(j+1);
            thetaNew = p(i).orientation(j+1);
            deltaT = p(i).time(j+1) - p(i).time(j);
            p(i).v(j) = sqrt((xNew - x)^2 + (yNew - y)^2)/deltaT;
            p(i).w(j) = (thetaNew - theta)/deltaT;    
            if p(i).v(j) == inf
               p(i).v(j) = 100000; 
            end
            if p(i).w(j) == inf
               p(i).w(j) = 100000; 
            end
            if p(i).v(j) == -inf
               p(i).v(j) = 0; 
            end
            if p(i).w(j) == -inf
               p(i).w(j) = 0; 
            end
        end
    end

end