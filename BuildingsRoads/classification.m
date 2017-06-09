function [model, prediction] = classification (labels_train, X_train, labels_test, X_test, params)
    if strcmp (params.classifier,'logistic_reg')
        B = mnrfit(X_train,labels_train+1);
        pihat = mnrval(B,X_test);
        model = B;
        prediction = pihat;
    elseif strcmp (params.classifier,'svm')
        model = libsvmtrain( labels_train, X_train);
        [prediction, accuracy] = libsvmpredict(labels_test, X_test, model);
    elseif strcmp (params.classifier,'RF')
        model = TreeBagger(params.numTrees,X_train,labels_train, 'Cost', params.cost , 'NumPredictorsToSample', params.npredictors);
        [labels, prediction] = predict(model, X_test);
%     elseif strcmp (params.classifier,'ada')
%         weak_learner = tree_node_w(3); % pass the number of tree splits to the constructor
%         MaxIter=100;
%         %  training with Gentle AdaBoost
%         labels_train(labels_train==0)=-1;
%         [Learners, Weights] = RealAdaBoost(weak_learner, X_train', labels_train', MaxIter);
%         % evaluating on control set
%         prediction = sign(Classify(Learners, Weights, X_test'));
%         prediction = prediction';
%         prediction(prediction==-1)=0;
%         model = Learners;
    end
end