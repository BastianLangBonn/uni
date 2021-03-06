%% Initialize Parameters
clear;
nGenes = 32; % number of objective variables/problem dimension
sigma = 0.2; % coordinate wise standard deviation (step-size)
stopFitness = 1e-10; % stop if fitness < stopfitness (minimization)
maximumGenerations = 2000;%1e3*nGenes^2; % stop after stopeval number of function evaluations

% Strategy parameter setting: Selection
nOffspring = 4+floor(3*log(nGenes)); % population size, offspring number
populationSize = nOffspring/2; % lambda=12; mu=3; weights = ones(mu,1); would be (3_I,12)-ES
weights = log(populationSize+1/2)-log(1:populationSize)'; % muXone recombination weights
populationSize = floor(populationSize); % number of parents/points for recombination
weights = weights/sum(weights); % normalize recombination weights array
muEff=sum(weights)^2/sum(weights.^2); % variance-effective size of mu

% Strategy parameter setting: Adaptation
cmu = 2 * (muEff-2+1/muEff) / ((nGenes+2)^2+2*muEff/2); 

% Initialize dynamic (internal) strategy parameters and constants
C = eye(nGenes); % covariance matrix

% Naca
nEvaluationPoints = 256; 
nacaNumber = [0,0,1,2];                      % NACA Parameters
nacafoil= create_naca(nacaNumber,nEvaluationPoints);  % Create foil


xMean = zeros(nGenes,1); % Initial mean is zero
%population = rand(nGenes, nOffspring) -0.5; % Initialize Population
figure(1); clf; hold on;
for generation = 1 : maximumGenerations
%% Generate Offspring
    offspring = zeros(nGenes, nOffspring);
    for k=1:nOffspring
        offspring(:,k) = mvnrnd(zeros(1,nGenes),C); % ~N(0,C)
        offspring(:,k) = xMean + sigma * offspring(:,k);
        % bind to -0.5,0.5
        offspring(offspring>0.5) = 0.5; 
        offspring(offspring<-0.5) = -0.5;
%         arz(:,k) = randn(nGenes,1); % standard normally distributed vector
%         arx(:,k) = xMean + sigma * (B*D * arz(:,k)); % add mutation % Eq. 37

%% Evaluate Offspring
        % Extract spline representation of foil (with the same number of
        % evaluation points as the NACA profile
        [foil, nurbs] = pts2ind(offspring(:,k),nEvaluationPoints);
        
        % Calculate pairwise error
        [~,errorTop] = dsearchn(foil(:,1:end/2)',nacafoil(:,1:end/2)');
        [~,errorBottom] = dsearchn(foil(:,1+end/2:end)',...
            nacafoil(:,1+end/2:end)');

        % Total fitness
        fitness(k) = mean([errorTop.^2; errorBottom.^2]);
        %arfitness(k) = feval(strfitnessfct, arx(:,k)); % objective function call
    end
    
%     figure(2);clf;hold on;
%     axis([-1 1 -1 1]);
%     for i=1:nOffspring 
%         plot(offspring(1,i), offspring(2,i),'ro');
%     end
%     pause(0.1);
    
%% Sort Offspring by Fitness
    [fitness, index] = sort(fitness); % minimization
    
%% Check if Fitness is good enough
    if fitness(1) < stopFitness
       break; 
    end

%% Compute new mean
	xMean = offspring(:,index(1:populationSize))*weights; % recombination
	%zMean = arz(:,index(1:mu))*weights; % == D�-1*B�*(xmean-xold)/sigma
    
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

    
    figure(1); 
    semilogy(generation, fitness(1), 'r.');
    semilogy(generation, median(fitness), 'b.');
    
    
    [foil, nurbs] = pts2ind(offspring(:,index(1)),nEvaluationPoints);
    figure(2);
    plot(nacafoil(1,:),nacafoil(2,:), 'LineWidth', 3);
    hold on;
    plot(foil(1,:),foil(2,:), 'r', 'LineWidth', 3);
    plot(nurbs.coefs(1,1:end/2),nurbs.coefs(2,1:end/2),'rx', 'LineWidth', 3);
    axis equal;
    axis([0 1 -0.7 0.7]);
    legend('NACA 0012 target', 'Approximated Shape');
    ax = gca;
    ax.FontSize = 24;
    drawnow;
    hold off;
    
    pause(0.01);
end

%% Visualize
    [foil, nurbs] = pts2ind(offspring(:,index(1)),nEvaluationPoints);
    figure(1);
    plot(nacafoil(1,:),nacafoil(2,:), 'LineWidth', 3);
    hold on;
    plot(foil(1,:),foil(2,:), 'r', 'LineWidth', 3);
    plot(nurbs.coefs(1,1:end/2),nurbs.coefs(2,1:end/2),'rx', 'LineWidth', 3);
    axis equal;
    axis([0 1 -0.7 0.7]);
    legend('NACA 0012 target', 'Approximated Shape');
    ax = gca;
    ax.FontSize = 24;
    drawnow;
    hold off;

