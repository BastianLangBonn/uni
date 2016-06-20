%% 
clear;
% Load MNIST.
inputValuesTraining = loadMNISTImages('train-images.idx3-ubyte');
labelsTraining = loadMNISTLabels('train-labels.idx1-ubyte');

% Load validation set.
inputValuesTest = loadMNISTImages('t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('t10k-labels.idx1-ubyte');

% Transform the labels to correct target values.
targetValues = 0.*ones(10, size(labelsTraining, 1));
for n = 1: size(labelsTraining, 1)
    targetValues(labelsTraining(n) + 1, n) = 1;
end;

% Choose form of MLP:
numberOfHiddenUnits = 700;

% Choose appropriate parameters.
learningRate = 0.1;

% Choose activation function.
activationFunction = @logisticSigmoid;
dActivationFunction = @dLogisticSigmoid;

% Choose batch size and epochs. Remember there are 60k input values.
batchSize = 100;
epochs = 500;

% Initialize experimental values
nExperiments = 50;

for run = 1:nExperiments
  fprintf('Experiment nr %d with %d hidden units.\n',...
    run, numberOfHiddenUnits);
  fprintf('Learning rate: %d.\n', learningRate);
  [hiddenWeights, outputWeights, error(run,:)] =...
    trainStochasticSquaredErrorTwoLayerPerceptron(activationFunction,...
    dActivationFunction, numberOfHiddenUnits, inputValuesTraining, targetValues,...
    epochs, batchSize, learningRate);

  % Choose decision rule.
  fprintf('Validation:\n');

  [correctlyClassified(run), classificationErrors(run)] =...
    validateTwoLayerPerceptron(activationFunction, hiddenWeights,...
    outputWeights, inputValuesTest, labelsTest);
end

%% Analysis
meanCorrectlyClassified = mean(correctlyClassified);
meanClassificationErrors = mean(classificationErrors);
meanError = mean(error,1);
minClassificationErrors = min(classificationErrors);
maxCorrectlyClassified = max(correctlyClassified);


%% Results
figure(1); clf; hold on;
plot(meanError);
ylabel('Mean Squared Error');
xlabel('Epochs');
title('Mean Error Progression');
grid on;

figure(2); clf; hold on;
pie([meanClassificationErrors, meanCorrectlyClassified],[0,1]);
legend('Classification Errors', 'Correct Classifications','location','southeast');
title('Mean Accuracy');
grid on;

display(meanCorrectlyClassified/10000);
display(meanClassificationErrors/10000);
display(minClassificationErrors/10000);
display(maxCorrectlyClassified/10000);

[cc, ce, cMat, out ] =...
    validateTwoLayerPerceptron(activationFunction, hiddenWeights,...
    outputWeights, inputValuesTest, labelsTest);
  
figure(3); clf; hold on;
pcolor(cMat);
colormap(winter);
xlabel('Real Digits');
ylabel('Classified Digits');
title('Confusion Map');

display(cMat);

save trainingResults;


