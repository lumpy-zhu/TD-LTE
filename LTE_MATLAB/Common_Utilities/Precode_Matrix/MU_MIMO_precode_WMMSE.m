function P = MU_MIMO_precode_WMMSE(H,MU_MIMO_precoding_WMMSE_params)
% this function computes the weighted MMSE precoding
% Created by Chongning Na, 2011 May 18
K = length(H);
W_MMSE = MU_MIMO_precoding_WMMSE_params.W_MMSE;
G = MU_MIMO_precoding_WMMSE_params.G;
S = MU_MIMO_precoding_WMMSE_params.S;
H_2D = cell2mat(H);
N_Tx = size(H_2D,2);
R_All = blkdiag(G{:});
T_All = inv(H_2D'*W_MMSE*H_2D+trace(W_MMSE*R_All*R_All')*eye(N_Tx))*H_2D'*W_MMSE;
T_All = T_All*sqrt(1/trace(T_All*T_All'));
P = cell(1,K);
idx_S_s = 1;
for k=1:K
    idx_S_e = idx_S_s + S{k} - 1;
    P{k}=T_All(:,idx_S_s:idx_S_e);
    idx_S_s = idx_S_e + 1;
end