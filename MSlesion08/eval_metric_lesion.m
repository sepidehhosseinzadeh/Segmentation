function stats = eval_metric_lesion(model, scaleparams, D, params)

%% Load the test volume to segment
test_idx = params.test_vol;
test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s.nhdr',params.scansdir,test_idx);
V = load_mslesion(test_scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s_mask.nhdr',params.scansdir,test_idx);
V_mask = load_annotation(mask);
ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,test_idx);
% make it logical array to work with the eval metrics functions
A = logical(load_annotation(ant_file));

%% Compute metrics
% The value of pos or neg labels
label_p = 1;
label_n = 0;

%% Segment all slices of V
preds = false(size(V)); % predictions in 3D volume
fprintf('Extracting features');
for slice_index = 1:size(V,3)
    p = segment_lesions(V(:,:,slice_index), V_mask(:,:,slice_index), model, D, params, scaleparams);
    preds(:,:,slice_index) = p>0.5;
end
% slice_index = 210;
% p = segment_lesions(V(:,:,slice_index), V_mask(:,:,slice_index), model, D, params, scaleparams);
% preds = p>0.5;
% A = A(:,:,slice_index);

% jaccard
stats.jaccard = jaccard_score(A,preds);
% dice
stats.dice = dice_score(A,preds);
% f1
stats.f1 = f1_score(A(:), preds(:), label_p, label_n);
% precision
stats.precision = precision_score(A(:), preds(:), label_p, label_n);
% recall
stats.recall = recall_score(A(:), preds(:), label_p, label_n);
% accuracy
stats.accuracy = accuracy_score(A(:), preds(:));

fprintf('The accuracy is: %f\n', stats.accuracy);
fprintf('The precision(PPV) is: %f\n', stats.precision);
fprintf('The recall(TPR) is: %f\n', stats.recall);
fprintf('The f1(DSC) score is: %f\n', stats.f1);
fprintf('The jaccard score is: %f\n', stats.jaccard);
fprintf('The dice score is: %f\n', stats.dice);

