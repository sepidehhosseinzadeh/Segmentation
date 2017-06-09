function [dice] = dice_score(img_true,img_pred)
% Image must be in logical format
% Dice similarity co-efficient of segmemted and ground truth image

% Check for logical image (0,1)
if ~islogical(img_true)
    error('Image must be in logical format');
end
if ~islogical(img_pred)
    error('Image must be in logical format');
end

dice = 2*nnz(img_true&img_pred)/(nnz(img_true) + nnz(img_pred));


end