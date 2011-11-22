function [link_statistics] = LTE_PDSCH_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params)
%addpath ./Common_Utilities/
LTE_simu_params.current_SNR = LTE_simu_params.current_SNR_DL;

% LTE_simu_params.current_SNR = LTE_simu_params.SNR_dB_set;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;

bler = cell(N_BS,N_MS);
ber = cell(N_BS,N_MS);
throughput= cell(N_BS,N_MS);
for i = 1:N_BS
    for j =1:N_MS
        bler{i,j} = zeros(LTE_link_params.MIMO_params.N_codewords,1);
        ber{i,j} = zeros(LTE_link_params.MIMO_params.N_codewords,1);
        throughput{i,j} = zeros(LTE_link_params.MIMO_params.N_codewords,1);
    end
end


%% initialize
LTE_link_params = LTE_Beamforming(LTE_common_params, LTE_link_params, LTE_simu_params);

%% codeword generation
tx_source_bits = cell (N_BS, N_MS);
tx_codeword = cell (N_BS, N_MS);
LTE_link_params = LTE_Cal_Resources(LTE_common_params, LTE_link_params);

for i = 1:N_BS
    for j = 1:N_MS
        LTE_link_params.idx_bs = i;
        LTE_link_params.idx_ms = j;
        for i_cw = 1:LTE_link_params.MIMO_params.N_codewords
            % ==data generation==
            [tx_data_bits] = LTE_Gen_Info_Bits(i_cw, LTE_link_params);
            tx_source_bits{i,j}(i_cw,:) = tx_data_bits;

            % ==channel coding==
            [tx_coded_bits TC_control{i,j}(i_cw,:)] = LTE_Channel_Encoding(tx_data_bits, i_cw, LTE_common_params, LTE_link_params);

            % ==scrambling==
            switch LTE_link_params.MIMO_params.N_codewords
                case 2
                    q = i_cw;
                case 1
                    q = 0;
                otherwise
                    error('number of codewords is not supported');
            end
            tx_scrambled_bits = LTE_Scrambling(tx_coded_bits, q, eNodeB, UE, LTE_common_params, LTE_link_params);

            % ==modulation==
            tx_data_symbol = LTE_QAM_Modulation(tx_scrambled_bits,LTE_link_params);
            tx_codeword{i,j}(i_cw,:) = tx_data_symbol;
%             tx_codeword{i,j}(i_cw,:) = zeros(size(tx_data_symbol));
        end

        %% layer mapping
        tx_layered_data{i,j} = LTE_Layer_Mapping(tx_codeword{i,j},LTE_link_params);

        %% resource mapping
        tx_PRB_mapped_data{i,j} = LTE_Resource_Mapping(tx_layered_data{i,j},LTE_common_params,LTE_link_params);

        %% add UE-specific RS
        [tx_data_urs{i,j} LTE_link_params] = LTE_Add_RS(LTE_common_params, LTE_link_params, 'URS', tx_PRB_mapped_data{i,j});

        %% precoding
        tx_precoded_data{i,j}= LTE_Precoding(tx_data_urs{i,j},LTE_link_params);

        %% add cell-specific RS
        [tx_data_crs{i,j} LTE_link_params] = LTE_Add_RS(LTE_common_params, LTE_link_params, 'CSI', tx_precoded_data{i,j});

        %% final TX interface
        tx_data_RF{i,j} = tx_precoded_data{i,j};
    end
end


%% pass through channel
[rx_data_RF LTE_link_params] = Pass_Through_Channel(tx_data_RF, LTE_common_params, LTE_link_params, LTE_simu_params);

%%
for i = 1:N_BS
    for j = 1:N_MS
        LTE_link_params.idx_bs = i;
        LTE_link_params.idx_ms = j;

        %% Channel estimation
        H_est = LTE_Channel_Estimation(rx_data_RF{i,j}, LTE_common_params, LTE_link_params, 'DL');

        %% MIMO detection
        rx_demapped_data{i,j} = LTE_MIMO_Detection(rx_data_RF{i,j}, LTE_link_params, H_est);

        %% resource demapping
        rx_layered_data{i,j} = LTE_Resource_DeMapping(rx_demapped_data{i,j},LTE_link_params);

        %% layer demapping
        rx_codeword{i,j} = LTE_Layer_DeMapping(rx_layered_data{i,j}, LTE_link_params);

        for i_cw = 1:LTE_link_params.MIMO_params.N_codewords
            % ==demodulation==
            rx_data_llr = LTE_Soft_QAM_Demodulation(rx_codeword{i,j}(i_cw,:),LTE_link_params);

            % ==descrambling==
            switch LTE_link_params.MIMO_params.N_codewords
                case 2
                    q = i_cw;
                case 1
                    q = 0;
                otherwise
                    error('number of codewords is not supported');
            end
            rx_data_descrambled = LTE_DeScrambling(rx_data_llr, q, eNodeB, UE, LTE_common_params, LTE_link_params);

            % ==channel decoding==
            [rx_data_bits{i,j} TC_control{i,j}] = LTE_Channel_Decoding(rx_data_descrambled,LTE_common_params,LTE_link_params,TC_control{i,j});

            % ==data analysis==
            [bler{i,j}(i_cw,:) ber{i,j}(i_cw,:)] = LTE_Check_Info_Bits(tx_source_bits{i,j},rx_data_bits{i,j},i_cw,LTE_link_params,TC_control{i,j});

            throughput{i,j} = TC_control{i,j}.check_crc_result* LTE_link_params.N_data_bits/(1e-3)/ LTE_link_params.N_assigned_SubC_p_Layer / 15e3;
        end
    end
end


% clear tx_* rx_* TC_control;
link_statistics.bler = bler;
link_statistics.ber = ber;
link_statistics.throughput = throughput;
% link_statistics.throughput = [];
link_statistics.snr = LTE_simu_params.current_SNR;