function [cvAcc] = CV_LRegression(X, Y)
% input: X: [m n], m samples, n ffeatures
%        Y: labels, 0 negative, 1 positive. If not, please change function generateFolds

X = [ones(size(X,1),1) X];

% generate K folds----------
K = 5;
folds = generateFolds(X, Y, K)

cv_acc = zeros(K,1);
lambda = 2.^[-5:15];
for i = 1:K 
    [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, Y, folds, i);
    % generate K subfolds---------------
    subfolds = generateFolds(trainSet, labelsTrain, K);
    
    bestLambda = 0;
    bestLambda = return_bestLambda(trainSet, labelsTrain, lambda, subfolds, K);
    theta = LRegression(trainSet, labelsTrain, bestLambda);
    p = predict(theta, testSet);
    cv_acc(i) = mean(double(p==labelsTest));
end

% ------------------------------------------------------------------------
cvAcc = mean(cv_acc);

end
