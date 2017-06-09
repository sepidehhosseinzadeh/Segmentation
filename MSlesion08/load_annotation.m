function [I] = load_annotation(filename)
% Function for loading 3D annotation
%
% Parameters:
%   filename:  the full path of the nrrd file
% Returns:
%   I:      the annotation

% Load the annotation to a double matrix I
[I, meta] = nrrdread(filename);
I = double(I);

