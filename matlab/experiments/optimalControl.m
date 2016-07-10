addpath(genpath('../Utilities'),genpath('../NEAT'),genpath('../ANN'));
runs = 10;
experiment_folder = datestr(now,30);
mkdir(experiment_folder);
elite = 0;
for curRun=1:runs
    clearvars -except runs experiment_folder curRun
    NEAT;
    [fitness, time, energy, power, speed, command] = evaluateOnTrack(elite(end), p);
    power(:,end+1) = power(:,end);
    tour = [time',power',speed',command'];

    csvwrite(strcat(experiment_folder,'/track',num2str(curRun),'.csv'),[1:length(p.track);p.track]);
    csvwrite(strcat(experiment_folder,'/tour',num2str(curRun),'.csv'),tour);
end


%example;
%distView;