function [theta] = LRegression(X,y,lambda)

    % Initialize fitting parameters
    initial_theta = zeros(size(X, 2), 1);
    
    % Set Options
    options = optimset('GradObj', 'on', 'MaxIter', 400);

    % Optimize
    [theta, ~, ~] = ...
	fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);

end