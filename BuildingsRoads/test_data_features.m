%%Reads data in the test directory, extract its features and lables for
%%evaluation.
function [X, labels] = test_data_features(D, params)
    % Prepocessing
    [patches, images, labels] = preprocess(params, params.testdatadir, params.testgrounddir, 1, 1);
    
    %Learning features for each pixel of each picture in the pyramid
    % Compute first module feature maps on slices with annotations

    if(params.rfSize(3)==1)
        % This part is for GrayScale Images
        disp('Extracting first module feature maps...')
        L = extract_features_building(images, D, params);
    else
        % This part is for RGB Images
        disp('Extracting first module feature maps...')
        L= extract_features_modalities(images, D, params);
    end
    
    % Upsample all feature maps
    disp('Upsampling feature maps...')
    params.upsample = [size(L{1}, 1) size(L{1}, 2)];
    L = upsample(L, params.numscales, params.upsample);

    % Compute features for classification
    disp('Computing pixel-level features...')
    X = [];
   
%     for i=1:size(L,1)
%         X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.nfeats)];
%     end
    for i=1:size(L,1)
        X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end
    labels = reshape(labels, size(labels,1)*size(labels,2)*size(labels,3),1);
end
