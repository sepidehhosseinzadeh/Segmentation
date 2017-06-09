function dictionary = run_omp1(X, k, iterations, verbose, initial)
% Parameters
% X: assume it's m by n, m is the number of training patches, n is the number of pixels of each patch
% k: number of features
% iterations: number of iterations
% Returns:
% dictionary: dictionary
  if ~exist('verbose','var'); verbose = 1; end

  % initialize dictionary
  if exist('initial','var')
      dictionary = zeros(k, size(X, 2));
      dictionary(:,1:60) = initial;
  else
      dictionary = randn(k, size(X,2)); % random matrix, k by n
  end
  dictionary = bsxfun(@rdivide, dictionary, sqrt(sum(dictionary.^2,2)+1e-20)); % right divide dictionary by the squared root of each row of dictionary

  for itr=1:iterations
    if mod(itr,10) == 0 && verbose == 1; fprintf(1,'Running GSVQ:  iteration=%d... \n', itr); end

    % do assignment + accumulation
    [summation,counts] = gsvq_step(X, dictionary);

    % reinit empty clusters
    I=find(sum(summation.^2,2) < 0.001); % take the sum of each feature along all training patches, filter out if the it's too small, i.e. not significant
    summation(I,:) = randn(length(I), size(X,2)); % reinit

    % normalize
    dictionary = bsxfun(@rdivide, summation, sqrt(sum(summation.^2,2)+1e-20));
  end


function [summation, counts] = gsvq_step(X, dictionary)
% Run a single step of gain shape vector quantization
  summation = zeros(size(dictionary)); % k by n
  counts = zeros(size(dictionary,1),1); % k by 1

  k = size(dictionary,1);

  BATCH_SIZE=2000;

  tic;
  for i=1:BATCH_SIZE:size(X,1)
    lastInd=min(i+BATCH_SIZE-1, size(X,1)); % process one BATCH at a time
    m = lastInd - i + 1;

    dots = dictionary*X(i:lastInd,:)'; % k by BATCH
    [val,labels] = max(abs(dots)); % get labels, lables has dimension of 1 x BATCH, each column is the feature index that maximize D'*X

    E = sparse(labels,1:m,1,k,m,m); % labels as indicator matrix; there's m non-zero elements in E; E is the feature/code vector
    counts = counts + sum(E,2);  % sum up counts

    dots = dots .* E; % dots is now sparse, E_k(i) = 1 when k is the feature j that maximizes D'*X; otherwise E_k(i)=0
    summation = summation + dots * X(i:lastInd,:); % take sum, weighted by dot product

  end
