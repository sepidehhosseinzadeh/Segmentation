function [model, scaleparams] = learn_classifier(X, labels, numfolds)

    % Values to search over
    % This is going to be used as the regularization rate
    vals = 2.^[-10:10];
    
    % First permute the data
    indperm = randperm(size(X, 1));
    X = X(indperm,:);
    labels = labels(indperm);

    % Apply cross-validation
    disp('Performing cross validation...')
    [optval, acc, f1] = xval(X, labels, vals, numfolds);
    disp(['Accuracy (not cv accuracy): ' num2str(max(acc) * 100) '%']);
    disp(['F1 (not cv F1): ' num2str(max(f1) * 100) '%']);

    % Scale the data and train
    disp('Training Logistic Regression...')
    [X, scaleparams] = standard(X);
    scaleparams.optval = optval;
    model = softmax_regression(X, labels, 2, optval);
    
    % cross validation accuracy
%     disp('Computing cross validation accuracy...')
%     [cvAcc] = accuracy_CV(X, labels, vals, numfolds);
%     disp(['Cross Validation Accuracy: ' num2str(max(cvAcc) * 100) '%']);

