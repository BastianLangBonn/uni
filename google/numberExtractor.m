function [ number ] = numberExtractor( filename )
%NUMBEREXTRACTOR Summary of this function goes here
%   Detailed explanation goes here
    inputFile = fopen(sprintf('%s.in',filename));
    nIterations = fscanf(inputFile,'%d', 1);
    outputFile = fopen(sprintf('%s.out',filename),'w');
    for i=1:nIterations
       line =  fscanf(inputFile,'%s',1); 
       fprintf(outputFile, 'case #%d: %s\n',i,decodeLine(line));       
    end

end

