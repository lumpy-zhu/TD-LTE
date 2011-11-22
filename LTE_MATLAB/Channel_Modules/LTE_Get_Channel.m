function LTE_link_params = LTE_Get_Channel(LTE_common_params, LTE_link_params)
% in every subframe, it can get its own channel
N_OFDM = LTE_common_params.N_OFDM_p_subframe;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;
n_subfrm = LTE_link_params.n_subfrm;
for n_cell = 1:N_BS
    for i = 1:N_BS
        for j = 1:N_MS
            LTE_link_params.channel.H_FFT{n_cell,i,j} = LTE_link_params.channel.H_Frm{n_cell,i,j}(:,:,:,n_subfrm*N_OFDM+1:(n_subfrm+1)*N_OFDM);
        end
    end
end
LTE_link_params.MIMO_params.H_CSI_est = LTE_link_params.channel.H_FFT;
