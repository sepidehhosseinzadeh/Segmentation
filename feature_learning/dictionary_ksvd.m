function D = dictionary_ksvd(patches, params)
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
    params_ksvd.data = nX';
    params_ksvd.Tdata = 1;
    params_ksvd.dictsize = params.nfeats;
    params_ksvd.iternum = params.D_iter;
    params_ksvd.memusage = 'high';
    %params.exact= 1;

    [Dksvd,g,err] = ksvd(params_ksvd,'');
    D.codes = Dksvd';
end
