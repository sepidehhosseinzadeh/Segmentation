function Lv = upsample_light(L, numscales, upsize)
% Memory efficient implementation of upsampling.
% Resize each image in L to match the size specified by upsize [nrow ncols]
% Parameters:
%           L: a list of images
%           numscales: # of scales of the gaussian pyramid
%           upsize: the new size
% Returns:
%           Lv: a list of upsampled images, put images of different scale in the same group
    % First upsample everything
    k = size(L{1}, 3);
    len_L = length(L);
    Lu = cell(len_L, 1);
    for i = 1:len_L
        for j = 1:k
            Lu{i}(:,:,j) = imresize(L{1}(:,:,j), upsize);
        end
        L(1)=[]; % remove the data for the entries that are no longer used
    end
    clear L;
    fprintf('Upsampling finished. Start grouping images...\n');
    % Then re-organize in groups of images
    Lv = cell(len_L ./ numscales, 1);
    count = 1;
    for i = 1:numscales:len_L
        ims = zeros(upsize(1), upsize(2), numscales * k);
        for j = 1:numscales
            ims(:,:,(j-1)*k + 1 : j * k) = Lu{j};
        end
        Lu(1:numscales) = []; % remove the data for the entries that are no longer used
        Lv{count} = ims;
        count = count + 1;
    end

end

