function [cvAcc] = accuracy_CV(X, Y, vals, K)
% input: X: [m n], m samples, n ffeatures
%        Y: labels, 1 negative, 2 positive. If not, please change function generateFolds
%        vals: the range of lambda

% generate K folds----------
folds = generateFolds(X, Y, K)

cv_acc = zeros(K,1);
for i = 1:K     
    [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, Y, folds, i);
    [optval, acc] = xval(trainSet, labelsTrain, vals, K)
    theta = softmax_regression(trainSet, labelsTrain, 2, optval);
    [~, M] = predict(theta, testSet);
    yhat = (M(2,:) >= 0.5)' + 1;
    cv_acc(i) = mean(yhat == labelsTest);    
end

cvAcc = mean(cv_acc);

end
