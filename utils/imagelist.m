function imlist = imagelist(annotations, numscales)
% Take a list of annotations, return a list of slices with annoations
% Parameters:
%               annotations: annotation
%               numscales:   num of scale of gaussian pyramid
% Returns:
%               imlist:      a list of slices with annotations

    % The number of unique z values
    un = unique(annotations(:,3)) + 1;

    % zeros of num scales
    imlist = zeros(numscales * length(un), 1);

    for i = 1:length(un)
        imlist(numscales * (i-1) + 1 : numscales * (i-1) + numscales) = numscales*un(i)-numscales+1:numscales*un(i);
    end

end

