function H_IC = LTE_Initial_SRS(LTE_common_params, LTE_link_params, LTE_simu_params)
% the frame structure is DSUUD-DSUUDDSUUD, so in a frame, at first it
% should estimate H_IC for beamforming through subframe 2
LTE_link_params.link_type = 'UL';
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;
LTE_link_params = LTE_Change_DL_UL(LTE_common_params,LTE_link_params);

H_IC = cell(N_BS, N_BS, N_MS);

srs_data = cell(N_BS, N_MS);
LTE_link_params.n_subfrm = 2;
for i = 1:N_BS
    for j = 1:N_MS
        LTE_link_params.idx_bs = i;
        LTE_link_params.idx_ms = j;
        [srs_data{i,j} LTE_link_params] = LTE_Add_RS(LTE_common_params, LTE_link_params, 'SRS');
    end
end

LTE_simu_params.current_SNR = LTE_simu_params.current_SNR_UL;
[rx_data_RF LTE_link_params] = Pass_Through_Channel(srs_data, LTE_common_params, LTE_link_params, LTE_simu_params);
H_est = LTE_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params, 'SRS');

N_SubC = LTE_link_params.N_assigned_SubC_p_Layer;
N_SubC_p_group = LTE_link_params.N_SubC_p_group;
N_group = N_SubC/N_SubC_p_group;
for n_cell = 1:N_BS
    for i = 1:N_BS
        for j = 1:N_MS
            H_temp = H_est{n_cell,i,j};
            for i_group = 1:N_group
                H_group(:,:,i_group) = mean(H_temp(:,:,(i_group-1)*N_SubC_p_group+1 : i_group*N_SubC_p_group),3);
            end
            H_IC{n_cell,i,j} = H_group;
        end
    end
end


