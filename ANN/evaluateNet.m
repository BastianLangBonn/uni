function [ fitness ] = evaluateIndividual( p )
%EVALUATENET Summary of this function goes here
%   Detailed explanation goes here
    

    % create net/weight matrix    
    weightMatrix = createMatrixFromWeights(p);

    % Evaluate Net
    %tic;
    error = 0;
    for i = 1:p.trials
        iImage = randi(size(p.images,1));
        result = propagateInput(weightMatrix, p.images(iImage,2:end),...
            p.topology(3));
        iOut = p.images(iImage,1) * 255;
        [m, prediction] = max(result);
        prediction = prediction - 1;
%         label = zeros(1,p.topology(3)) + 0.001;
%         label(iOut+1) = 0.999;
%         error = error + mean(label.^2);
        if prediction == iOut
            disp('Matched!');
        else
            error = error + 1;
        end

    end
    %toc;
    
    fitness = error/p.trials;
    
end

