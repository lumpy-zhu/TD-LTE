function [data_bits] = LTE_Gen_Info_Bits(i_cw, LTE_link_params)
% this function generates information bits
% input:
%       LTE_link_params: this struct contains all necessay information
%       about the current transmission
%       LTE_common_params: this struct contains common system parameters
% output:
%       data_bits: binary data bits
% created by Chongning Na, Nov. 2, 2010

switch LTE_link_params.data_source_type
    case 'random binary'
        if 0
            data_bits = randi(1,LTE_link_params.N_data_bits(i_cw));
        else
            data_bits = round(rand(1,LTE_link_params.N_data_bits(i_cw)));
        end
    case 'all zeros'
        data_bits = zeros(1,LTE_link_params.N_data_bits(i_cw));
    otherwise
        error('Data type is not supported! Please check if you have added user defined data type in the mat file.');
end