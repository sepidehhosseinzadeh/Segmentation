function [optval, acc, f1] = xval(X, L, vals, numfolds)

% Split into folds
% Balancing the positive and negative samples in each fold
folds = generateFolds(X, L, numfolds);

% Loop over values
acc = zeros(length(vals), 1);
f1 = zeros(length(vals), 1);
for i = 1:length(vals)
    
    % Loop over folds
    val = vals(i);
    accfold = zeros(length(numfolds), 1);
    f1fold = zeros(length(numfolds), 1);
    parfor j = 1:numfolds
        
        % Use one fold as the test set, the other folds are used for training
        [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, L, folds, j);
        [trainSet, scaleparams] = standard(trainSet);
        % use the scaling parameters from the training set
        testSet = standard(testSet, scaleparams); 
        theta = softmax_regression(trainSet, labelsTrain, 2, val);
        [~, M] = predict(theta, testSet);
        yhat = (M(2,:) >= 0.5)' + 1;
        
        accfold(j) = mean(yhat == labelsTest);
        % Use F1 Score instead
        f1fold(j) = f1_score(labelsTest, yhat, 2, 1);
        
    end
    acc(i) = mean(accfold);
    disp(['Mean accuracy with parameter ' num2str(val) ': ' num2str(acc(i))]);
    f1(i) = mean(f1fold);
    disp(['Mean f1 with parameter ' num2str(val) ': ' num2str(f1(i))]);
    
end

% Return optimal parameter
[~, ind] = max(f1); % optimize on f1 score
optval = vals(ind);
disp(' ');




