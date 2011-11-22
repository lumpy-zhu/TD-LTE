function [csi_data LTE_link_params] = LTE_Add_CSI(LTE_common_params, LTE_link_params, tx_precoded_data)
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
N_cp = LTE_common_params.N_cp;
N_Max_RB = LTE_common_params.N_Max_RB;
N_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
N_cell_ID = i - 1;
n_subfrm = LTE_link_params.n_subfrm;
[N_Tx N_SubC N_OFDM] = size(tx_precoded_data);
ns = n_subfrm*2;
port = 0:N_Tx-1;

grid_csi = zeros(N_Tx, N_SubC, N_OFDM);

k_p = 9;
l_p = 5;

m = 0:N_RB - 1;
m_p = m + floor((N_Max_RB - N_RB)/2);
subfrm = LTE_link_params.n_subfrm;
N_cp = LTE_common_params.N_cp;
if mod(subfrm, 5) == 0
    for i_port = port
        p = 15 + i_port;
        if N_cp == 1
            switch p
                case {15,16}
                    tmp = 0;
                case {17,18}
                    tmp = -6;
            end

        elseif N_cp == 0
            switch p
                case {15,16}
                    tmp = 0;
                case {17,18}
                    tmp = -3;
            end
        end
        k = k_p + 12*m + tmp;
        for l_pp = 0:1
            l = l_p + l_pp;
            switch p
                case {15,17,19,21}
                    wl_pp = 1;
                case {16,18,20,22}
                    wl_pp = (-1)^l_pp;
            end
            c_init = 2^10*(7*(ns+1)+l+1)*(2*N_cell_ID+1) + 2*N_cell_ID + N_cp;
            c = gen_length31_gold_sequence(4*N_Max_RB,c_init);
            r = 1/sqrt(2)*(1-2*c(1:2:end)) + 1i*1/sqrt(2)*(1-2*c(2:2:end));

            grid_csi(i_port+1,k+1,l+1) = wl_pp * r(m_p+1);
        end
    end
end
csi_data = grid_csi + tx_precoded_data;
LTE_link_params.RS.grid_csi{i,j} = grid_csi;