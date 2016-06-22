%% Initialize Parameters

nInput = 784;
nOutput = 50;
nHidden = 10;

nParameters = nInput * nHidden + nHidden * nOutput + nHidden + nOutput;
parameters.images = importdata('train.csv', ',', 1);
parameters.images = parameters.images.data(:,:);
parameters.images = parameters.images / 255;
parameters.trials = 30;
evaluationFunction = 'evaluateNet';
parameters.topology = [nInput nHidden nOutput];

result = cmaes(evaluationFunction, nParameters, parameters);