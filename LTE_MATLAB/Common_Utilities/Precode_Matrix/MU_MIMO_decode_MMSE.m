function G = MU_MIMO_decode_MMSE(H_DMRS,MU_MIMO_decoding_MMSE_params)
% this function computes the MMSE MIMO decoding
% Created by Chongning Na, 2011 May 18
k = MU_MIMO_decoding_MMSE_params.k;
noise_covariance = MU_MIMO_decoding_MMSE_params.noise_covariance;
H_tmp = cell2mat(H_DMRS);
G = H_DMRS{k}'*inv(H_tmp*H_tmp'+noise_covariance{k});
G = ones(size(G));
G = G/sqrt(trace(G*G'));