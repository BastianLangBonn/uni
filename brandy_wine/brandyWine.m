%% Rectangle ES Live example
function brandyWine
%% Set up Target Colors
figure(1); clf;hold off;
target = [0.5392    0.0209    0.2491];
subplot(3,3,5);
express(target);
title('Target')
childIds = [1:4 6:9];
nChild = numel(childIds);
nGenes = length(target);
nGenerations = 1000;

%% Initialize Population
children = rand(nChild,nGenes);

%% Begin Evolution
mutRate = 0.5;
%prompt = 'Which is closest? ';
%bestHist = [];
smallestDifference = zeros(nGenerations,1);
bestHist = zeros(nGenerations, nGenes);
for generation=1:nGenerations
    for iChild=1:nChild
        subplot(3,3,childIds(iChild));
        express(children(iChild,:))
        title(int2str(iChild));
    end
       
    % best = input(prompt);
    % reference = children(floor((nChild-1)/2)+1,:);
    difference = zeros(nChild,1);
    for iChild=1:nChild
        difference(iChild) = sqrt((children(iChild,1) - target(1,1))^2 +...
            (children(iChild,2) - target(1,2))^2 +...
            (children(iChild,3) - target(1,3))^2);
    end
    [smallestDifference(generation), best] = min(difference);
    %best = children(iBest,:);
    
    if best == 0;break;end
    
    mutation = mutRate*(randn(nChild,nGenes)-0.5);
    children = repmat(children(best,:),[nChild,1])+mutation;
    bestHist = [bestHist; children(best,:)];    
end

%% Plot Progress
figure(2); clf;
plot(target(1)*ones(size(bestHist,1)),'r--');hold on;
plot(target(2)*ones(size(bestHist,1)),'g--')
plot(target(3)*ones(size(bestHist,1)),'b--')
plot(bestHist(:,1),'r-')
plot(bestHist(:,2),'g-')
plot(bestHist(:,3),'b-');
xlabel('Generations');ylabel('RBG Values');title('Color Error');

figure(3);clf;hold on;
plot(smallestDifference);


end

%%
function express(genes)
cla
col = genes(1:3);
col(col>1) = 1; col(col<0) = 0;
pos = [0 0 2 2];    
hold off;
rectangle('Position',pos,'Curvature',[0 0],'FaceColor',col);
set(gca,'XTickLabel','','YTickLabel','');
axis([0 2 0 2]);
end

