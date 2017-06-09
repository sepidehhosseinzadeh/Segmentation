function [f1] = f1_score(y_true, y_pred, label_p, label_n)
% input: label_p: the label for positive
%        label_n: the label for negative
%        y_true: the ground truth label
%        y_pred: the predicted label

precision = precision_score(y_true, y_pred, label_p, label_n);
recall = recall_score(y_true, y_pred, label_p, label_n);

if 0 == (precision & recall) % avoid divided by 0
    f1 = 0;
else
    f1 = 2*precision*recall/(precision+recall);
end

end
