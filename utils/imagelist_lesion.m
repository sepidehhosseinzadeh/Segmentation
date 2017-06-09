function imlist = imagelist_lesion(annotations, numscales)
% Keep it here for compatibility
% Take a list of annotations and return the z indexes of a selected list of slices
% Parameters:
%               annotations: annotations in 3D matrix
%               numscales:   number of scale of gaussian pyramid
% Returns:
%               imlist:      a list of scaled slices with annotations

 num_slices = size(annotations,3);
%num_slices = 10;
% Save the slices in different scales
imlist = 1:numscales * num_slices;
