function visualize_dictionary_modalities(D, params)
    for j=1:params.rfSize(3)
        D_modality.codes= D.codes(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        D_modality.mean= D.mean(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        figure(j+1);
        visualize_dictionary(D_modality);
    end
end
