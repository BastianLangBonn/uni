function [ error ] = evaluateNacaShape( p )
%EVALUATENACASHAPE Evaluates a shape by comparing it to a specified NACA
%shape
%   Input is a struct containing points describing a shape and the NACA
%   number of the goal shape. Computes the difference between the y-values
%   of the given points. Returns the mean square error.


    % Naca
    nEvaluationPoints = 256; 
    nacaNumber = p.nacaNumber;                      % NACA Parameters
    nacafoil= create_naca(nacaNumber,nEvaluationPoints);  % Create foil

    % Extract spline representation of foil (with the same number of
    % evaluation points as the NACA profile
    [foil, nurbs] = pts2ind(p.points,nEvaluationPoints);

    % Calculate pairwise error
    [~,errorTop] = dsearchn(foil(:,1:end/2)',nacafoil(:,1:end/2)');
    [~,errorBottom] = dsearchn(foil(:,1+end/2:end)',...
        nacafoil(:,1+end/2:end)');

    % Total fitness
    error = mean([errorTop.^2; errorBottom.^2]);

end

