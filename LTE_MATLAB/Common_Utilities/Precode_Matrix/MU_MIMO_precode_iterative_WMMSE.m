function [P G] = MU_MIMO_precode_iterative_WMMSE(H,MU_MIMO_precoding_iterative_WMMSE_params)
% this function computes the iterative weighted MMSE precoding
% Created by Chongning Na, 2011 May 18
S = MU_MIMO_precoding_iterative_WMMSE_params.S;
MU_MIMO_init_precode_type = MU_MIMO_precoding_iterative_WMMSE_params.MU_MIMO_init_precode_type;
MU_MIMO_init_precode_params = MU_MIMO_precoding_iterative_WMMSE_params.MU_MIMO_init_precode_params;
tol = MU_MIMO_precoding_iterative_WMMSE_params.tol;
maxit = MU_MIMO_precoding_iterative_WMMSE_params.maxit;
K = length(H);

C_old = -Inf;
C_new = 0;

N_I = 1;

P_init = single_cell_MU_MIMO_precoder(H,MU_MIMO_init_precode_type,MU_MIMO_init_precode_params);

P = P_init;
noise_covariance = MU_MIMO_precoding_iterative_WMMSE_params.noise_covariance;
MU_MIMO_decoding_MMSE_params.noise_covariance = noise_covariance;
while C_new-C_old > tol && N_I < maxit
    N_I = N_I + 1;
    E = cell(K,1);
    G = cell(K,1);
    for k=1:K
        H_DMRS_P = cell(1,K);
        for kk = 1:K
            H_DMRS_P{kk} = H{k}*P{kk};
        end
        H_DMRS_2D = cell2mat(H_DMRS_P);
        MU_MIMO_decoding_MMSE_params.k = k;
        G{k} = MU_MIMO_decode_MMSE(H_DMRS_P,MU_MIMO_decoding_MMSE_params);
        E{k} = eye(S{k})+H_DMRS_P{k}'*inv(H_DMRS_2D*H_DMRS_2D'-H_DMRS_P{k}*H_DMRS_P{k}'+inv(noise_covariance{k}))*H_DMRS_P{k};
    end
    MU_MIMO_precoding_WMMSE_params.W_MMSE = blkdiag(E{:});
    MU_MIMO_precoding_WMMSE_params.G = G;
    MU_MIMO_precoding_WMMSE_params.S = S;
        
    H_DMRS_G = cell(K,1);
    for k=1:K
        H_DMRS_G{k} = G{k}*H{k};
    end
    P = MU_MIMO_precode_WMMSE(H_DMRS_G,MU_MIMO_precoding_WMMSE_params);
    C_old = C_new;
    C_new = MU_MIMO_calculate_capacity(H,P,G,noise_covariance);
end