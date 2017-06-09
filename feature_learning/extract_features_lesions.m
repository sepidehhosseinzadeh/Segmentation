function L = extract_features_lesions(X, D, params)
% Given input patch X and dictionary D, learn features
% Parameters:
% X: a cell of matrix, each matrix is an image in a particular scale
% D: Dictionary, k by n matrix
% params: hyper parameters
    % Parameters
    rfSize = params.rfSize;
    %regSize = params.regSize;
    %layer = params.layer;
    nmaps = params.nfeats;

    % Initalize
    L = cell(size(X, 1), 1);

    % Main Loop
    chunksize = 100;
    m = size(X, 1);
    numchunks = ceil(m ./ 100);

    % Extract features one 'chunk' at a time
    for chunk = 1:numchunks

        batch = X((chunk-1) * chunksize + 1 : min([chunk * chunksize end]));
        L_batch = cell(size(batch, 1), 1); % TODO: verify

        parfor i = 1:size(batch, 1)

            im = double(batch{i});
            im = squeeze(im);
            prows = size(im, 1) - rfSize(1) + 1;
            pcols = size(im, 2) - rfSize(2) + 1;

            % Extract subregions of the image
            % Only extract the tissue
            [subregions, rowinds, colinds] = window(im, params);
            features = zeros(prows * pcols * nmaps, size(subregions, 1));
            
            % Extract subfeatures
            for j = 1:size(subregions, 1)     
                features(:, j) = extract_subfeatures_lesions(subregions(j,:), D, size(im), params);
            end

            % Reshape into spatial region
            index = 1;
            field = zeros(prows * length(rowinds), pcols * length(colinds), nmaps);
            for j = 1:length(rowinds)
                for k = 1:length(colinds)
                    field(prows*(j-1) + 1:prows*j, pcols*(k-1) + 1: pcols*k, :) = reshape(features(:, index), [prows pcols nmaps]);
                    index = index + 1;
                end
            end

            L_batch{i} = reshape(field, [prows * length(rowinds), pcols * length(colinds), nmaps]);
    
                    
        end

        L((chunk - 1) * chunksize + 1 : min([chunksize * chunk end])) = L_batch;
        fprintf('.');
        
    end
    
    


