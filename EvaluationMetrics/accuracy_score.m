function [accuracy] = accuracy_score(y_true, y_pred)
% input: label_p: the label for positive
%        label_n: the label for negative

% tp = sum((y_true == y_pred) & (y_true == label_p));
% tn = sum((y_true == y_pred) & (y_true == label_n));
% fp = sum((y_true ~= y_pred) & (y_pred == label_p));
% fn = sum((y_true ~= y_pred) & (y_pred == label_n));
% accuracy = (tp+tn)/(tp+fp+tn+fn);

accuracy = mean(y_true == y_pred);

end
