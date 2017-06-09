function visualize_labels_pred(V, gt, preds, vol_index, slice_index)
% Overlays the annotations and predictions onto the original scan.
% Input:
%       V: a 3D volume
%       gt: ground truth annotations
%       preds: predictions
%       vol_index, slice_index: index of the volume and the slice(z-index)

I = V(:,:,slice_index);
imshow(I,[])
hold on

%% visualize labels for groundtruth
BW = gt(:,:,slice_index);
B = bwboundaries(BW); % extract the contour, use it as ground truth
for i=1:length(B)
    ground_truth = B{i};
    ground_truth = ground_truth(:,[2 1]); % swap the column
    % It's okay to overwrite the handle since we only need one for plotting the legends
    h1 = plot(ground_truth(:,1), ground_truth(:,2), 'g');
end

%% visualize labels for prediction
BW = preds>0.5;
B = bwboundaries(BW); % extract the contour of the prediction
for i=1:length(B)
    ground_truth = B{i};
    ground_truth = ground_truth(:,[2 1]); % swap the columns
    % It's okay to overwrite the handle since we only need one for plotting the legends
    h2 = plot(ground_truth(:,1), ground_truth(:,2), 'r');
end

if ~exist('h1','var') && ~exist('h2','var')
    % 'No positives', do nothing
elseif ~exist('h1','var')
    legend(h2, 'Prediction');
elseif ~exist('h2','var')
    legend(h1, 'Ground Truth');
else
    legend([h1 h2],{'Ground Truth','Prediction'});
end
title(sprintf('Segmentation Result on volume %d, slice %d',vol_index, slice_index));
hold off

end

