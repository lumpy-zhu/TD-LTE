function [crs_data LTE_link_params] =  LTE_Add_CRS(LTE_common_params, LTE_link_params, tx_precoded_data)
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
N_cp = LTE_common_params.N_cp;
N_Max_RB = LTE_common_params.N_Max_RB;
N_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
N_cell_ID = i - 1;
n_subfrm = LTE_link_params.n_subfrm;
[N_Tx N_SubC N_OFDM] = size(tx_precoded_data);

ns_total = [n_subfrm*2 n_subfrm*2+1];
N_OFDM_p_RB = N_OFDM/2;


grid_crs = zeros(N_Tx, N_SubC, N_OFDM);
i_Port = 0 : N_Tx-1;
for iPort = i_Port
    for ns = ns_total
        if iPort < 2
            arrayL = [0, N_OFDM_p_RB-3];
        else
            arrayL = 1;
        end
        for l = arrayL
            c_init = 2^10*(7*(ns+1)+l+1)*(2*N_cell_ID+1) + 2*N_cell_ID + N_cp;
            c = gen_length31_gold_sequence(4*N_Max_RB,c_init);
            r = 1/sqrt(2)*(1-2*c(1:2:end)) + 1i*1/sqrt(2)*(1-2*c(2:2:end));
            switch iPort
                case 0
                    if l == 0
                        v = 0;
                    else
                        v = 3;
                    end
                case 1
                    if l == 0
                        v = 3;
                    else
                        v = 0;
                    end
                case 2
                    v = 3*mod(ns,2);
                case 3
                    v = 3+3*mod(ns,2);
            end
            v_shift = mod(N_cell_ID,6);
            arrayM = 0:(2*N_RB-1);
            arrayK = 6*arrayM + mod(v+v_shift,6) + 1;
            arrayMprime = arrayM + N_Max_RB - N_RB + 1;
            sym_idx = l + (ns-ns_total(1)) * N_OFDM_p_RB + 1;
            grid_crs(iPort+1,arrayK,sym_idx) = r(arrayMprime);
        end
    end
end
crs_data = grid_crs + tx_precoded_data;
LTE_link_params.RS.grid_crs{i,j} = grid_crs;



% N_OFDM_p_subframe = LTE_common_params.N_OFDM_p_subframe;
% grid_crs = zeros(4,LTE_link_params.N_assigned_SubC_p_Layer,N_OFDM_p_subframe);
% grid_crs(:,:,:) = LTE_link_params.grid_crs(i,:,:,(n_subfrm-1)*N_OFDM_p_subframe+1 : n_subfrm*N_OFDM_p_subframe);
