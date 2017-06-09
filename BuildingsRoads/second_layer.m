function [new_D, new_X_train, new_X_test] = second_layer(X_train, X_test, params)
    disp('---------------------Starting the Second Layer-----------------');
    original_scale = params.numscales;
    params.numscales = 1;
    
    VsR = [];
    VsG = [];
    VsB = [];
    
    [~,~,V] = svds(X_train'*X_train,3);
    X_train = X_train*V;
    clear V;
    for i=1:params.range
        m = params.upsample;
        currentimage = reshape(X_train(1+(i-1)*m(1)*m(2):i*m(1)*m(2),:), m(1),m(2),params.rfSize(3));
        pyr = pyramid(currentimage, params);
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        
        if(params.rfSize(3)>1)
            VsR = [VsR; pyr(1:params.numscales, :)];
            VsG = [VsG; pyr(params.numscales+1:params.numscales*2, :)];
            VsB = [VsB; pyr(params.numscales*2+1:end, :)];
        end
        
        %imshow(pyr{1});
        %pause
        clear currentimage;
        clear pyr;
    end
    
    images = [VsR; VsG; VsB];
    clear VsR VsG VsB;
    clear X_train;
    % Extract Patches from the Gaussian Pyramid
    patches = extract_patches_building(images, params);

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
    % This part is for RGB Images
    disp('Extracting first module feature maps...')
    L= extract_features_modalities(images, D, params);
    disp(sprintf('Time Spent on Encoding in minutes= %f', toc/60));
    clear images;
    
    %Upsample all feature maps
    disp('Upsampling feature maps...')
    L = upsample(L, params.numscales, params.upsample);
    disp(sprintf('Time Spent on upsampling in minutes= %f', toc/60));
    % Shaping features for classification
    disp('Computing pixel-level features...')
    new_X_train = [];
    for i=1:size(L,1)
        new_X_train = [new_X_train; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end
    clear L;
    
    %%Test data
    VsR = [];
    VsG = [];
    VsB = [];
    [~,~,V] = svds(X_test,3);
    X_test = X_test*V;
    clear V;

    for i=1:params.test_range
        m = params.upsample;
        currentimage = reshape(X_test(1+(i-1)*m(1)*m(2):i*m(1)*m(2),:), m(1),m(2),params.rfSize(3));
        pyr = pyramid(currentimage, params);
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        
        if(params.rfSize(3)>1)
            VsR = [VsR; pyr(1:params.numscales, :)];
            VsG = [VsG; pyr(params.numscales+1:params.numscales*2, :)];
            VsB = [VsB; pyr(params.numscales*2+1:end, :)];
        end
        
        %imshow(pyr{1});
        %pause
        clear currentimage;
        clear pyr;
    end
    
    images = [VsR; VsG; VsB];
    clear VsR VsG VsB;
    clear X_test;
    
    % Encoding for RGB Images
    disp('Extracting first module feature maps...')
    L= extract_features_modalities(images, D, params);
    
     % Upsample all feature maps
    disp('Upsampling feature maps...')
    params.upsample = [size(L{1}, 1) size(L{1}, 2)];
    L = upsample(L, params.numscales, params.upsample);

    % Compute features for classification
    disp('Computing pixel-level features...')
    new_X_test = [];
   
%     for i=1:size(L,1)
%         X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.nfeats)];
%     end
    for i=1:size(L,1)
        new_X_test = [new_X_test; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end
        
    new_D = D;
    
    params.numscales = original_scale;    
end
