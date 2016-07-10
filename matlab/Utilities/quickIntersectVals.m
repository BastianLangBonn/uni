function vals = quickIntersectVals(A,B)
%% Custom fast intersect for positive integers which returns only the values
%   Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions

P = zeros(1, max(max(A),max(B)) ) ;
P(A) = 1;
vals = B(logical(P(B)));
