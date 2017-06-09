function yhat = annotate(image, model, mask, scaleparams)

    % Mask should be a binary image
    [m,n,p] = size(image);
    image = bsxfun(@times, image, mask);
    image = reshape(image, m * n, p);
    image = standard(image, scaleparams);
    
    [yhat, M] = predict(model, image);
    yhat = reshape(M(2,:), m, n, 1);
    
end

