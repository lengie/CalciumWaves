%%% CaWings.m
%%% 
%%% Input: n/a Output: n/a
%%% Author: Liana Engie
%%% Created: April 2017, last updated:
%%%
%%% Written to keep track of the work I'm doing to process videos of
%%% calcium in drosophila imaginal discs. Trying ccoffinn.

%userpath('C:/Users/engie.PROVOST/Dropbox/Computer/Science/CalciumWings');

w = 'Experiment-440-stab.tif';
test = 'Exp 524.tif';
test2 = 'Exp 440 diff.tif';
pathToFolder = '/';
outFolder = '';

frameRate = 1; % in frames per second
pixelMicroMeters = 1; %should be 1.08 % side length of a pixel in micrometers 
%Number of micrometres a wavefront is allowed to move per millisecond (or, mm/s))
%Previous research shows SIDICs moving around .4 microns/s
%ICWs in general travel between 15-20 microns/sec
mimps = 400; 

parameters = HeartWaveProcessor.getDefaultParametersContinuous(frameRate, pixelMicroMeters, mimps);
parameters.plottingAmplification = 8;
parameters.trackingAlgorithm = 'MCMF';

tic
singleWaveProcessingCaStack(w, pathToFolder, outFolder, parameters);
toc

singleWaveProcessingCaStack(test, pathToFolder, outFolder, parameters);