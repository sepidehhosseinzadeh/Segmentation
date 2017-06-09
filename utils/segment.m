function yhat = segment(im, mask, model, D, params, scaleparams)

    % Pre-process image
    up = [size(im, 1) size(im, 2)];
    im = pyramid(im, params);
    if max(mask(:)) > 1; mask = mask ./ 255; end

    % Extract first module feature maps
    disp('Extracting features...');
    L = extract_features(im, D, params);

    % Upsample
    L = upsample(L, params.numscales, up);

    % Label each pixel
    yhat = annotate(cat(3, L{1}), model, mask, scaleparams);
    
