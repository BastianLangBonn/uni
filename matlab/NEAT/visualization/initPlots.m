%% Initialize all plots
runFigure = figure;

%% Optimization

% Fitness
fitGraph = subplot(2,2,1);
fitMean = plot([1:gen],mean(fit),'k-','LineWidth',2);
fitTop = jbfill([1:gen],max(fit),median(fit),'g','k',1,0.2);
fitBot = jbfill([1:gen],median(fit),min(fit),'b','k',1,0.2);

xlabel('Generation');ylabel('Fitness');
title('Fitness of Population','FontSize',12);

% Fitness Components
componentGraph = subplot(2,2,3);

%% Pole Balancing
if strcmp(func2str(p.fitFun), 'twoPole_test')
    stepMean = plot([1:gen],mean(steps),'k-','LineWidth',2);
    stepTop = jbfill([1:gen],max(steps),median(steps),'g','k',1,0.2);
    stepBot = jbfill([1:gen],median(steps),min(steps),'b','k',1,0.2);
    title('Time Steps completed');
else
    if p.recurrent == false;
        plotNet(elite(end));
    end
end

%% Diversity

% Species Distribution
speciesDistributionGraph = subplot(9,2,[16 18]);
for i=1:length(species)
    sdist(i) = length(species{i}.members);
end
specPie = pie(sdist);
title('Species Distribution','FontSize',12);

%% Complexity

% Number of Nodes
nodeGraph = subplot(10,2,[8 10]);
jbfill([1:gen],max(nodes),median(nodes),'g','k',1,0.2);
jbfill([1:gen],median(nodes),min(nodes),'b','k',1,0.2);
set(nodeGraph,'XLim',[2,gen])
xlabel('');ylabel('Nodes');

% Number of Connections
connectionGraph = subplot(10,2,[12 14]);
jbfill([1:gen],max(conns),median(conns),'g','k',1,0.2);
jbfill([1:gen],median(conns),min(conns),'b','k',1,0.2);
set(connectionGraph,'XLim',[2,gen])
xlabel('Generation');ylabel('Connections');

% Computation Time of Each Algorithm Component
compTimeGraph = subplot(3,2,2);
adj_express_time = eval_time + express_time;
adj_speciate_time = adj_express_time + speciate_time;
adj_recom_time = adj_speciate_time + recom_time;

jbfill([1:gen],adj_recom_time,adj_speciate_time,    'r','k',0,0.2);
jbfill([1:gen],adj_speciate_time,adj_express_time,  'g','k',1,0.2);
jbfill([1:gen],adj_express_time,eval_time,          'b','k',1,0.2);
jbfill([1:gen],eval_time,zeros(1,gen),              'k','k',1,0.5);
legend('Recombination','Speciation','Expression','Evaluation','Location','NorthWest')
set(compTimeGraph,'XLim',[2,gen])
xlabel('');ylabel('Seconds');
title('Computation Time','FontSize',12);
