%% NEAT - Main file, can be run as script for single experiments or as a function for longer runs
%   
% To run as a script, assign 'p' as a parameters set in the form that can
% be seen in the '../Experiments' folder. If run as a function the 'p'
% parameter settings should be given as a function.
%
% These two ways of running the algorithm can be toggles by commenting
% one of the first two sections.
%
% Overview of all algorithm functions can be obtained through 'help' on the
% directories:
%
%   dataGathering
%   diversity
%   evaluation
%   expression
%   initialization
%   recombination
%   visualization
%
% Main structs described in:
% [help structKey]
%
% Sample benchmarks can be found in the ../Experiments directory, which
% optimize fitness functions defined in the ../ProblemDomains folder.
% [help Experiments, help ProblemDomains]
%
% Neural networks are implemented in a bare-bones fashion which can be
% found in the ../ANN directory. 
% [help ANN]
%
% Tools for performing and comparing multiple runs can be found in the
% ../Analysis directory. 
% [help anaysis]
%   
% -------------------------------------------------------------------------
%
% Based on Neuroevolution of Augmenting Topologies algorithm described in: 
% Evolving neural networks through augmenting topologies (2002)
% by Stanley, K., & Miikkulainen, R.
% 
% Adam Gaier (2015)
%
% -------------------------------------------------------------------------

%% - Run as Script
%clear;
headless = false;
p = optimalControlParams;
% p = twoPole_Kmeans; 
% p = twoPole_ONEAT;
% p = xor_benchmark
% p = xor_benchmark_kmeans; 



%% - Run as Function
% function runData = NEAT(p)
% headless = true;

%% Initialize Environment
SystemInit;

%% Initialize Population and run first evaluation
gen = 1;
runData = [];
species = [];
[pop,innovation]= initializePop(p);

Expression;
Evaluation;
Speciation;

%% Data Gathering
gatherData;

%% Begin Evolution
while (gen < p.maxGen)
    %% Evolution Loop
    gen = gen + 1;
    Recombination;
    Expression;
    Evaluation;
    Speciation;
    
    %% Data Gathering and Visualization
    gatherData;
    displayData;
    
    %% Extra Stopping Criteria
    StoppingCriteria;    
end
getRunData;











