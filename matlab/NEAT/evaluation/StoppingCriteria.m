%% StoppingCriteria - Early termination test. Wrapper with execution timer.
%
% Requires definition of p.stoppingCriteria()
%

stopping_start = tic;

if isfield(p,'stoppingCriteria') 
    
    p.stoppingCriteria();
    
end

stopping_time(gen) = toc(stopping_start);

