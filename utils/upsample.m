function Lv = upsample(L, numscales, upsize)
% Resize each image in L to match the size specified by upsize [nrow ncols]
% Parameters:
%           L: a list of images
%           numscales: # of scales of the gaussian pyramid
%           upsize: the new size
% Returns:
%           Lv: a list of upsampled images, put images of different scale in the same group
    % First upsample everything
    k = size(L{1}, 3);
    Lu = cell(length(L), 1);
    parfor i = 1:length(L)
        for j = 1:k
            Lu{i}(:,:,j) = imresize(L{i}(:,:,j), upsize);
        end
    end

    % Then re-organize in groups of images
    Lv = cell(length(L) ./ numscales, 1);
    count = 1;
    for i = 1:numscales:length(L)
        ims = zeros(upsize(1), upsize(2), numscales * k);
        for j = 1:numscales
            ims(:,:,(j-1)*k + 1 : j * k) = Lu{(i-1) + j};
        end
        Lv{count} = ims;
        count = count + 1;
    end

end

