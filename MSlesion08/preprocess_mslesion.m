function [patches, images, image_idx, I_mask, A] = preprocess_mslesion(params)
% Input: params: hyperparams
% Output: 
% patches: patches for learning the dictionary
% images: a cell array each of which is a scaled image in the pyramid
% image_idx: a list of indice of the slices which contain positive labels (ms lesion)
% I_mask: brain mask
% A: annotations

ntv = params.ntv;   % number of training volumes
V = cell(ntv, 1);   % volumes
A = cell(ntv, 1);   % annotation
A_py = cell(ntv, 1);% annotation in a Gaussian pyramid
Vlist = cell(ntv, 1);% list of z-indice of the slices containing positives(lesions)
I_mask = cell(ntv, 1);% brain mask
Vs = [];            % a cell array of all images from all volumes
% Initialization
for i = 1:ntv
    % I is a 3D volume of the scan
    scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s.nhdr',params.scansdir,i);
    I = load_mslesion(scan);
    % I_mask is the brain mask for the scan
    mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s_mask.nhdr',params.scansdir,i);
    I_mask{i} = load_annotation(mask);
    % Load the annotations (labels: 0/1) in 3D matrix
    ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,i);
    A{i} = load_annotation(ant_file);
    % Only keep slices that contain lesions
    % ind are already sorted here
    ind = pick_slice_with_lesion(A{i});
    A{i} = A{i}(:,:,ind); % only keep slices that contain lesions
    I_mask{i} = I_mask{i}(:,:,ind); 
    % Make the non brain tissue zero
    I = I(:,:,ind).*I_mask{i};
    % Gaussian Pyramid of the image, saved in a vector
    % V{i} is a cell array each of which is a scaled image in the pyramid
    % Example:
    % >> size(V{1}{1}) = 516   516
    % >> size(V{1}{2}) = 260   260
    V{i} = pyramid(I, params);
    % Annotation after applying Gaussian pyramid
    A_py{i} = pyramid(A{i}, params); 
    % The list of indexes of the slices which contain positive labels (ms lesion)
    Vlist{i} = imagelist_lesion(A{i}, params.numscales);
    % Vs is a vector of cells where each cell is a scaled image
    Vs = [Vs; V{i}];
    clear I;
end

% Extract patches
patches = extract_patches_lesion(Vs, params, A_py);
images = V;
image_idx = Vlist;

