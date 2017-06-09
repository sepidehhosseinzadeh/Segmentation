function [X, scaleparams] = standard(XC, scaleparams)

    if ~exist('scaleparams','var')
        scaleparams.epsilon = 0.01;
        scaleparams.mean = mean(XC);
        scaleparams.sd = sqrt(var(XC) + scaleparams.epsilon);
    end
    X = bsxfun(@rdivide, bsxfun(@minus, XC, scaleparams.mean), scaleparams.sd);
    X = [X, ones(size(X,1),1)];


