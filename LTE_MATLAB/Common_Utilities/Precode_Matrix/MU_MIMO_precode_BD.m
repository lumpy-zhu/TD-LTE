function P = MU_MIMO_precode_BD(H,MU_MIMO_precoding_BD_params)
% this function computes the BD precoding
% Created by Chongning Na, 2011 May 18
S = MU_MIMO_precoding_BD_params.S; 
K = length(H);
P = cell(1,K);
for k=1:K
    H_tmp = H;
    H_tmp{k} = [];
    H_tilde_k = cell2mat(H_tmp);
    [u s v] = svd(H_tilde_k);
    L = length(s(s>0));
    V0 = v(:,(L+1):end);
    [u s v] = svd(H{k} * V0);
    V1 = v(:,1:S);
    P{k} = V0*V1/sqrt(K*S);
end