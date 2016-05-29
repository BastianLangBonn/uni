function [ result ] = cmaes( evaluationFunction, nGenes,...
    functionParameters )
%CMAES Summary of this function goes here
%   Detailed explanation goes here

%% Initialize Parameters
    % step size
    sigma = 0.2; 
    % stop if fitness < stopfitness (minimization)
    stopFitness = 1e-10; 
    % Stop after that many function evaluations
    maximumGenerations = 2500; 

    nOffspring = 4+floor(3*log(nGenes));
    populationSize = nOffspring/2; 
    % Weight initialization taken from Hansen paper.
    weights = log(populationSize+1/2)-log(1:populationSize)';
    populationSize = floor(populationSize);    
    weights = weights/sum(weights); % normalize recombination weights array
    
    muEff=sum(weights)^2/sum(weights.^2); % variance-effective size of mu
    cmu = 2 * (muEff-2+1/muEff) / ((nGenes+2)^2+2*muEff/2); 
    C = eye(nGenes); % covariance matrix
    
    xMean = zeros(nGenes,1); % Initial mean is zero
    nEvaluations = 0;
%     figure(2); clf; hold on;
    for generation = 1:maximumGenerations
%% Generate Offspring
        offspring = zeros(nGenes, nOffspring);
        fitness = zeros(1,nOffspring);
        for k=1:nOffspring
            offspring(:,k) = mvnrnd(zeros(1,nGenes),C); % ~N(0,C)
            offspring(:,k) = xMean + sigma * offspring(:,k);
            % bind to -0.5,0.5
            offspring(offspring>0.5) = 0.5; 
            offspring(offspring<-0.5) = -0.5;
            functionParameters.points = offspring(:,k);
%% Evaluate Offspring
            fitness(k) = feval(evaluationFunction, functionParameters);
            nEvaluations = nEvaluations + 1;
        end

%% Sort Offspring by Fitness
        [fitness, index] = sort(fitness); % minimization
        bestFitness(generation) = fitness(1);
        meanFitness(generation) = mean(fitness);

%% Check if Fitness is already good enough
        if fitness(1) < stopFitness
           break; 
        end

%% Compute new mean
        xMean = offspring(:,index(1:populationSize))*weights;

%% Adapt Covariance Matrix 
        % Compute Cmu
        Cmu = zeros(nGenes);
        for i = 1:populationSize
            Cmu = Cmu + weights(i) * ((offspring(:,index(i)) - xMean)...
                * (offspring(:,index(i)) - xMean)');        
        end
        Cmu = 1/nOffspring * Cmu;

        C = (1-cmu) * C ... % regard old matrix
            + cmu/sigma^2 * Cmu; % plus rank mu update
        
%         plot(generation, fitness(1), 'r.');
%         plot(generation, median(fitness), 'b.');
%         pause(0.01);
    end
    
    result.bestFitness = bestFitness;
    result.meanFitness = meanFitness;
    result.bestSolution = offspring(:,index(1));

end

