function patches = extract_patches_lesion(V, params, A)
% Take a list of images and return the patches
%   Parameters:
%       
%       V:      the list of scaled images
%       params: dictionary of parameters
%       A: Annotation 
%   Return:
%       patches: normalized patches from the images


    % Parameters
    rfSize = params.rfSize;
    npatches = params.npatches;

    % Main loop
    patches = zeros(npatches, rfSize(1) * rfSize(2) * rfSize(3));
    disp('Extracting patches...');
    
    %%
    disp('Extracting patches from the lesion part of the slices...');
    nLesionPatchs = 0;
    for i = 1:size(A,1)  % number of training volumes
        for k = 1:size(A{i},1) % loop through each slice
            tmp_slice = A{i}{k};
            [rs, cs] = find(tmp_slice);
            rs = rs(1:min(100, length(rs)));
            cs = cs(1:min(100, length(cs)));
            for j = 1:length(rs)
                s1 = rs(j); e1 = rs(j)+rfSize(1)-1;
                s2 = cs(j); e2 = cs(j)+rfSize(2)-1;
                if e1 < size(tmp_slice,1) && e2 < size(tmp_slice,2)
                    patch = tmp_slice(s1:e1,s2:e2);
                    % Debug, visualize the patch
%                     imshow(reshape(patch,[5 5]),[]);
%                     title(sprintf('patch %d', nLesionPatchs));
%                     pause;
                    % Debug END ****************
                    nLesionPatchs = nLesionPatchs + 1;
                    patches(nLesionPatchs,:) = patch(:)';
                end
            end
        end
    end
    
    % only keep up to npatches/2 lesion patches
    if nLesionPatchs > floor(npatches/2)
        rand_idx_lesions = randperm(nLesionPatchs,floor(npatches/2));
        patches(setdiff(1:nLesionPatchs, rand_idx_lesions), :)=[];
    end
    %%
    
    

    for i=nLesionPatchs+1:npatches

        patch = double(V{mod(i-1,length(V))+1}); % a scaled image in the pyramid
        patch = squeeze(patch); % remove sington dimensions
        [nrows, ncols, nmaps] = size(patch);

        if (mod(i,10000) == 0) fprintf('Extracting patch: %d / %d\n', i, npatches); end

        % Extract random block
        not_done = true;
        while not_done
            r = random('unid', nrows - rfSize(1) + 1);
            c = random('unid', ncols - rfSize(2) + 1);
            if logical(patch(r, c, :)) % only keep the non-zero pixels
                not_done = false;
            end
        end

        patch = patch(r:r+rfSize(1)-1,c:c+rfSize(2)-1,:);
        % Debug, visualize the patch
%         imshow(reshape(patch,[5 5]),[]);
%         title(sprintf('patch %d', i));
%         pause;
        % Debug END ****************
        patches(i,:) = patch(:)';
    
    end

    disp('Contrast normalization...');
    % +10 offset was added to the variance to avoid dividing by zero and also supressing noise
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,0,2) + 10));

end

