function imgZCAwhite= zcawhitening(patches, params)
%    disp('ZCA Whitening...');
%     img= im2double(patches);
%     img= img';
%     cov = img * img' / size(img, 2);
%     [U,S,V] = svd(cov);
% 
%     zca = U * diag(1./sqrt(diag(S) + sqrt(eps))) * U' * img;
%     imgZCAwhite= zca';

    %patches =patches';
    C = cov(patches);
    [V,E] = eig(C);
    imgZCAwhite = (V * diag(sqrt(1./(diag(E) + 0.1))) * V'*patches')';
end

% function imgZCAwhite= zcawhitening(patches, params)
%     disp('ZCA Whitening...');
% 
%     imgZCAwhite= zeros(size(patches, 1), params.rfSize(1)* params.rfSize(2));
%     for i=1: size(patches, 1)
%         img= patches(i, :);
%         img= im2double(img);
%         img= reshape( img, params.rfSize(1), params.rfSize(2));
%         
%         cov = img * img' / size(img, 2);
%         [U,S,V] = svd(cov);
% 
%         imgPCAwhite = diag(1./sqrt(diag(S) + eps)) * U' * img;
%         imgZCA = U * diag(1./sqrt(diag(S) + 0.1 )) * U' * img;
%         imgZCAwhite(i, :)= reshape(imgZCA,1,size(imgZCA,1)*size(imgZCA,2));
%         
%     end
%     
% end
% 
