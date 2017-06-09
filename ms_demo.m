% Demo code for running on ms lession 08 data
%---------------------------------------

%% Clear up the workspace
clear; close all;

if exist ('ms_data.mat', 'file')~=2
    %% Set hyperparameters and data location
    set_params;

    %% Learn features and extract labels
    % D: learned dictionary of filters
    % X: matrix of features for each labelled voxel
    % labels: 0/1 labels for each sample in X
    [D, X, labels] = run_mslesion(params);
    % Save results to .mat file
    save ms_data.mat D X labels params
else
    disp('Loading from ms_data.mat');
    addpath(genpath('.'));
    load ms_data
end

% measure time
tic;
%% Train a classifier on X
% Logistic regression
% Applies n_folds cross validation
% model: the resulting model
% scaleparams: means and stds of X
if exist ('ms_classifier.mat', 'file')~=2
    n_folds = 10;
    [model, scaleparams] = learn_classifier(X, labels, n_folds);
    save ms_classifier.mat model scaleparams -v7.3
else
    disp('Loading from ms_classifier.mat');
    load ms_classifier
end

% Gather time
fprintf('Time Spent on classification in minutes= %f\n', toc/60);

%% Getting evaluation metrics
tic;
eval_stats = eval_metric_lesion(model, scaleparams, D, params);
fprintf('Time Spent on evaluation stats in minutes= %f\n', toc/60);

%% Testing and visulization
%volume_index = 1;
%test_and_visualize(volume_index, params, model, D, scaleparams);
