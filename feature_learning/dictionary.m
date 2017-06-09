function D = dictionary(patches, params)
% Train the dictionary with orthogonal matching pursuit(OMP)
% Parameters:
%   patches:    image patches
%   params:     hyperparameters
% Return:
%   D:          dictionary

    % Parameters
    nfeats = params.nfeats;

    % Patch-wise mean substraction
    % Each row of 'patches' is the receptive field of each patch
    D.mean = mean(patches); % mean of all patches on each pixel in the receptive field
    nX = bsxfun(@minus, patches, D.mean);

    % Train dictionary
    disp('Training Dictionary...');
    D.codes = run_omp1(nX, nfeats, params.D_iter);
end

