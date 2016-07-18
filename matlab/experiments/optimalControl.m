addpath(genpath('../Utilities'),genpath('../NEAT'),genpath('../ANN'));
runs = 50;
experiment_folder = datestr(now,30);
mkdir(experiment_folder);
elite = 0;

%% Experimentes
for curRun=1:runs
    clearvars -except runs experiment_folder curRun
    try
        NEAT;
    catch ME
        gen = gen -1;
        disp('restart');
        %continue;
    end
        
    p.isTraining = false;
    for i=1:length(elite)
        fitnessTraining(i) = elite(i).fitness;
        fitnessTest(i) = evaluateOnTrackSet(elite(i), p);
        
    end
    
    save(strcat(experiment_folder, '/vars', num2str(curRun), '.mat'));
%     saveas(runFigure,strcat(experiment_folder, '/progress', num2str(curRun), '.jpg'));
%     close all;
%     tour = [time',location',energy',speed',command'];
% 
%     csvwrite(strcat(experiment_folder,'/track',num2str(curRun),'.csv'),[1:length(p.track.distance);p.track.elevation]);
%     csvwrite(strcat(experiment_folder,'/tour',num2str(curRun),'.csv'),tour);
    csvwrite(strcat(experiment_folder,'/wMat',num2str(curRun),'.csv'),elite(end).pheno.wMat);
    csvwrite(strcat(experiment_folder,'/aMat',num2str(curRun),'.csv'),elite(end).pheno.aMat);
    csvwrite(strcat(experiment_folder,'/fitness',num2str(curRun),'.csv'),[fitnessTraining; fitnessTest]);
end


%example;
%distView;