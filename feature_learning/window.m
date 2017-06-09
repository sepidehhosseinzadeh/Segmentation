function [subregions, rowinds, colinds] = window(im, params)

    
    % Parameters
    regSize = params.regSize;
    regSize(1:2) = [size(im, 1) size(im, 2)];
    
    % Initalization
    maxend = max([size(im, 1) size(im, 2)]);
    if params.layer == 2
        stride = 1;
    elseif maxend <= 128
        stride = 4;
    elseif maxend <= 214
        stride = 6;
    else
        stride = 8;
    end
    rowinds = 1:stride:size(im, 1) - regSize(1) + 1; % always 1 since size(im,1) == regSize(1)
    colinds = 1:stride:size(im, 2) - regSize(2) + 1; % bug?
    subregions = zeros(length(rowinds) * length(colinds), regSize(1) * regSize(2) * size(im, 3));
    index = 1;
    
    % Extract subregions
    for i = 1:stride:size(im, 1) - regSize(1) + 1
        for j = 1:stride:size(im, 2) - regSize(2) + 1
            sr = im(i:i+regSize(1)-1,j:j+regSize(2)-1,:);
            subregions(index,:) = sr(:)';
            index = index + 1;
        end
    end
            
end

