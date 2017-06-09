function [I] = load_mslesion(filename)
% Function for loading 3D volume
%
% Parameters:
%   filename:  the full path of the nrrd file
% Returns:
%   I:      the 3D scan

% Load the 3D volume to a double matrix I
[I, meta] = nrrdread(filename);
I = double(I);

% Contrast Normalization
for i = 1:size(I,3)
    I(:,:,i) = map_image_to_256((I(:,:,i)));
end

