function LTE_link_params = LTE_Initialization(LTE_common_params, LTE_link_params, LTE_simu_params)

LTE_link_params = LTE_Beamforming(LTE_common_params, LTE_link_params, LTE_simu_params);

LTE_link_params = LTE_Get_Precoding_Matrix(LTE_common_params, LTE_link_params);

