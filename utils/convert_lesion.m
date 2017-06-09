function [X, labels] = convert_lesion(L, mask, annotations, imageidx, params)
% Take features and labels from each voxel on every slice in imageidx
% Parameters:
%           L:  Feature maps that are grouped based on images
%           mask: the mask for the brain tissues
%           annotations: annotations
%           imageidx: indexes of the slices that contain annotations
% Returns:
%           X:  features
%           labels: labels
size_L = size(L{1}); % 512 x 512 x 192
if isfield(params, 'ratio')
    % We're undersampling the training data
    ratio = params.ratio;
    
    % Find some positive labels
    % Find index of positive labels on the imageidx
    lesion_pos = cell(length(imageidx), 1);
    nonlesion_pos = cell(length(imageidx), 1);
    total_lesions = 0; % # of pixels that are lesions
    for i = 1:length(imageidx)
        [row, col] = find(annotations(:, :, i));
        lesion_pos{i} = sub2ind(size_L(1:2), row, col); % index
        total_lesions = total_lesions + length(row);
        % Find negative labels
        % Two approaches:
        % 1, Random Search
        % 2, Find the neighbors of the lesions : TODO
        neg_sample = zeros((ratio-1)*length(row),1);
        neg_sample = choose_neg(ratio-2,1,row,col,size_L,mask,annotations,i);% ratio_r+ratio_n=(ratio-1)

        nonlesion_pos{i} = neg_sample;
    end
    
    m = ratio * total_lesions; % # of training samples
    X = zeros(m, size_L(3)); % # of pixels x 192 (scaled features)
    labels = zeros( m, 1);

    last_ind = 0;
    for i = 1:length(imageidx)
        % Get the label
        %labels((i-1)*voxels+1:i*voxels) = reshape(annotations(:,:,imageidx(i))+1, [voxels 1]);% label+1 to make all labels positive for softmax regression
        
        pos_row = length(lesion_pos{i});
        tmp = annotations(:, :, i);
        labels(last_ind + 1: last_ind + pos_row) = tmp(lesion_pos{i});
        labels(last_ind + pos_row + 1: last_ind + ratio*pos_row) = tmp(nonlesion_pos{i});
        for j = 1:size_L(3)
            q = L{i}(:, :, j); % 512*512
            X(last_ind + 1: last_ind + pos_row, j) = q(lesion_pos{i})';
            X(last_ind + pos_row + 1: last_ind + ratio*pos_row, j) = q(nonlesion_pos{i})';
        end
        % update the index
        last_ind = last_ind + ratio * pos_row;
        
        % Get the features
        %q = L{i}; % 512*512*192
        %X( (i-1)*voxels+1:i*voxels, : ) = reshape(q, [voxels size_L(3)]);
    end

else
    % Only pick the brain tissues ? 
    k = find(mask); % idx of brain pixels
    % m = size_L(1)*size_L(2)*length(imageidx); % Keep all the pixels
    m = length(k); % # of training samples
    X = zeros(m, size_L(3)); % # of pixels x 192 (scaled features)
    % labels = zeros(m, 1);
    % Loop through annotations, assigning features and labels
    % index of the labels in the last iteration
    % voxels = size(L{1},1)*size(L{1},2); % 512*512
    last_ind = 0;
    % directly pick from 3D matrix mask and annotations
    labels = annotations(k);
    for i = 1:length(imageidx)
        % Loop through all slices       
        % Save the features corresponding to brain pixels
        q = L{i}; % 512*512*192
        [r_brain, c_brain] = find(mask(:,:,i)); % row and column idx of brain pixels on each slice
        voxels = length(r_brain); % # of brain pixels on the current slice
        for j = 1:voxels
            X( last_ind+j, : ) = reshape(q(r_brain(j),c_brain(j),:), [1 size_L(3)]);
        end
        last_ind = last_ind + voxels;
    end
    
end
labels = labels + 1; % change to positive labels (0,1) to (1,2) so it works with softmax regression
end

function [rtemp,ctemp] = neighbor_neg(row_max,row_min,col_max,col_min) % d is the distance from lesion

r = [row_min-1,row_max+1]';
cl = [col_min:col_max]';
rtemp = repelem(r,length(cl),1);
ctemp = repmat(cl,length(r),1);
c = [col_min-1,col_max+1]';
rl = [row_min+1:row_max+1]';
ctemp = [ctemp;repelem(c,length(rl),1)];
rtemp = [rtemp;repmat(rl,length(c),1)];

end

function random_sample = random_neg(ratio,row,size_L,mask,annotations,i)
% ratio is the ratio compared to positive samples
% row is the chosen row of positive samples
% size_L
random_sample = zeros(ratio*length(row),1);
for j = 1 : length(random_sample)
    not_done = true;
    
    while not_done
        r = random('unid', size_L(1));
        c = random('unid', size_L(2));
        % pick a pixel that is brain tissue and has negative label
        if mask(r, c, i) && ~annotations(r, c, i)
            not_done = false;
        end
    end
    
    random_sample(j) = sub2ind(size_L(1:2), r, c);
end

end

function neg_sample = choose_neg(ratio_r,ratio_n,row,col,size_L,mask,annotations,i)
% ratio_r is the random sample ratio compared to positive samples
% ratio_n is the neighbor sample ratio compared to positive samples
% row and col are vector of positive samples
random_sample = random_neg(ratio_r,row,size_L,mask,annotations,i);

row_max = max(row);
row_min = min(row);
col_max = max(col);
col_min = min(col);
neighbor_sample = zeros(ratio_n*length(row),1);
r = [];
c = [];
while length(r) < length(neighbor_sample)
    [rtemp,ctemp] = neighbor_neg(row_max,row_min,col_max,col_min);
    r = [r;rtemp];
    c = [c;ctemp];
    row_max = row_max+1;
    row_min = row_min-1;
    col_max = col_max+1;
    col_min = col_min-1;
end
r = r(1:length(neighbor_sample));
c = c(1:length(neighbor_sample));
neighbor_sample = sub2ind(size_L(1:2), r, c);
 
neg_sample = [random_sample;neighbor_sample];
end

