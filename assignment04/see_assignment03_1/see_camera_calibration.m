% Auto-generated by cameraCalibrator app on 30-Oct-2015
%-------------------------------------------------------


% Define images to process
imageFileNames = {'./images/2015-10-30-152137.jpg',...
    './images/2015-10-30-152144.jpg',...
    './images/2015-10-30-152159.jpg',...
    './images/2015-10-30-152201.jpg',...
    './images/2015-10-30-152204.jpg',...
    './images/2015-10-30-152207.jpg',...
    './images/2015-10-30-152210.jpg',...
    './images/2015-10-30-152212.jpg',...
    './images/2015-10-30-152216.jpg',...
    './images/2015-10-30-152221.jpg',...
    './images/2015-10-30-152305.jpg',...
    './images/2015-10-30-152314.jpg',...
    './images/2015-10-30-152317.jpg',...
    './images/2015-10-30-152329.jpg',...
    './images/2015-10-30-152333.jpg',...
    './images/2015-10-30-152336.jpg',...
    './images/2015-10-30-152338.jpg',...
    './images/2015-10-30-152340.jpg',...
    './images/2015-10-30-152342.jpg',...
    './images/2015-10-30-152345.jpg',...
    './images/2015-10-30-154410.jpg',...
    './images/2015-10-30-154411.jpg',...
    './images/2015-10-30-154412.jpg',...
    './images/2015-10-30-154413.jpg',...
    './images/2015-10-30-154418 (1).jpg',...
    './images/2015-10-30-154418.jpg',...
    './images/2015-10-30-154419.jpg',...
    './images/2015-10-30-154420.jpg',...
    './images/2015-10-30-154423.jpg',...
    './images/2015-10-30-154424.jpg',...
    './images/2015-10-30-154425.jpg',...
    './images/2015-10-30-154429.jpg',...
    './images/2015-10-30-154432.jpg',...
    './images/2015-10-30-154433.jpg',...
    './images/2015-10-30-154434.jpg',...
    './images/2015-10-30-154435.jpg',...
    './images/2015-10-30-154436.jpg',...
    './images/2015-10-30-154437.jpg',...
    './images/2015-10-30-154439.jpg',...
    './images/2015-10-30-154442.jpg',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm');

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams, 'BarGraph');

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
originalImage = imread(imageFileNames{1});
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('SparseReconstructionExample')
