function [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, Y,folds, iterNum)
    % Create the train and test sets.
    testIndexes = (folds(:,2) == iterNum);
    labelsTest = Y(folds(testIndexes,1));

    trainIndexes = (folds(:,2) ~= iterNum);
    labelsTrain = Y(folds(trainIndexes,1));

    testSet = X(folds(testIndexes,1),:);
    trainSet = X(folds(trainIndexes,1),:);
end