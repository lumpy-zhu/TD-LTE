function H_IC = LTE_Get_Precoding_Channel(LTE_common_params, LTE_link_params)
N_Tx = LTE_link_params.MIMO_params.N_Tx;
N_Rx = LTE_link_params.MIMO_params.N_Rx;
N_OFDM = LTE_common_params.N_OFDM_p_subframe;
N_SubC = LTE_link_params.N_assigned_RB_p_Layer * LTE_common_params.N_Symbol_p_RB / N_OFDM;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;
N_SubC_p_group = LTE_common_params.N_SubC_p_group;
N_group = N_SubC/N_SubC_p_group;
H_IC = cell(N_BS, N_BS, N_MS);
H_group = zeros(N_Rx, N_Tx, N_group);
for n_cell = 1:N_BS
    for i = 1:N_BS
        for j = 1:N_MS
            H_temp = LTE_link_params.channel.H_FFT{n_cell,i,j};
                for i_group = 1:N_group
                    H_group(:,:,i_group,:) = mean(H_temp(:,:,(i_group-1)*N_SubC_p_group+1 : i_group*N_SubC_p_group, end),3);
                end
            H_IC{n_cell,i,j} = H_group;
        end
    end
end
    