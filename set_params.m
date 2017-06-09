% Script for setting the parameters for MS lesions
%--------------------------------------------------------------------------


%% Add current folder to the top of the search path
% Do not change
addpath(genpath('.'))
% -------------

%% Set up parameters
% Do not change
params.layer = 1;
params.alpha = 0;
params.D_iter = 50;
% -------------

% Upsampling size. Should be the x,y dimension of the volumes
params.upsample = [512 512];

% Number of scales
params.numscales = 6;

% Receptive field size e.g. 5x5
% Assume single modality to simplify
params.rfSize = [5 5 1];
% size of region?
params.regSize = [params.upsample(1) + params.rfSize(1) - 1 params.upsample(2) + params.rfSize(2) - 1 1];
% # of total pixels / # of lesion pixels
params.ratio = 10;
% Number of patches to train dictionary
params.npatches = 100000;

% Number of features per scale. Total # of features: nfeats * numscales
params.nfeats = 32;

% Dictionary learning algorithm
params.dictionary_type= 'omp'; % KSVD, omp, sc

% Encoder parameters
params.encoder = 'softThresh'; % omp, softThresh,sc(sparse coding), dtx is just D'x
% K for ompK algorithm
params.omp_k = 4;
%Threshold alpha for soft thresholding in encoding
params.alpha = 0.01;


% Set data location for MS lesions
basedir = '/usr/data/medical_images/MSlesion08/';
% Training data
params.scansdir = strcat(basedir, 'skull_stripped_UNC_train_Case');
params.annotdir = strcat(basedir, 'skull_stripped_UNC_train_Case');
% Test data
params.testdatadir = strcat(basedir, 'skull_stripped_UNC_test_Case');
% Number of volumes to load
params.ntv = 1;
% Test volume index
params.test_vol = 10;
%%%%%%%%%%%%%%%%%%%

