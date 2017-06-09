function S = sparse_encoding_ML(B, Xb, pars)
% this function is for encdoing based on sprase coding dictionary
    S= cgf_fitS_sc2(B, Xb, pars.sparsity_func, pars.noise_var, pars.beta, pars.epsilon, pars.sigma, pars.tol, false, false, false);
    S(find(isnan(S)))=0;
%     S_all(:,batch_idx)= S;
end