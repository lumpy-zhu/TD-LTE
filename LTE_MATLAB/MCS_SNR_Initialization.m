function [LTE_link_params LTE_simu_params] = MCS_SNR_Initialization(ii_MCS, LTE_link_params)

LTE_link_params.MCS_index = ii_MCS;
LTE_link_params.MCS_params = gen_FDD_MCS_params(LTE_link_params.MCS_index,gen_MCS_params);
LTE_link_params.MCS_params.TC_decoding_max_iterations = 8;

LTE_simu_params = LTE_Get_SNR_dB_set(ii_MCS);