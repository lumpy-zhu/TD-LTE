function [result] = LTE_Frm_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params, LTE_channel_params,frm)
LTE_link_params.frm = frm;
LTE_link_params = LTE_Channel_Initialization(LTE_common_params,LTE_link_params,LTE_channel_params,LTE_simu_params);
% update H_Frm, H_IC, H_IC_tmp
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;

dl_bler = zeros(1, N_BS*N_MS);
dl_ber = zeros(1, N_BS*N_MS);
ul_ber = zeros(1, N_BS*N_MS);
ul_bler = zeros(1, N_BS*N_MS);
dl_throughput = zeros(1, N_BS*N_MS);
ul_throughput = zeros(1, N_BS*N_MS);
n_dl = 0;
n_ul = 0;

for subfrm = 1: length(LTE_common_params.frm_str)
    flag = LTE_common_params.frm_str(subfrm);
    LTE_link_params.n_subfrm = subfrm-1;
    LTE_link_params = LTE_Get_Channel(LTE_common_params, LTE_link_params);
    
    switch flag
        case 'D'
            LTE_link_params.link_type = 'DL';
            LTE_link_params = LTE_Gen_DL_RS_Mapping_Pattern(LTE_common_params, LTE_link_params);
            
            n_dl = n_dl + 1;
            
            LTE_link_params.channel.H_IC = LTE_link_params.channel.H_IC_tmp;
            stat = LTE_PDSCH_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params);
            i = mod(frm, 2)+1;
            for j = 1:N_MS
                index = (i-1)*N_MS+j;
                dl_bler(index) = dl_bler(index) + stat.bler{i,j};
                dl_ber(index) = dl_ber(index) + stat.ber{i,j};
                dl_throughput(index) = dl_throughput(index) + stat.throughput{i,j};
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'S'
            LTE_link_params.link_type = 'DL';
            LTE_link_params = LTE_Gen_SP_RS_Mapping_Pattern(LTE_common_params, LTE_link_params);
            
            n_dl = n_dl + 1;
            [stat H_IC]= LTE_SP_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params);
            LTE_link_params.channel.H_IC_tmp = H_IC;
            
            i = mod(frm, 2)+1;
            for j = 1:N_MS
                index = (i-1)*N_MS+j;
                dl_bler(index) = dl_bler(index) + stat.bler{i,j};
                dl_ber(index) = dl_ber(index) + stat.ber{i,j};
                dl_throughput(index) = dl_throughput(index) + stat.throughput{i,j};
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%
        case 'U'
            LTE_link_params.link_type = 'UL';
            LTE_link_params = LTE_Gen_UL_RS_Mapping_Pattern(LTE_common_params, LTE_link_params);
            n_ul = n_ul + 1;
            stat = LTE_PUSCH_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params);
            
            i = mod(frm, 2)+1;
            for j = 1:N_MS
                index = (i-1)*N_MS+j;
                ul_bler(index) = ul_bler(index) + stat.bler{i,j};
                ul_ber(index) = ul_ber(index) + stat.ber{i,j};
                ul_throughput(index) = ul_throughput(index) + stat.throughput{i,j};
            end
            
            
    end
end
result.dl_bler = dl_bler/n_dl*2;
result.dl_ber = dl_ber/n_dl*2;
result.dl_throughput = dl_throughput;
result.ul_bler = ul_bler/n_ul*2;
result.ul_ber = ul_ber/n_ul*2;
result.ul_throughput = ul_throughput;
