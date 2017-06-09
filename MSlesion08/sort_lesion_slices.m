function [ num_pos_labels, sorted_idx ] = sort_lesion_slices( slice_idx, annotations )

    % Find the number of pos labels on each slice and sort them
    num_pos_labels = zeros(length(slice_idx),1); % # of pos labels
    for i = 1:length(slice_idx) % process each slice
        num_pos_labels(i) = length(find(annotations(:,:,slice_idx(i))));
    end
    % Return the sorted index and the corresponding num of pos labels
    [num_pos_labels, tmp_idx] = sort(num_pos_labels, 'descend');
    sorted_idx = slice_idx(tmp_idx);
end

