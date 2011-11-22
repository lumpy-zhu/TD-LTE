function LTE_link_params = LTE_Channel_Initialization(LTE_common_params,LTE_link_params,LTE_channel_params,LTE_simu_params)

[H_Frm H_FFT] = LTE_Gen_MIMO_Channel(LTE_common_params,LTE_link_params,LTE_channel_params);
LTE_link_params.channel.H_Frm = H_Frm;
LTE_link_params.channel.H_FFT = H_FFT;
% LTE_link_params.controller = 0;
switch LTE_link_params.controller
    case 1
        H_IC = LTE_Initial_SRS(LTE_common_params, LTE_link_params, LTE_simu_params);
    case 0
        H_IC = LTE_Get_Precoding_Channel(LTE_common_params,LTE_link_params);    
end
LTE_link_params.channel.H_IC = H_IC;
LTE_link_params.channel.H_IC_tmp = H_IC;
% LTE_link_params.controller = 1;