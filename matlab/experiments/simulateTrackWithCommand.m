function [t, x, v, w] = simulateTrackWithCommand(track, command)

    slope = (track.elevation(2:end)-track.elevation(1:end-1));
    slope(:,end+1) = slope(:,end);
    distance = track.distance;
    elevation = track.elevation;
    
    t = 0;
    x = 0;
    v = 1.5;
    w = 0;
    fail = false;
    
    state(1) = t;
    state(2) = x;
    state(3) = v;
    state(4) = w;
    state(5) = command;
    
    while(state(2) < distance(end) && ~fail)
        pos = floor(state(2))+1;
        state(6) = slope(pos);
        
        state = computeNextTimeStep(state);
        
        if state(3) < 1
            disp('Movement too slow');
            fail = true;
            break;
        end
        
        t(end + 1) = state(1);
        x(end + 1) = state(2);
        v(end + 1) = state(3);
        w(end + 1) = state(4);
        
    end

end