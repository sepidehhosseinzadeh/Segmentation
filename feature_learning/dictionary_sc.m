function D = dictionary_sc(patches, params)
% Train the dictionary with sparse coding (sc)
% Parameters:
%   patches:    image patches
%   params:     hyperparameters
% Return:
%   D:          dictionary

    % Parameters
%     nfeats = params.nfeats;

    % Patch-wise mean substraction
    % Each row of 'patches' is the receptive field of each patch
    D.mean = mean(patches); % mean of all patches on each pixel in the receptive field
    nX = bsxfun(@minus, patches, D.mean);

    % Train dictionary
    disp('Training Dictionary...');
% % %     params_sc.data = nX';
% % %     params_sc.Tdata = 1;
% % %     params_sc.dictsize = params.nfeats;
% % %     params_sc.iternum = params.D_iter;
% % %     params_sc.memusage = 'high';
    %params.exact= 1;
    %% sparse coding//dictionary learning//
    % opt_choice = 1: use epslion-L1 penalty
    % opt_choice = 2: use L1 penalty
    opt_choice = 1;
%     patch_size = params.rfSize(1);
%     patch_num = 10000;
    num_bases = params.nfeats;
    beta = 0.4;
    batch_size = 1000;
    num_iters = params.D_iter;
    
    [B pars] = demo_fast_sc(opt_choice,nX', num_bases,beta,batch_size,num_iters);
    save('pars.mat', 'pars');
    D.codes = B';
end