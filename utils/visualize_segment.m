function seg = visualize_segment(im, yhat)
% Visualize the segmentation
% Parameters:
%               im: Image
%               yhat: 
% Returns:
%               seg: Segmentation Results
    % Compute an image overlay of the annotated pixels
    seg = imoverlay(uint8(im), yhat, [255/255 0/255 221/255]);

    % Visualize the original and segmented image side by side
    subplot(1,2,1); imshow(uint8(im));
    subplot(1,2,2); imshow(seg);
