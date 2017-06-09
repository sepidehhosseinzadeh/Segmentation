function visualize_dictionary(D)
% This function visualize the dictionary (feature extractor)
k = size(D.codes, 1);
n = size(D.codes, 2);
tmp = zeros(size(D.codes))';

for i=1:k
tmp(:,i) = map_image_to_256(D.codes(i,:)');
end

for i = 1:k
	subplot(4,8,i);
    imshow(uint8(reshape(tmp(:,i), [sqrt(n) sqrt(n)])));
end
end