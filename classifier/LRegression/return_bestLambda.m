function [bestLambda accuracy] = return_bestLambda(X, Y, lambda, folds, K)

bestLambda = 0;
accuracy = zeros(length(lambda),1);

for i = 1:length(lambda)
    subaccuracy = zeros(K,1);
    for j = 1:K
        [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, Y, folds, j);        
        [theta] = LRegression(trainSet,labelsTrain,lambda(i));
        p = predict(theta, testSet);
        subaccuracy(j) = mean(double(p==labelsTest));
    end
    accuracy(i) = mean(subaccuracy);
end

[~, indexMax] = max(accuracy);
bestLambda = lambda(indexMax);

end