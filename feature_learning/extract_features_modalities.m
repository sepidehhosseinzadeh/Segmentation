function L=extract_features_modalities(images, D, params)
    nimages= size(images, 1)/(params.numscales*params.rfSize(3));
    for j=1:params.rfSize(3)
        D_modality.codes= D.codes(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        D_modality.mean= D.mean(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        images_modality= images(nimages*params.numscales*(j-1)+1:nimages*j*params.numscales, :);
        L_modality = extract_features_building(images_modality, D_modality, params);

        if j==1
           L= L_modality;
        else
            L= addCells(L, L_modality);
        end
    end
end
