function [D,X,labels] = run_mslesion(params)
% Function for learning features and extracting labels
% Input: params: hyperparams
% Output: 
% D: dictionary
% X: matrix of features for each labelled voxel
% labels: 1/2 labels for each datapoint in X

% Load volumes, annotations and pre-process
disp('Loading and pre-processing data...')
tic
if exist ('ms_inter_data.mat', 'file')~=2
    [patches, V, Vlist, I_mask, A] = preprocess_mslesion(params);
    fprintf('Time Spent on Preprocessing in minutes= %f\n', toc/60);
    save ms_inter_data.mat patches V Vlist I_mask A
else
    disp('Loading from ms_inter_data.mat');
    load ms_inter_data.mat
end

% Train dictionary
% To change the method for dictionary learning, please see inside
% dictionary function. By default, uses omp-1.
tic
if (strcmp(params.dictionary_type, 'KSVD'))
    D = dictionary_ksvd(patches, params);
elseif (strcmp(params.dictionary_type, 'omp'))
    D = dictionary(patches, params);
elseif (strcmp(params.dictionary_type, 'sc'))
    D = dictionary_sc(patches, params);
end
fprintf('Time Spent on learning the dictionary in minutes= %f\n', toc/60);

% Compute first module feature maps
tic
disp('Extracting first module feature maps...')
if exist ('ms_inter_feature.mat', 'file')~=2
    L = cell(params.ntv, 1);
    for i = 1:params.ntv
        % Example of L{i}
        % K>> size(L{1})
        % ans =
        %     60     1
        % K>> size(L{1}{1})
        % ans =
        %    512   512    32
        % K>> size(L{1}{2})
        % ans =
        %    256   256    32
        L{i} = extract_features_lesions(V{i}(Vlist{i}), D, params);  % Only extract features from slices with meaningful annotations
    end
    clear V;
    fprintf('Time Spent on Encoding in minutes= %f\n', toc/60);
    save ms_inter_feature.mat L -v7.3
else
    disp('Loading from ms_inter_feature.mat');
    load ms_inter_feature.mat
end

% Upsample all feature maps
tic
disp('Upsampling feature maps...')
if exist ('ms_inter_up_feature.mat', 'file')~=2
    for i = 1:params.ntv
        % Example of L{i}:
        %         K>> size(L{1})      
        %         ans =
        %         10     1
        %         K>> size(L{1}{1})
        %         ans =
        %         512   512   192
        %         K>> size(L{1}{2})
        %         ans =
        %         512   512   192
        L{i} = upsample(L{i}, params.numscales, params.upsample);
    end
    fprintf('Time Spent on upsampling in minutes= %f\n', toc/60);
    save ms_inter_up_feature.mat L -v7.3
else
    disp('Loading from ms_inter_up_feature.mat');
    load ms_inter_up_feature.mat
end

% Compute features for classification
tic
disp('Computing pixel-level features...')
X = []; labels = [];
for i = 1:params.ntv
    % Need to pass in the Image data, only convert the brain tissue
    slice_ind = Vlist{i}(params.numscales:params.numscales:end)/params.numscales;
    [tmp_feature, tmp_label] = convert_lesion(L{i}, I_mask{i}(:,:,slice_ind), A{i}(:,:,slice_ind), slice_ind, params);
    % Debug *********************
    %plot(1:length(tl), tl);
    %axis([0 length(tl) 0 3]);
    %title('voxel labels on 5 selected slices');
    %ylabel('label'); xlabel('voxel');
    % Debug End *****************
    X = [X; tmp_feature];
    labels = [labels; tmp_label];
end
fprintf('Time Spent on computing pixel-level features in minutes= %f\n', toc/60);
