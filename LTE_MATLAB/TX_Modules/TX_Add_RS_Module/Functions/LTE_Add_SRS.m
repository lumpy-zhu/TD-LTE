function [srs_data LTE_link_params] = LTE_Add_SRS(LTE_common_params, LTE_link_params)
 
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
n_subfrm = LTE_link_params.n_subfrm;
N_Tx = LTE_link_params.MIMO_params.N_Tx;
N_MS = LTE_common_params.N_MS;

N_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
N_SubC_p_RB = LTE_common_params.N_SubC_p_RB;
N_SubC = N_RB * N_SubC_p_RB;
N_OFDM = LTE_common_params.N_OFDM_p_subframe;

port = 0:N_Tx-1;
grid_srs = zeros(N_Tx, N_SubC, N_OFDM);

ns = n_subfrm*2+1;
n_cs_SRS_t = 0 : N_Tx*N_MS - 1;
N_ap = N_MS;
l = N_OFDM; 
N_cell_ID = i-1;
seq_len = N_SubC;
r_uv = LTE_Gen_Base_Sequence(N_cell_ID, ns, N_RB, seq_len);
r_srs = zeros(size(r_uv));

for p = port
    t = n_cs_SRS_t((j-1)*N_Tx+p+1);
    alpha = 2*pi*t/N_Tx/N_MS;
    n = 0:length(r_uv)-1;
    r_SRS = exp(1j*alpha*n) .* r_uv;

    k_prime = 0:N_SubC/2-1;
    switch N_cell_ID
        case 0
            k0 = 0;
        case 1
            k0 = 1;
    end
    grid_srs(p+1, 2*k_prime+k0+1, l) = 1/sqrt(N_ap) * r_SRS(k_prime+1);
end
r_srs(2*k_prime+k0+1) =  r_uv(k_prime+1)* sqrt(N_ap);

srs_data = grid_srs;
LTE_link_params.RS.r_srs{i} = r_srs;
LTE_link_params.RS.grid_srs{i,j} = grid_srs;
