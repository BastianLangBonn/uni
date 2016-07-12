addpath(genpath('../Utilities'),genpath('../NEAT'),genpath('../ANN'));
runs = 2;
experiment_folder = datestr(now,30);
mkdir(experiment_folder);
elite = 0;


%% Experimentes
for curRun=1:runs
    clearvars -except runs experiment_folder curRun
    
    NEAT;
    [fitness, time, location, speed, energy, command] = evaluateOnTrack(elite(end), p);
    
    tour = [time',location',energy',speed',command'];

    csvwrite(strcat(experiment_folder,'/track',num2str(curRun),'.csv'),[1:length(p.track.distance);p.track.elevation]);
    csvwrite(strcat(experiment_folder,'/tour',num2str(curRun),'.csv'),tour);
    csvwrite(strcat(experiment_folder,'/aMat',num2str(curRun),'.csv'),elite(end).pheno.wMat);
    csvwrite(strcat(experiment_folder,'/wMat',num2str(curRun),'.csv'),elite(end).pheno.aMat);
end


%example;
%distView;