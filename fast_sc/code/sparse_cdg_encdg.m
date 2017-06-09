% sparse coding function call dictionary learning and encoding function

%% sparse coding//dictionary learning//
% opt_choice = 1: use epslion-L1 penalty
% opt_choice = 2: use L1 penalty
opt_choice = 1;
patch_size = 5;
patch_num = 10000;
num_bases = 32;
beta = 0.4;
batch_size = 1000;
num_iters = 100;

%% load image dataset size: m*n*k
% % % natural image data
load ../data/IMAGES.mat
% % % X = getdata_imagearray(IMAGES, 5, 100000);
% X here is a psize^2*p_num (eg. 25*100000)
X = getdata_imagearray(IMAGES, patch_size, patch_num);

% [B pars]= demo_fast_sc(opt_choice,X, patch_size,patch_num,num_bases,beta,batch_size,num_iters);
[B pars] = demo_fast_sc(opt_choice,X, num_bases,beta,batch_size,num_iters);

%% read images as patches
% % load ../results/sc_epsL1_b32_beta0.4_20151111T073340.mat
% % load pars.mat
%% sparse coding//encoding//
% S = SparseEncoding_ML(B, Xb, pars.sparsity_func, pars.noise_var, pars.beta, pars.epsilon, pars.sigma, pars.tol, false, false, false);
S = sparse_encoding_ML(B, X, pars);

Xrec = B*S;


