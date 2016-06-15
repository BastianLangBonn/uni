function [ error ] = evaluateMultipleTracks( weightMatrix, data )
%EVALUATEMULTIPLETRACKS Summary of this function goes here
%   Detailed explanation goes here
  for sample = 1:length(data)
    input = [data(sample).command' data(sample).currentVelocity'...
      data(sample).slope'];
    input = normalizeInputData(input);
    expectedOutput = [data(sample).resultingVelocity' data(sample).energy'];
    expectedOutput = normalizeOutputData(expectedOutput);
    error(sample) = evaluateTrack(weightMatrix, input, expectedOutput);
  end
  error = mean(error.^2);

end

