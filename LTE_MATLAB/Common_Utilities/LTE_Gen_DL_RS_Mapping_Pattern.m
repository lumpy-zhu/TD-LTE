function LTE_link_params = LTE_Gen_DL_RS_Mapping_Pattern(LTE_common_params, LTE_link_params)
mapping = zeros(LTE_common_params.N_SubC_p_RB, 2*LTE_common_params.N_OFDM_p_RB);
% mapping(:,[1 2]) = 1; % reserved for pdcch, contain cell-specific rs
% mapping([4 10],[6 7]) = 1; % CSI rs
% mapping([1 2 6 7 11 12],[6 7 13 14]) = 1; % ue-specific rs
% mapping(1:3:end,[5 8 9 12]) = 1; % cell-specific rs
%%%%%%%%%% UE-specific RS %%%%%%%%%%%%%%%
N_OFDM_p_RB = LTE_common_params.N_OFDM_p_RB;
grid_urs = zeros(size(mapping));
for ns = 0:1
    m_p = [0 1 2];
    if mod(ns, 2)
        l_p = [2, 3];
    else
        l_p = [0, 1];
    end
    k_prime = [0 1];
    for m_prime = m_p
        k = 5*m_prime +k_prime;
        for l_prime = l_p
            l = mod(l_prime, 2) + 5;
            grid_urs(k+1,ns*N_OFDM_p_RB+l+1) = 1;
        end
    end
end
mapping = mapping + grid_urs;
%%%%%%%%%% Cell-specific RS %%%%%%%%%%%%%%%
grid_crs = zeros(size(mapping));
for iPort = 0:3
    for ns = [0 1]
        if iPort < 2
            arrayL = [0, N_OFDM_p_RB-3];
        else
            arrayL = 1;
        end
        for l = arrayL
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
            for N_cell_ID = 0
                v_shift = mod(N_cell_ID,6);
                arrayM = 0:1;
                arrayK = 6*arrayM + mod(v+v_shift,6) + 1;
                sym_idx = l + ns * N_OFDM_p_RB + 1;
                grid_crs(arrayK,sym_idx) = 1;
            end
        end
    end
end
mapping = mapping + grid_crs;

%%%%%%%%%% CSI-RS %%%%%%%%%%%%%%%
grid_csi = zeros(size(mapping));
k_p = 9;
l_p = 5;
subfrm = LTE_link_params.n_subfrm;
N_cp = LTE_common_params.N_cp;
if mod(subfrm, 5) == 0
    for i_port = 0:3
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
        k = k_p + tmp;
        l_pp = [0 1];
        l = l_p + l_pp;
        grid_csi(k+1,l+1) = 1;
    end
end
mapping = mapping + grid_csi;

%%%%%%%%% reserved for PDCCH %%%%%%%%%
mapping(mapping(:,[1 2]) == 0) = 1;
%%%


LTE_link_params.N_RS = sum(sum(mapping))*LTE_link_params.N_assigned_RB_p_Layer/2;
LTE_link_params.RS_mapping_p_PRBpair = mapping;



