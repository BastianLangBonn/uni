function [ new_ind ] = spawnInd( num_nodes, weight_range )
%spawnInd 
%   Creates new individual
%
%   Genome: weights from this node to [h1 h2 h3 out1 in1 in2]
%

new_ind.fitness = 1e10;
new_ind.trials  = 0;
new_ind.weights = (rand(1,num_nodes)-0.5) * (2*weight_range);

% Reduce active connections
x = rand(1,num_nodes);
x(x<0.75) = 0;
x(x>=0.75)= 1;

new_ind.weights = new_ind.weights .* x;


end