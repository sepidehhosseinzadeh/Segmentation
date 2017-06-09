function XC = extract_subfeatures_lesions(X, D, dim, params)
% Step the feature extractor D across the image X
% and apply it to sub-patches
    
    % Parameters
    rfSize = params.rfSize;
    regSize = params.regSize;
    regSize(1:2) = [dim(1) dim(2)];
    
    % Initalizations
    k = size(D.codes, 1);
    prows = regSize(1) - rfSize(1) + 1;
    pcols = regSize(2) - rfSize(2) + 1;
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
        
        % Remove the patches that are all zero
%         ind = max(patches) ~= 0;
%         patches = patches(:, ind)'; 
%         f_new = size(patches, 2);
%         XC = zeros(size(X, 1), f_new);
    
        % Contrast normalization
        patches = patches'; % each row is a patch on the original image
        patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2) + 10));
        
        patches = bsxfun(@minus, patches, D.mean);
        
        % Encoding
        xc = encoder(patches, D, params);

        % Save Features
        XC(i,:) = xc(:)';
    end

end

