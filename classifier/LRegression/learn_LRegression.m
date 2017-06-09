function [theta] = learn_LRegression(X, Y)
% input: X: [m n], m samples, n ffeatures
%        Y: labels, 0 negative, 1 positive. If not, please change function generateFolds

X = [ones(size(X,1),1) X];

bestLambda = 0;
theta = 0;

% generate K folds----------
K = 5;
folds = generateFolds(X, Y, K);

% learn model-----------------
lambda = 2.^[-5:15];
bestLambda = return_bestLambda(X, Y, lambda, folds, K);

theta = LRegression(X, Y, bestLambda);

end