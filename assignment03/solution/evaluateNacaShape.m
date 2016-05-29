function [ error ] = evaluateNacaShape( p )
%EVALUATENACASHAPE Summary of this function goes here
%   Detailed explanation goes here
    
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

