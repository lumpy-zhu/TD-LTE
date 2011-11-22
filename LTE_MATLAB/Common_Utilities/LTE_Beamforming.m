function [LTE_link_params] = LTE_Beamforming(LTE_common_params, LTE_link_params, LTE_simu_params)
noise_power = 10^(-LTE_simu_params.current_SNR/10);
N_SubC = LTE_link_params.N_assigned_SubC_p_Layer;
N_SubC_p_group = LTE_link_params.N_SubC_p_group;
N_OFDM = LTE_common_params.N_OFDM_p_subframe;
N_group = N_SubC/N_SubC_p_group;

N_BS = LTE_common_params.N_BS;  
N_MS = LTE_common_params.N_MS;
H_IC = LTE_link_params.channel.H_IC;
MU_MIMO_BF_type = 'BD';
MU_MIMO_BF_params.S = 1;
frm = LTE_link_params.frm;
[G P] = TD_MU_MIMO_BF(H_IC,frm,noise_power,MU_MIMO_BF_type,MU_MIMO_BF_params);
% [G P] = IA_CoMP_BF(H_IC,noise_power,MU_MIMO_BF_type,MU_MIMO_BF_params);
% here G or P is a small size matrix beacause of the consideration of stability in frequence domain,
% so we need to restore it to suitable scale.

G_IA = cell(size(G));
P_IA = cell(size(P));

for i = 1:N_BS
    for j = 1:N_MS
        G_IA{i,j} = repmat(zeros(size(G{1,1})),[1 1 N_SubC_p_group N_OFDM]);
        P_IA{i,j} = repmat(zeros(size(P{1,1})),[1 1 N_SubC_p_group N_OFDM]);
        for i_group = 1:N_group
            G_IA{i,j}(:,:,(i_group-1)*N_SubC_p_group+1 : i_group*N_SubC_p_group,:) = repmat(G{i,j}(:,:,i_group,:),[1 1 N_SubC_p_group N_OFDM]);
            P_IA{i,j}(:,:,(i_group-1)*N_SubC_p_group+1 : i_group*N_SubC_p_group,:) = repmat(P{i,j}(:,:,i_group,:),[1 1 N_SubC_p_group N_OFDM]);
        end
    end
end
LTE_link_params.G_IA = G_IA;
LTE_link_params.P_IA = P_IA;

