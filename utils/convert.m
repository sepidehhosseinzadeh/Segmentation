function [X, labels] = convert(L, annotations, imagelist)
% Parameters:
%           L:  Feature maps that are grouped based on images
%           annotations: annotations
%           imagelist: indexes of the slices that contain annotations
% Returns:
%           X:  features
%           labels: labels
    X = zeros(size(annotations, 1), size(L{1}, 3));
    labels = zeros(size(annotations, 1), 1);
    mapobj = containers.Map(imagelist, 1:length(imagelist));

    % Loop through annotations, assigning features and labels
    for i = 1:length(labels)

        % Get the label
        labels(i) = annotations(i,4) + 1;

        % Get the features
        % annotations(i,2) is the original x, annotations(i,1) is the original y 
        % due to the permutation in load_vessel12.m
        q = L{mapobj(annotations(i,3) + 1)}(annotations(i, 2) + 1 , annotations(i, 1) + 1, :);
        X(i,:) = q(:)';

    end

end

