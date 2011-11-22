function codewords = LTE_Layer_DeMapping(layered_data,LTE_link_params)
switch LTE_link_params.MIMO_params.tx_mode
    case 'SISO'
        codewords{1} = layered_data;
    case 'Spatial_Multiplexing'
        switch LTE_link_params.MIMO_params.N_layers
            case 1             
                codewords = layered_data;
            case 2
                for i = 1:2
                    codewords{i} = layered_data(i,:);
                end
            case 3
                codewords{1} = layered_data(1,:);
                codewords{2} = zeros(numel(layered_data(2:3,:)),1);
                codewords{2}(1:2:end) = layered_data(2,:);
                codewords{2}(2:2:end) = layered_data(3,:);
            case 4
                codewords{1} = zeros(numel(layered_data)/2,1);
                codewords{2} = zeros(numel(layered_data)/2,1);
                codewords{1}(1:2:end) = layered_data(1,:);
                codewords{1}(2:2:end) = layered_data(2,:);
                codewords{2}(1:2:end) = layered_data(3,:);
                codewords{2}(2:2:end) = layered_data(4,:);
            otherwise
                error('number of layers is not supported')
        end
    case 'Transmit_Diversity'
        switch LTE_link_params.MIMO_params.N_layers
            case 2
                codewords{1}=zeros(numel(layered_data),1);
                codewords{1}(1:2:end) = layered_data(1,:);
                codewords{1}(2:2:end) = layered_data(2,:);
            case 4
                codewords{1}=zeros(numel(layered_data),1);
                codewords{1}(1:4:end) = layered_data(1,:);
                codewords{1}(2:4:end) = layered_data(2,:);
                codewords{1}(3:4:end) = layered_data(3,:);
                codewords{1}(4:4:end) = layered_data(4,:);
            otherwise
                error('number of layers is not supported')
        end
    case 'MU_MIMO'
        switch LTE_link_params.MIMO_params.N_layers
            case 2
                codewords{1} = layered_data(1,:);
                codewords{2} = layered_data(2,:);
            case 4
                switch LTE_link_params.MIMO_params.MU_MIMO_tx_mode
                    case 'single stream'
                        codewords{1}(1:2:end) = layered_data(1,:);
                        codewords{1}(2:2:end) = layered_data(2,:);
                        codewords{2}(1:2:end) = layered_data(3,:);
                        codewords{2}(2:2:end) = layered_data(4,:);
                    case 'multiple streams'
                        codewords{1} = layered_data(1,:);
                        codewords{2} = layered_data(2,:);
                        codewords{3} = layered_data(3,:);
                        codewords{4} = layered_data(4,:);
                end
        end
end