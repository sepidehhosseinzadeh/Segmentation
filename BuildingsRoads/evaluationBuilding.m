function [acc, precision, recall, f1, jaccard, dice] = evaluationBuilding(prediction, ground_truth)
    prediction = prediction > 0.5;
    ground_truth = ground_truth > 0.5;
    
    jaccard = jaccard_score(ground_truth, prediction);
    dice = dice_score(ground_truth, prediction);
    
    [m, n] = size(prediction);
    if n~=1
        prediction = reshape(prediction,m*n,1);
    end
    [m, n] = size(ground_truth);
    if n~=1
        ground_truth = reshape(ground_truth,m*n,1);
    end
    label_p = 1;
    label_n = 0;
    y_true = ground_truth;
    y_pred = prediction;
    acc = accuracy_score(y_true, y_pred);
    f1 = f1_score(y_true, y_pred, label_p, label_n);
    precision = precision_score(y_true, y_pred, label_p, label_n);
    recall = recall_score(y_true, y_pred, label_p, label_n);
end