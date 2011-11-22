function [G_IA P_IA] = IA_CoMP_BF(H_IC,noise_power,MU_MIMO_BF_type,MU_MIMO_precoding_params)
% calculate IA based CoMP TX and RX beamforming matrices
% description of the algorithm can be found in:
% [1] Chongning Na, Interference Alignment based Multi-Stage Precoding
% for Multi-Cell Multi-User DL Cooperative Transmission, IRT, DBL, 2011
% input: interference channel H_IC{N_BS,N_BS,K_MS}(N_AT_MS,N_AT_BS,N_SubC,N_OFDM);
%        noise power: noise_power
%        MU_MIMO_BF_type: MU-MIMO beamforming method
%        MU_MIMO_precoding_params: MU0MIMO beamforming related parameters
% output: P_IA{N_BS,K_MS}(N_SubC,N_OFDM,N_AT_BS,S)
%         G_IA{N_BS,K_MS}(N_SubC,N_OFDM,S,N_AT_MS)
% Created by Chongning Na, 2011 May 10
% Last modified by Chongning Na, 2011 May 19
N_BS = size(H_IC,1);        % number of base stations
K_MS = size(H_IC,3);        % number of mobile stations per cell
N_AT_BS = size(H_IC{1,1,1},2);  % number of BS antennas
% this method only support 4 antenna case
if N_AT_BS == 4
    N_AT_BS_EQU = 3;
else
    error('this BS antenna number is not supported!')
end
N_AT_MS = size(H_IC{1,1,1},1);  % number of MS antennas
N_SubC = size(H_IC{1,1,1},3);   % number of subcarriers
N_OFDM = size(H_IC{1,1,1},4);   % number of OFDM symbols
G_IA = cell(N_BS,K_MS);         % initializing output precoding matrix 
P_IA = cell(N_BS,K_MS);         % initializing outpur decoding matrix
for n_SubC = 1:N_SubC
    for n_OFDM = 1:N_OFDM
        % virtual layer mapping via max eigen vector method see [1]
        P_PRE1 = zeros(N_AT_BS,N_AT_BS_EQU,N_BS);
        for i = 1:N_BS
            H_tmp = zeros(K_MS*N_AT_MS,N_AT_BS);
            for k = 1:K_MS
                idx_row = (k-1)*N_AT_MS + (1:N_AT_MS);
                H_tmp(idx_row,:) = H_IC{i,i,k}(:,:,n_SubC,n_OFDM);
            end
            [u s v] = svd(H_tmp);
            P_PRE1(:,:,i) = v(:,1:N_AT_BS_EQU);
        end
        H_IC_EQU = zeros(N_AT_MS,N_AT_BS_EQU,N_BS,N_BS,K_MS);
        H_temp = zeros(N_AT_MS,N_AT_BS);
        for i = 1:N_BS
            for j = 1:N_BS
                for k = 1:K_MS
                    H_temp(:,:) = H_IC{i,j,k}(:,:,n_SubC,n_OFDM);
                    H_IC_EQU(:,:,i,j,k) = H_temp*P_PRE1(:,:,i);
                end
            end
        end
        % interfernce alignment by solving linear equation, see [1]
        H_DMRS = zeros(K_MS,N_AT_BS_EQU,N_BS);
        G = zeros(1,N_AT_MS,N_BS,K_MS);
        h_ici = zeros(N_AT_BS_EQU,N_BS,N_BS);
        for i = 1:N_BS
            A = zeros(N_AT_BS_EQU*K_MS,N_AT_BS_EQU+N_AT_MS*K_MS);
            for k = 1:K_MS
                idx_row = (k-1)*N_AT_BS_EQU+(1:N_AT_BS_EQU);
                idx_col = (k-1)*N_AT_MS+(1:N_AT_MS)+N_AT_BS_EQU;
                A(idx_row,1:N_AT_BS_EQU) = eye(N_AT_BS_EQU);
                A(idx_row,idx_col) = -H_IC_EQU(:,:,3-i,i,k)';
            end
            [u s v] = svd(A);
            h_ici(:,3-i,3-i) = v(1:N_AT_BS_EQU,end)';
            for k = 1:K_MS
                G(1,:,i,k) = v(N_AT_BS_EQU+(k-1)*N_AT_MS+(1:N_AT_MS),end)';
                G(1,:,i,k) = G(1,:,i,k)/norm(G(1,:,i,k));
                H_DMRS(k,:,i) = G(1,:,i,k)*H_IC_EQU(:,:,i,i,k);
                G_IA{i,k}(:,:,n_SubC,n_OFDM) = G(1,:,i,k);
            end
        end
        P_PRE2 = zeros(N_AT_BS_EQU,K_MS,N_BS);
        for i = 1:N_BS
            [u s v] = svd(h_ici(:,i,i).');
            P_PRE2(:,:,i) = v(:,(end-K_MS+1):end);
        end
        % MU-MIMO precoding with given precoding configuration, see [1]
        for i = 1:N_BS
            H_EQU_MU_MIMO = cell(K_MS,1);
            P_SNR = cell(K_MS,1);
            for k = 1:K_MS
                H_EQU_MU_MIMO{k} = inv(sqrt(noise_power*G(1,:,i,k)*G(1,:,i,k)'))*H_DMRS(k,:,i)*P_PRE2(:,:,i);
                P_SNR{k} = 1;
            end
            MU_MIMO_precoding_params.noise_covariance = P_SNR;
            P_PRE3 = single_cell_MU_MIMO_precoder(H_EQU_MU_MIMO,MU_MIMO_BF_type,MU_MIMO_precoding_params);
            
            P = cell(K_MS,1);
            for k = 1:K_MS
                P{k} = P_PRE1(:,:,i)*P_PRE2(:,:,i)*P_PRE3{k};
                P_IA{i,k}(:,1,n_SubC,n_OFDM) = P{k};
            end
        end
    end
end