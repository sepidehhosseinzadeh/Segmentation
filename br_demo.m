% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all; clc;

if exist ('data.mat', 'file')~=2
    % Set hyperparameters and data location
    set_params_buildings;

    % Run the code for building and road datasets close allpreprocessing
    [D, X_train, labels_train] = run_buildings(params);
    %save('data_train_roads.mat', 'X_train', '-v7.3')
    
    % Extractig Features for the test dataset
    tic;
    disp ('extracting features of the test data');
    [X_test, labels_test] = test_data_features(D, params);
    %save('data_test_.mat', 'X_test', '-v7.3')
    %save data6Scales.mat D labels_train labels_test params
    fprintf('Time Spent on Extractig Features for the test dataset in minutes= %f\n', toc/60);
    
    %second layer
    if (params.layer == 2)
        [D, X_train, X_test] = second_layer(X_train, X_test,params);
    end
else
%     addpath(genpath('.')); % need to add it here in case it bypass set_params_buildings
%     %addpath /usr/work/ml_proj/GML_AdaBoost_Matlab_Toolbox_0.3/
%     load ~/BuildingDetectionML/data3Scales.mat
%     load ~/BuildingDetectionML/data_train3Scales.mat
%     %load /usr/work/ml_proj/mlprojKSVD/mlproj/data_test3Scales.mat
%     disp ('extracting features of the test data');
%     basedir = '~/BuildingDetectionML/';%'/home/mennatullah/Datasets/BuildingDetectionML/';
%     params.testdatadir = strcat(basedir, 'TestData/');
%     params.testgrounddir = strcat(basedir, 'TestDataGroundTruht/');
%     params.cost= [0 1; 10 0];
%     params.npredictors= 50;
%     params
%     [X_test, labels_test] = test_data_features(D, params);
end


%% Training the Classifier
disp('training the classifier');
tic;

%% Introducing Balanced Data
X_train1= X_train((labels_train==1), :);
labels_train1= labels_train(labels_train==1);

X_train2= X_train((labels_train==0), :);
labels_train2= labels_train(labels_train==0);

indices= randperm(size(X_train2, 1), 2*size(X_train1, 1));
X_train2= X_train2(indices, :);
labels_train2= labels_train2(indices);

X_train= [X_train1; X_train2];
labels_train= [labels_train1; labels_train2];

[model, prediction]=classification(labels_train, X_train, labels_test, X_test, params);
disp(sprintf('Time Spent on training the classifier in minutes= %f', toc/60));
%save('model_roads.mat', 'model', '-v7.3')

%Evaluation metrics
prediction= prediction(:, 2);
[acc, precision, recall, f1, jaccard, dice] = evaluationBuilding(prediction, labels_test)
%temp_visualize_results(prediction, labels_test);

save result_smallBuildings.mat prediction;

%% Visualize the dictionary
%visualize_dictionary_modalities(D, params)
