function theta = softmax_regression(train, train_L, k, lambda)
% lambda: regularization parameter

   % initialize parameters
   train = train';
   [n,m] = size(train);
   theta = 0.005 * randn(k * n, 1);

   % run optimization
   options.Method = 'lbfgs';
   options.DerivativeCheck = 'off';
   options.MaxIter = 200;
   options.Display = 'None';
   theta = minFunc(@softmax_regression_grad, theta, options, train, train_L, n, m, k, lambda);

   % Unroll theta
   theta = reshape(theta, k, n);


function [C, dC] = softmax_regression_grad(theta, train, train_L, n, m, k, lambda)


    labels = full(sparse(train_L, 1:m, 1));

    % Unroll theta
    theta = reshape(theta, k, n);

    % Compute Cost
    M = theta * train;
    M = exp(bsxfun(@minus, M, max(M, [], 1)));
    M = bsxfun(@rdivide, M, sum(M));
    sqtheta = theta .^2;
    C = (-1 / m) * sum(sum(labels .* log(M))) + (lambda / 2) * sum(sqtheta(:));

    % Gradient
    dC = (-1 / m) * (labels - M) * train' + lambda * theta;
    dC = dC(:);


