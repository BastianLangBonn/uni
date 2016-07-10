%% gatherData - Compiles and records data from current generations

for i=1:length(pop)
   fit(i,gen) = pop(i).fitness;
   spec(i,gen) = pop(i).species;
   nodes(i,gen) = size(pop(i).nodes,2);
   conns(i,gen) = size(pop(i).conns,2);   
   
   % Additional Measures
   if strcmp(func2str(p.fitFun), 'twoPole_test')
      steps(i,gen) = pop(i).steps;
   end
   
end

best_index = find(fit(:,gen) == max(fit(:,gen)) );
elite(gen) = pop(best_index(1));


