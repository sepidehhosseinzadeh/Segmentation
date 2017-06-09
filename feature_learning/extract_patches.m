function patches = extract_patches(V, params)
% Take a list of images and return the patches
%   Parameters:
%       V:      the list of scaled images
%       params: dictionary of parameters
%   Return:
%       patches: normalized patches from the images

    % Parameters
    rfSize = params.rfSize;
    npatches = params.npatches;

    % Main loop
    patches = zeros(npatches, rfSize(1) * rfSize(2) * rfSize(3));
    disp('Extracting patches...');

    for i=1:npatches

        patch = double(V{mod(i-1,length(V))+1}); % a scaled image in the pyramid
        patch = squeeze(patch); % remove sington dimensions
        [nrows, ncols, nmaps] = size(patch);

        if (mod(i,10000) == 0) fprintf('Extracting patch: %d / %d\n', i, npatches); end

        % Extract random block
        r = random('unid', nrows - rfSize(1) + 1);
        c = random('unid', ncols - rfSize(2) + 1);
        patch = patch(r:r+rfSize(1)-1,c:c+rfSize(2)-1,:);
        patches(i,:) = patch(:)';
    end

    disp('Contrast normalization...');
    % +10 offset was added to the variance to avoid dividing by zero and also supressing noise
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,0,2) + 10));

end

