function layered_data = LTE_Layer_Mapping(codewords,LTE_link_params)
if (strcmp(LTE_link_params.link_type,'UL'))
    layered_data = codewords;
else

    switch LTE_link_params.MIMO_params.tx_mode
        case 'SISO'
            layered_data = codewords{:,:};
        case 'Spatial_Multiplexing'
            switch LTE_link_params.MIMO_params.N_layers
                case 1
                    layered_data = codewords;
                case 2
                    layered_data(1,:) = codewords{1};
                    layered_data(2,:) = codewords{2};
                case 3
                    layered_data(1,:) = codewords{1};
                    layered_data(2,:) = codewords{2}(1:2:end);
                    layered_data(3,:) = codewords{2}(2:2:end);
                case 4
                    layered_data(1,:) = codewords{1}(1:2:end);
                    layered_data(2,:) = codewords{1}(2:2:end);
                    layered_data(3,:) = codewords{2}(1:2:end);
                    layered_data(4,:) = codewords{2}(2:2:end);
                otherwise
                    error('number of layers is not supported')
            end
        case 'Transmit_Diversity'
            switch LTE_link_params.MIMO_params.N_layers
                case 2
                    layered_data(1,:) = codewords{1}(1:2:end);
                    layered_data(2,:) = codewords{1}(2:2:end);
                case 4
                    layered_data(1,:) = codewords{1}(1:4:end);
                    layered_data(2,:) = codewords{1}(2:4:end);
                    layered_data(3,:) = codewords{1}(3:4:end);
                    layered_data(4,:) = codewords{1}(4:4:end);
                otherwise
                    error('number of layers is not supported')
            end
        case 'MU_MIMO'
            switch LTE_link_params.MIMO_params.N_layers
                case 2
                    layered_data(1,:) = codewords{1};
                    layered_data(2,:) = codewords{2};
                case 4
                    switch LTE_link_params.MIMO_params.MU_MIMO_tx_mode
                        case 'single stream'
                            layered_data(1,:) = codewords{1}(1:2:end);
                            layered_data(2,:) = codewords{1}(2:2:end);
                            layered_data(3,:) = codewords{2}(1:2:end);
                            layered_data(4,:) = codewords{2}(2:2:end);
                        case 'multiple streams'
                            layered_data(1,:) = codewords{1};
                            layered_data(2,:) = codewords{2};
                            layered_data(3,:) = codewords{3};
                            layered_data(4,:) = codewords{4};
                    end
            end
    end
end