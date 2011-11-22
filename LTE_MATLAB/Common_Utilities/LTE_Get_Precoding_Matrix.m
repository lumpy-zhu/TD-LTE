function LTE_link_params = LTE_Get_Precoding_Matrix(LTE_common_params, LTE_link_params)
% H_ul = H_dl', G_ul = P_dl' ,P_ul = G_dl', N_Rx_ul = N_Tx_dl, N_Rx_dl = N_Tx_ul
G_IA = LTE_link_params.G_IA; 
P_IA = LTE_link_params.P_IA;
if strcmp(LTE_link_params.link_type,'UL') 
    
    [N_s N_Tx N_SubC N_OFDM] = size(G_IA{1,1});
    N_Rx = size(P_IA{1,1},1);
    N_BS = LTE_common_params.N_BS;
    N_MS = LTE_common_params.N_MS;
    
    LTE_link_params.G_IA = cell(size(P_IA));
    LTE_link_params.P_IA = cell(size(G_IA));

    for i_bs = 1:N_BS
        for j_bs = 1:N_BS
            for i_ms = 1:N_MS         
                H_temp = LTE_link_params.channel.H_FFT{i_bs,j_bs,i_ms};
                LTE_link_params.channel.H_FFT{i_bs,j_bs,i_ms} = permute(H_temp,[2 1 3 4]);

                if(j_bs == 1)
                    LTE_link_params.G_IA{i_bs,i_ms} = zeros(N_s,N_Rx,N_SubC,N_OFDM);
                    G_temp = P_IA{i_bs,i_ms};
                    LTE_link_params.G_IA{i_bs,i_ms} = permute(G_temp,[2 1 3 4]);

                    LTE_link_params.P_IA{i_bs,i_ms} = zeros(N_Tx,N_s,N_SubC,N_OFDM);
                    P_temp = G_IA{i_bs,i_ms};
                    LTE_link_params.P_IA{i_bs,i_ms} = permute(P_temp,[2 1 3 4]);
                end
            end
        end
    end

    LTE_link_params.MIMO_params.N_Rx = N_Rx;
    LTE_link_params.MIMO_params.N_Tx = N_Tx;
end
