function xc = encoder(patches, D, params)
    
    if (strcmp(params.encoder, 'omp'))
        [m, n] = size(patches);
        omp_k = params.omp_k;
        parfor i=1:m
            xc(i,:) = ompK(omp_k, patches(i,:)', D.codes);
        end
    elseif strcmp(params.encoder, 'dtx')
        xc = patches * D.codes';
    elseif (strcmp(params.encoder, 'softThresh'))
        xc = patches * D.codes'; % # of patches by k(# of features)
        %soft thresholding. there are other possibilities to implement it.
        %Eg. put all the negative numbers to zero.
        %xc = sign(xc).*max(abs(xc) - params.alpha, 0);
        xc = max(xc, 0); % Clear all the negative values
    elseif (strcmp(params.encoder, 'sc'))%sparse encoding
        load pars.mat
        xc = sparse_encoding_ML((D.codes)', patches', pars);
        xc = xc';
    end
end