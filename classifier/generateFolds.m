function [folds] = generateFolds(X, Y, K)
% K: number of folds
% X: samples
% Y: labels
m = size(X,1);
index_px = find(Y==1);
index_nx = find(Y==2);
cv_px = crossvalind('Kfold',length(index_px),K); % from bioinfo toolbox, better be replaced with built-in
cv_nx = crossvalind('Kfold',length(index_nx),K);
folds = zeros(m,2);
folds(:,1) = 1:m;
folds(index_px,2) = cv_px;
folds(index_nx,2) = cv_nx;

end
