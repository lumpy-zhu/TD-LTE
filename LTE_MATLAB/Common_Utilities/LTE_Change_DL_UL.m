function LTE_link_params = LTE_Change_DL_UL(LTE_common_params,LTE_link_params)
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;
for i_bs = 1:N_BS
    for j_bs = 1:N_BS
        for i_ms = 1:N_MS
            H_temp = LTE_link_params.channel.H_FFT{i_bs,j_bs,i_ms};
            LTE_link_params.channel.H_FFT{i_bs,j_bs,i_ms} = permute(H_temp,[2 1 3 4]);
        end
    end
end

N_Tx = LTE_link_params.MIMO_params.N_Tx;
N_Rx = LTE_link_params.MIMO_params.N_Rx;

LTE_link_params.MIMO_params.N_Rx = N_Tx;
LTE_link_params.MIMO_params.N_Tx = N_Rx;