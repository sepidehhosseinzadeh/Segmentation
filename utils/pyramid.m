function images = pyramid(I, params)
% Generate Gaussian Pyramid of an image

    images = cell(params.numscales * size(I,3), 1);

    % Loop over images by taking each slice of the 3D volume
    for i = 1:size(I, 3)
        
        y = cell(params.numscales, 1);
        z = Gscale(I(:,:,i), params.numscales, [5 5], 1);
        for j = 1:params.numscales
            y{j} = z(j).img;
        end
             
        % Loop over layers
        for j = 1:length(y)
            % why padding?
            yj = padarray(y{j}, [(params.rfSize(1) - 1) / 2 (params.rfSize(2) - 1) / 2], 'replicate');
            images{params.numscales*(i-1) + j} = yj;
        end
        
    end

end

