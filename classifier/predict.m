function [yhat, M] = predict(theta, test)

    test = test';

    % Compute probabilities
    M = theta * test;
    M = exp(bsxfun(@minus, M, max(M, [], 1)));
    M = bsxfun(@rdivide, M, sum(M));

    % Get argmax
    [foo,yhat] = max(M, [], 1);
    yhat = yhat';
