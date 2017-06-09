function [folds] = generateFolds(X, Y, K)

m = size(X,1);
index_px = find(Y==1);
index_nx = find(Y==0);
cv_px = crossvalind('Kfold',length(index_px),K);
cv_nx = crossvalind('Kfold',length(index_nx),K);
folds = zeros(m,2);
folds(:,1) = 1:m;
folds(index_px,2) = cv_px;
folds(index_nx,2) = cv_nx;

end