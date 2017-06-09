function [idx_z, num_pos_labels] = pick_slice_with_lesion(slices)
% This function will return the indices that have lesion
% Input: 
%   slices: annotations in a 3D matrix
% Output:
%   idx_z: the list of z-index where there are lesions, it's sorted
idx_z = [];

for i = 1:size(slices, 3)
   slice = slices(:,:,i);
   if sum(sum(slice)) > 0
       idx_z = [idx_z i];
   end
    
end

fprintf('The number of slices that contain lesions is: %d\n', length(idx_z));

[ num_pos_labels, sorted_idx ] = sort_lesion_slices( idx_z, slices );
idx_z = sorted_idx; % sorted in descending order
fprintf('The total number of lesions in the top 10 are %d\n', sum(num_pos_labels(1:10)));

end

