function [D,X,labels] = run_buildings(params)
% Function for learning features and extracting labels
    
    %% Load images, annotations and pre-process
    %patches: number_of_patches by patch_width*patch_height. Preporcessed.
    tic;
    disp('Loading and pre-processing data...')
    [patches, images, labels] = preprocess(params, params.scansdir, params.annotdir, params.range, 0);
    disp(sprintf('Time Spent on Preprocessing in minutes= %f', toc/60));
    
    %% Train dictionary
    %To change the method for dictionary learning, please see inside
    %dictionary function. By default, uses omp-1.
    tic;
    if (strcmp(params.dictionary_type, 'KSVD'))
        D = dictionary_ksvd(patches, params);
    elseif (strcmp(params.dictionary_type, 'omp'))
        D = dictionary(patches, params);
    elseif (strcmp(params.dictionary_type, 'sc'))
        D = dictionary_sc(patches, params);
    end
    disp(sprintf('Time Spent on learning the dictionary in minutes= %f', toc/60));
    
    %Learning features for each pixel of each picture in the pyramid
    %Compute first module feature maps on slices with annotations
    tic;
    if(params.rfSize(3)==1)
        % This part is for GrayScale Images
        disp('Extracting first module feature maps...')
        L = extract_features_building(images, D, params);
    else
        % This part is for RGB Images
        disp('Extracting first module feature maps...')
        L= extract_features_modalities(images, D, params);
    end
    disp(sprintf('Time Spent on Encoding in minutes= %f', toc/60));
    clear images;
    
    tic;
    %Upsample all feature maps
    disp('Upsampling feature maps...')
    L = upsample(L, params.numscales, params.upsample);
    disp(sprintf('Time Spent on upsampling in minutes= %f', toc/60));
    % Shaping features for classification
    disp('Computing pixel-level features...')
    X = [];
    for i=1:size(L,1)
        X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end
    labels = reshape(labels, size(labels,1)*size(labels,2)*size(labels,3),1);
    
   %X= [];
   %labels=[];
end
