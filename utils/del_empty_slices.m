function ind = del_empty_slices(mask)
% Skip the images where the pixels corresponding to brain tissues
% is below a threshold
% Input: 
%   mask: a brain mask
% Output: 
%   ind: the z-index of the slices where there are abundant brain tissues 
    z_range = size(mask,3);
    empty_slices = zeros(z_range, 1);
    thres = 0.2 * size(mask,1) * size(mask,2);
    mz = 0;

    for i = 1:z_range
        % Find the number of positive elements
        non_zero = nnz(mask(:, :, i));
        if non_zero < thres
            % save the z-indexes of the empty slices
            empty_slices(i) = i;
        end
        mz = max(non_zero, mz);
    end

    fprintf('The max number of brain tissue pixels on a slice is %d\n', mz);

    % Remove the zeros
    empty_slices(~empty_slices)=[];
    ind = setdiff(1:z_range, empty_slices);
