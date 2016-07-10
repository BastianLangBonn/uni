%% Update plots
%
%

if ~mod(gen,p.display_fitness)
    subplot(fitGraph);
    XData = [1:gen];
    Xvertices = [XData,fliplr(XData)]';
    maxFit = max(fit);
    medianFit = median(fit);
    minFit = min(fit);
    
    newTopVerts = [Xvertices, [maxFit, fliplr(medianFit)]'];
    newBotVerts = [Xvertices, [medianFit,fliplr(minFit)]'];
    
    set(fitMean,'XData',[1:gen]);
    set(fitMean,'YData',mean(fit));
    set(fitTop,'XData',Xvertices);
    set(fitTop,'Vertices',newTopVerts);  
    set(fitBot,'XData',Xvertices);
    set(fitBot,'Vertices', newBotVerts);
    
    refreshdata(fitGraph);
    drawnow;
    
end

% Plot Performance Component
if ~mod(gen,p.display_component)
subplot(componentGraph);
%% Double Pole Balancing
if strcmp(func2str(p.fitFun), 'twoPole_test')
    maxSteps = max(steps);
    medianSteps = median(steps);
    meanSteps = mean(steps);
    minSteps = min(steps);
    
    XData = [1:gen];
    Xvertices = [XData,fliplr(XData)]';
    newTopVerts = [Xvertices, [maxSteps, fliplr(medianSteps)]'];
    newBotVerts = [Xvertices, [medianSteps,fliplr(minSteps)]'];
    
    set(stepMean,'XData',[1:gen]);
    set(stepMean,'YData',mean(steps));
    set(stepTop,'XData',Xvertices);
    set(stepTop,'Vertices',newTopVerts);
    set(stepBot,'XData',Xvertices);
    set(stepBot,'Vertices', newBotVerts);
    
    refreshdata(componentGraph);
    drawnow;    
else
    if p.recurrent == false;
        plotNet(elite(end));
    end
end

end

% Plot Species
if ~mod(gen,p.display_speciesDist)
    subplot(speciesDistributionGraph);
    for i=1:length(species)
        sdist(i) = length(species{i}.members);
    end
    specPie = pie(sdist);

end

% Plot Complexity
if ~mod(gen,p.display_complexity)
    % Computation Time
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

% Nodes
nodeGraph = subplot(10,2,[8 10]);
%plot([1:gen],median(nodes),'k--','LineWidth',2);
%title('Nodes','FontSize',12);
%legend('Median Number of Nodes','Location','NorthWest')
jbfill([1:gen],max(nodes),median(nodes),'g','k',1,0.2);
jbfill([1:gen],median(nodes),min(nodes),'b','k',1,0.2);
set(nodeGraph,'XLim',[2,gen])
xlabel('');ylabel('Nodes');

%Connections
connectionGraph = subplot(10,2,[12 14]);
%plot([1:gen],median(conns),'k--','LineWidth',2);
%title('Connections','FontSize',12);
%legend('Median Number of Connections','Location','NorthWest')
jbfill([1:gen],max(conns),median(conns),'g','k',1,0.2);
jbfill([1:gen],median(conns),min(conns),'b','k',1,0.2);
set(connectionGraph,'XLim',[2,gen])
xlabel('Generation');ylabel('Connections');
    

end


