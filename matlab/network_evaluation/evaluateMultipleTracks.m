function [ error ] = evaluateMultipleTracks( weightMatrix, tracks )
%EVALUATEMULTIPLETRACKS Extracts data from the given set and evaluates the
%given network on all of the tracks.

  error = zeros(1,length(tracks));
  for sample = 1:length(tracks) %gives the number of different samples
    error(sample) = evaluateTrack(weightMatrix, tracks(sample));
  end
  error = mean(error.^2);

end

