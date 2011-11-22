function LTE_link_params = LTE_Cal_Resources(LTE_common_params, LTE_link_params)
N_coded_bits_p_Layer = LTE_link_params.MCS_params.modulation_order * (...   % converts # of symbols to # of bits
    LTE_link_params.N_assigned_RB_p_Layer * LTE_common_params.N_Symbol_p_RB ... % total number of symbols of all available RBs
    - LTE_link_params.N_RS...                                       % # of symbols for RS
    - LTE_link_params.N_Symbol_OtherChannel);                                       % # of symbols occupied by other channels

switch LTE_link_params.MIMO_params.tx_mode
    case 'SISO'
        LTE_link_params.N_coded_bits = N_coded_bits_p_Layer;
        LTE_link_params.N_data_bits = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
            * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
            -24;                                                                        % subtract the number of CRC bits
    case 'Spatial_Multiplexing'
        switch LTE_link_params.MIMO_params.N_layers
            case 1
                LTE_link_params.N_coded_bits = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;
            case 2
                LTE_link_params.N_coded_bits(1:2) = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits(1:2) = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;                                                                        % subtract the number of CRC bits
            case 3
                LTE_link_params.N_coded_bits(1) = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits(1) = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;                                                                        % subtract the number of CRC bits
                LTE_link_params.N_coded_bits(2) = 2 * N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits(2) = 8 * round(1/8 * 2 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;                                                                        % subtract the number of CRC bits
            case 4
                LTE_link_params.N_coded_bits(1:2) = 2 * N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits(1:2) = 8 * round(1/8 * 2 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;   
            otherwise
                error('number of layers is not supported')
        end         
    case 'Transmit_Diversity'
        switch LTE_link_params.MIMO_params.N_layers
            case 2
                LTE_link_params.N_coded_bits = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;
            case 4
                LTE_link_params.N_coded_bits = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;
            otherwise
                error('number of layers is not supported')
        end
    case 'MU_MIMO'
        switch LTE_link_params.MIMO_params.N_layers
            case 2
                LTE_link_params.N_coded_bits(1:2) = N_coded_bits_p_Layer;
                LTE_link_params.N_data_bits(1:2) = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                    * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                    -24;                                                                        % subtract the number of CRC bits
            case 4
                switch LTE_link_params.MIMO_params.MU_MIMO_tx_mode
                    case 'single stream'
                        LTE_link_params.N_coded_bits = 2*N_coded_bits_p_Layer;
                        LTE_link_params.N_data_bits = 8 * round(1/8 * 2*N_coded_bits_p_Layer...   % number of coded bits
                            * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                            -24;
                    case 'multiple streams'
                        LTE_link_params.N_coded_bits(1:4) = N_coded_bits_p_Layer;
                        LTE_link_params.N_data_bits(1:4) = 8 * round(1/8 * N_coded_bits_p_Layer...   % number of coded bits
                            * LTE_link_params.MCS_params.coding_rate_x_1024 / 1024)...                  % multiplied by code rate
                            -24;
                end
        end
    otherwise
        error('specified MIMO transmission mode is not supported!')
end

LTE_link_params.G_prime = LTE_link_params.N_coded_bits / LTE_link_params.MIMO_params.N_layers / LTE_link_params.MCS_params.modulation_order;