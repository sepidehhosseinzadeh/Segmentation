function test_and_visualize(volume_index, params, model, D, scaleparams)
% Test on a test scan and visualize the segmentation and dictionary
%% Load a test volume to segment
test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s.nhdr',params.scansdir,volume_index);
V = load_mslesion(test_scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s_mask.nhdr',params.scansdir,volume_index);
V_mask = load_annotation(mask);
ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,volume_index);
A = load_annotation(ant_file);

ind = pick_slice_with_lesion(A);
slice_list = ind;
%slice_list = ind(1:2);

for i=1:length(slice_list)
    slice_index = slice_list(i);
    %% Compute a segmentation on a slice of V
    preds = segment_lesions(V(:,:,slice_index), V_mask(:,:,slice_index), model, D, params, scaleparams);
    
    %% Visualize the result
    % visualize_segment(V(:,:,slice_index), preds>0.5);
    % Show the original scan, the ground truth and the predictions in three separate images
    %figure;
    %subplot(1,3,1);imshow(uint8(V(:,:,slice_index)));title(sprintf('Slice #%d',slice_index));
    %seg_gt = imoverlay(uint8(V(:,:,slice_index)), A(:,:,slice_index), [255/255 0/255 221/255]);
    %subplot(1,3,2); imshow(seg_gt);title('Ground truth');
    %seg_out = imoverlay(uint8(V(:,:,slice_index)), preds>0.5, [255/255 0/255 221/255]);
    %subplot(1,3,3);imshow(seg_out);title('Segmentation result');
    
    %% Visualization to show the overlapped region of labels and predictions
    %figure;
    visualize_labels_pred(V, A, preds, volume_index, slice_index);
    pause(0.2);
end
%% Visualize the dictionary
%figure;
%visualize_dictionary(D);
