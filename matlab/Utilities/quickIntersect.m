function [IA, IB, vals] = quickIntersect(A,B)
%% quickIntersect - Custom fast intersect for positive integers (index and values)
%   Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions

P = zeros(1, max(max(A),max(B)) ) ;
P(A) = 1;
IB = logical(P(B));
    P(A) = 0; % back to zeros without creating new matrix
    P(B) = 1;
    IA = logical(P(A));
    vals = B(IB);
    
end

