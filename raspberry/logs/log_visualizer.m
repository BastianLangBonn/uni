clear;
trackFiles = dir('./log_copy/processed*.txt');

for file = 1:length(trackFiles)
    data = csvread(sprintf('./log_copy/%s',trackFiles(file).name));
%     trackData = importdata(sprintf('./tracks/%s',trackName), ';', 0);

    maxima{file} = max(data,[],1);
    figure(file);clf;
    semilogy(maxima{file});

end