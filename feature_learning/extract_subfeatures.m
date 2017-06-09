function XC = extract_subfeatures(X, D, im, params)
% Step the feature extractor D across the image X
% and apply it to sub-patches
    
    % Parameters
    rfSize = params.rfSize;
    regSize = params.regSize;
    alpha = params.alpha;
    regSize(1:2) = [size(im, 1) size(im, 2)];
    
    % Initalizations
    k = size(D.codes, 1);
    prows = regSize(1) - rfSize(1) + 1;
    pcols = regSize(2) - rfSize(2) + 1;
    r = rfSize(1) * rfSize(2) * rfSize(3);
    f = k * prows * pcols;
    XC = zeros(size(X, 1), f);
    
    % Main loop
    for i = 1:size(X, 1)
        
        % Extract overlapping sub-patches into rows of 'patches'
        ims = regSize(1) * regSize(2); 
        patches = [];
        for j = 1:regSize(3)
            patches = [patches; im2col(reshape(X(i,(j-1)*ims+1:j*ims), [regSize(1) regSize(2)]), [rfSize(1) rfSize(2)])];
        end
        patches = patches'; % each row is a patch on the original image
    
        % Contrast normalization
        patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2) + 10));
        
        patches = bsxfun(@minus, patches, D.mean);
        
        % Activation
        xc = patches * D.codes'; % # of patches by k(# of features)
        
        % Save Features
        XC(i,:) = xc(:)';
    end

end

