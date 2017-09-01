function CaImaging(fileLoc)
%% Segmentation and tracking of a calcium imaged culture.
% Initially written by Jakub Tomek, edited by Liana Engie 
% Last updated: Sept 1 2017
%
% This function takes uses singleWaveProcessingCaStack. Reads a .tif file
% that's been converted into a series of PNG images. Uses input now. Note:
% singleWaveProcessingCaStack reads only a subregion of the stack in order
% to get rid of border effects at the edge of the dish - this removes
% artefacts and improves computational speed.

clear

%%fileName = 'Experiment-440-stab_diff_medfilt/';
pathToFolder = 'data/';
%pathToFolder = '';
outFolder = 'out/';

frameRate = 1; % in frames per second
pixelMicroMeters = 52; % side length of a pixel in micrometers 
mimps = 400; % maximum allowed CV in mm/s

parameters = HeartWaveProcessor.getDefaultParametersContinuous(frameRate, pixelMicroMeters, mimps);
parameters.plottingAmplification = 2;
parameters.smoothingParameter = 11;
parameters.largerSmoothingParameter = 50;
parameters.activityThreshold = 3; % when a trace has at least this many times larger value after smoothing with smoothingParameter than with largerSmoothingParameter, it's considered active
parameters.minAPD = 2;
parameters.maxAPD = 30;
parameters.minDensity = 6;
parameters.maxSpeed = 20;

parameters.isDebug = 0; % set to 1 if annotated pixel traces are to be stored in tmp

parameters.binningSize = 6;
parameters.extension = '.png';
parameters.trackingAlgorithm = 'MCMF';
% Since no SNR filtering is performed, the contour drawing in figure 1 does
% not show any border, as each pixel belongs to some cell.
tic
singleWaveProcessing(fileLoc, pathToFolder, outFolder, parameters);
toc
save
% %% Feature extraction
load
features = FeatureExtractor.featureExtraction(fileLoc,outFolder);

%% Plotting
mkdir plots


figure(3); clf; imagesc(features.mapAPD); colorbar; title('Map of APD'); saveas(gcf, 'plots/mapAPD.png');

figure(4); clf; imagesc(features.mapCV); colorbar; title('Map of CV'); saveas(gcf, 'plots/mapCV.png');

figure(5); clf; imagesc(features.mapMedianInterspike); colorbar; title('Map of median interspike duration (ms)');  saveas(gcf, 'plots/medianInterspike.png');

% Getting a vector field (not smoothed, just plotting all the arrows that happened)
processedData = load([outFolder fileLoc(1:end-1) '.mat']);
arrowInfo = processedData.arrowInfo;
allArrows = cell2mat(arrowInfo);
allArrows = allArrows(:, 2:5); % getting just xyuv.
dummyMask = zeros(size(processedData.maskAvgIm));
figure(6);
imshow(dummyMask);
hold on
quiver(allArrows(:, 2), allArrows(:, 1), allArrows(:, 4), allArrows(:, 3));
hold off
 saveas(gcf, 'plots/vectorField.fig');
 
end