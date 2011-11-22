function [G_IA P_IA] = nonCoMP_BF(H_IC,noise_power,MU_MIMO_BF_type,MU_MIMO_precoding_params)
% calculate IA based CoMP TX and RX beamforming matrices
% input: interference channel H_IC{N_BS,N_BS,K_MS}(N_AT_MS,N_AT_BS,N_SubC,N_OFDM);
%        noise power: noise_power
%        MU_MIMO_BF_type: MU-MIMO beamforming method
%        MU_MIMO_precoding_params: MU-MIMO beamforming related parameters
% output: P_IA{N_BS,K_MS}(N_SubC,N_OFDM,N_AT_BS,S)
%         G_IA{N_BS,K_MS}(N_SubC,N_OFDM,S,N_AT_MS)
% Created by Chongning Na, 2011 May 10
% Last modified by Chongning Na, 2011 May 19

N_BS = size(H_IC,1);            % number of BSs
K_MS = size(H_IC,3);            % number of MSs
N_SubC = size(H_IC{1,1,1},3);   % number of subcarriers
N_OFDM = size(H_IC{1,1,1},4);   % number of OFDM symbols
G_IA = cell(N_BS,K_MS);         % RX BF matrices
P_IA = cell(N_BS,K_MS);         % TX BF matrices
for n_SubC = 1:N_SubC
    for n_OFDM = 1:N_OFDM
        for i = 1:N_BS          % each cell implement selfish MU-MIMO beamforming
            H_EQU_MU_MIMO = cell(K_MS,1);
            P_SNR = cell(K_MS,1);
            for k = 1:K_MS
                H_EQU_MU_MIMO{k} = inv(sqrt(noise_power))*H_IC{i,i,k}(:,:,n_SubC,n_OFDM);
                P_SNR{k} = 1;
            end
            MU_MIMO_precoding_params.noise_covariance = P_SNR;
            P_MU_MIMO = single_cell_MU_MIMO_precoder(H_EQU_MU_MIMO,MU_MIMO_BF_type,MU_MIMO_precoding_params);
            G_MU_MIMO = cell(K_MS,1);
            for k = 1:K_MS
                H_DMRS_P = cell(1,K_MS);
                for kk = 1:K_MS
                    H_DMRS_P{kk} = H_EQU_MU_MIMO{k}*P_MU_MIMO{kk};
                end
                MU_MIMO_decoding_MMSE_params.k = k;
                MU_MIMO_decoding_MMSE_params.noise_covariance = P_SNR;
                G_MU_MIMO{k} = MU_MIMO_decode_MMSE(H_DMRS_P,MU_MIMO_decoding_MMSE_params);
            end
            for k = 1:K_MS
                P_IA{i,k}(:,:,n_SubC,n_OFDM) = P_MU_MIMO{k};
                G_IA{i,k}(:,:,n_SubC,n_OFDM) = G_MU_MIMO{k};
            end
        end
    end
end