% This metric is for segmentation
% For classification jaccard_score = accuracy_score
% Jaccard index and distance co-efficient of segmented and ground truth image
% TODO: Reference? why is this output in a different format?
% Usage: [index,distance(JC)] = jaccard_score(Orig_Image,Seg_Image);

function [jaccard] = jaccard_score(img_true,img_pred)
% Input:  img_true is the grouth truth binary image
%         img_pred is the predicted binary segmentation
% Output: jaccard score
% Check for logical image (0,1)
if ~islogical(img_true)
    error('Ground Truth Image must be in logical format');
end
if ~islogical(img_pred)
    error('Prediction Image must be in logical format');
end

jaccard = nnz(img_true & img_pred)/nnz(img_true | img_pred);

end
