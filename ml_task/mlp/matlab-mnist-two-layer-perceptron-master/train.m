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
epochs = 1000;

% Initialize experimental values
nExperiments = 50;
validationParameters.activationFunction = activationFunction;
validationParameters.testSet = inputValuesTest;
validationParameters.testLabels = labelsTest;

for run = 1:nExperiments
  fprintf('Experiment nr %d with %d hidden units.\n',...
    run, numberOfHiddenUnits);
   
  fprintf('Learning rate: %d.\n', learningRate);
  tic;
  [hiddenWeights, outputWeights, trainError(run,:), testError(run,:)] =...
    trainStochasticSquaredErrorTwoLayerPerceptron(activationFunction,...
    dActivationFunction, numberOfHiddenUnits, inputValuesTraining, targetValues,...
    epochs, batchSize, learningRate, validationParameters);
  duration(run) = toc;
  display(['Duration run ' int2str(run) ': ' int2str(duration)]);
  % Choose decision rule.
  fprintf('Validation:\n');

  validationParameters.hiddenWeights = hiddenWeights;
  validationParameters.outputWeights = outputWeights;
 
  validationParameters.inputValues = validationParameters.testSet;
  validationParameters.labels = validationParameters.testLabels;  
  
  [correctlyClassified(run), classificationErrors(run)] =...
    validateTwoLayerPerceptron(validationParameters);
end

%% Analysis
meanCorrectlyClassified = mean(correctlyClassified);
meanClassificationErrors = mean(classificationErrors);
meanTrainError = mean(trainError,1);
meanTestError = mean(testError,1);
minClassificationErrors = min(classificationErrors);
maxCorrectlyClassified = max(correctlyClassified);


%% Results
figure(1); clf; hold on;
plot(meanTrainError);
plot(meanTestError);
ylabel('Mean Squared Error');
xlabel('Epochs');
title('Mean Error Progression');
grid on;

figure(2); clf; hold on;
pie([meanClassificationErrors, meanCorrectlyClassified],[0,1]);
legend('Classification Errors', 'Correct Classifications','location','southeast');
title('Mean Accuracy');
set(gca,'visible','off');
grid on;

display(meanCorrectlyClassified/10000);
display(meanClassificationErrors/10000);
display(minClassificationErrors/10000);
display(maxCorrectlyClassified/10000);

[cc, ce, cMat, out ] =...
    validateTwoLayerPerceptron(validationParameters);
  
figure(3); clf; hold on;
pcolor(cMat);
colormap(summer);
colorbar;
xlabel('Real Digits');
ylabel('Classified Digits');
title('Confusion Map');

display(cMat);
nDigitAppearance = sum(cMat,1);
for i = 1:size(cMat,2)
  relativeCMat(:,i) = cMat(:,i) ./ nDigitAppearance(i);
end
display(relativeCMat);
figure(4); clf; hold on;
pcolor(relativeCMat);
colormap(summer);
colorbar;
xlabel('Real Digits');
ylabel('Classified Digits');
title('Relative Confusion Map');

logCMat = log(cMat);
display(logCMat);

figure(5); clf; hold on;
pcolor(logCMat);
colormap(summer);
colorbar;
xlabel('Real Digits');
ylabel('Classified Digits');
title('Logarithmic Confusion Map');

imshow(relativeCMat, [], 'InitialMagnification', 1600);
colorbar;
axis on;
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')

save trainingResults;


