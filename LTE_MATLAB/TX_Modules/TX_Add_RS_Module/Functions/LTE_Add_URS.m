function [urs_data LTE_link_params] =  LTE_Add_URS(LTE_common_params, LTE_link_params, tx_PRB_mapped_data)
% generate UE-specific reference signals on antenna port [7 8 11 13].
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
n_subfrm = LTE_link_params.n_subfrm;
N_Max_RB = LTE_common_params.N_Max_RB;
N_SubC_p_RB = LTE_common_params.N_SubC_p_RB;
if (n_subfrm == 1 || n_subfrm == 6)
    tt = 2;
else 
    tt = 5;
end


SCID = 0;
[N_SubC N_OFDM] = size(tx_PRB_mapped_data);
N_OFDM_p_RB = N_OFDM / 2;

N_RB = N_SubC / N_SubC_p_RB;
n_PRB = 0:N_RB-1;

grid_urs = zeros(N_SubC, N_OFDM);
r_urs = zeros(N_SubC, N_OFDM);

N_cell_ID = i-1;
switch N_cell_ID
    case 0
        iPort = [7 8];
    case 1
        iPort = [9 10];
end
i_port = iPort(j);

w_p = [ 1 1 1 1;
    1 -1 1 -1;
    1 1 1 1;
    1 -1 1 -1;
    1 1 -1 -1;
    -1 -1 1 1;
    1 -1 -1 1;
    -1 1 1 -1];

for ns_t = 0:1
    ns = n_subfrm*2+ns_t;
    c_init = 2 ^ 16 * ( floor(ns/2) + 1)*(2 * N_cell_ID + 1) + SCID;
    c = gen_length31_gold_sequence(24*N_Max_RB, c_init);
    r = (1 - 2 * c(1: 2: end) + 1j * (1 - 2 * c(2: 2: end))) / sqrt(2);
    m_p = [0 1 2];
    if mod(ns, 2)
        l_p = [2, 3];
    else
        l_p = [0, 1];
    end
    switch i_port
        case{7, 8, 11, 13}
            k_prime = 1;
        case{9, 10, 12, 14}
            k_prime = 0;
    end

    for m_prime = m_p
        k = 5*m_prime + N_SubC_p_RB * n_PRB +k_prime;
        for l_prime = l_p
            l = mod(l_prime, 2) + tt;
            b = mod( m_prime + n_PRB, 2);
            wp = zeros(size(b));
            for ii = 1:length(b)
                if b(ii)
                    wp(ii) = w_p(i_port-6,3-l_prime+1);
                else
                    wp(ii) = w_p(i_port-6,l_prime+1);
                end

            end
            
            grid_urs(k+1,ns_t*N_OFDM_p_RB+l+1) = wp .* r(3*l_prime*N_Max_RB + 3*n_PRB + m_prime+1);
            r_urs(k+1,ns_t*N_OFDM_p_RB+l+1) = r(3*l_prime*N_Max_RB + 3*n_PRB + m_prime+1);
            
        end
    end
end
urs_data = grid_urs + tx_PRB_mapped_data;
LTE_link_params.RS.grid_urs{i,j} = grid_urs;
LTE_link_params.RS.r_urs{i,j} = r_urs;
