% Script for setting the parameters
%--------------------------------------------------------------------------


%% Add current folder to the top of the search path
% Do not change
addpath(genpath('.'))
% -------------

%% Set up parameters
% Do not change
params.layer = 1;
params.alpha = 0;
params.D_iter = 100;


%--------------------------------------------------------------------------
% Upsampling size. Should be the x,y dimension of the volumes
params.upsample = [1500 1500];

% Number of scales
params.numscales = 3;

% Receptive field size e.g. 9x9
% Assume single modality to simplify

params.rfSize= [9 9 3];

% size of region?
params.regSize = [params.upsample(1) + params.rfSize(1) - 1 params.upsample(2) + params.rfSize(2) - 1 1];

% # of total pixels / # of lesion pixels
params.ratio = 15; % Ask Vincent about that parameter

% Number of patches to train dictionary
params.npatches = 100000;

% Number of features per scale. Total # of features: nfeats * numscales
params.nfeats = 32;


%--------------------------------------------------------------------------
%Type of encoder and parametes 
params.encoder = 'omp'; % omp, softThresh,sc(sparse coding), dtx is just D'x

% K for ompK algorithm
params.omp_k = 4;

%Threshold alpha for soft thresholding in encoding
params.alpha = 0.01;


%--------------------------------------------------------------------------
%Classification setup
%Type of the classifier
params.classifier = 'RF'; % logistic_reg, svm, RF
%number of trees if RF is being used 
params.numTrees = 50; 
params.cost= [0 1; 1 0];
params.npredictors= 50;

%--------------------------------------------------------------------------
%Train data directory
basedir = '/usr/data/BuildingDetectionML/';%'/home/mennatullah/Datasets/BuildingDetectionML/';
params.scansdir = strcat(basedir, 'training/input/');
params.annotdir = strcat(basedir, 'training/target/');
params.range = 1;
params.test_range = 1;
%Test data directory
params.testdatadir = strcat(basedir, 'TestData/');
params.testgrounddir = strcat(basedir, 'TestDataGroundTruht/');

%--------------------------------------------------------------------------
params.dictionary_type= 'omp'; % KSVD, omp, sc

disp ('parameters that are being used');
params

