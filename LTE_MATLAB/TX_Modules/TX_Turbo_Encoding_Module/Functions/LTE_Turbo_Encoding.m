function coded_bits = LTE_Turbo_Encoding(data, LTE_params_common, block_idx, TC_control)
% this function encodes a data block using a binary turbo encoder.  
% input:
%     data: input bit stream
%     LTE_params_common: structure that stores the common LTE parameters
%                           the LTE_NULL value and the interleaver table is needed in this function
%     block_idx: the index of the block (block No.)
%     TC_control: control information for coding and decoding
% output:
%     coded_bits: encoded bits
% created by: Chongning Na, Oct. 11, 2010

LTE_NULL = LTE_params_common.LTE_NULL;

% code block size
code_block_size = length(data);

% Get interleaver mapping
interleaver_mapping = LTE_Get_Interleaving_Mapping_Table(LTE_params_common,code_block_size);

% Interleave one input
input_to_e1 = data;
input_to_e2 = LTE_Interleaving(data,interleaver_mapping,1);

% The same generator poly for the convolutional encoders
generator_poly = [
    1 0 1 1 
    1 1 0 1 ];

% We are using a RSC code, this flag signals it
nsc_flag = 0;

% Encode the input sequence. The output already contains the terminating bits
encoded_bits_1 = ConvEncode(logical(input_to_e1),generator_poly,nsc_flag);
encoded_bits_2 = ConvEncode(logical(input_to_e2),generator_poly,nsc_flag);

data_size = code_block_size;

% Append the encoded data bits
encoded_bits = [
    encoded_bits_1(1,1:data_size) % Systematic bits:       d_k^0
    encoded_bits_1(2,1:data_size) % Parity from encoder 1: d_k^1
    encoded_bits_2(2,1:data_size) % Parity from encoder 2: d_k^2
    ];

% If the code block to be encoded is the 0-th code block and the number of filler bits is greater than zero,
% i.e., F > 0, then the encoder shall set c_k=0, k=0,??,(F-1) at its input and shall set  d^0_k=<NULL>, 0,??,(F-1) and
% d^1_k=<NULL>, 0,??,(F-1) at its output.
if block_idx==1
    if TC_control.F>0
        encoded_bits([1 2],1:TC_control.F) = LTE_NULL;
    end
end

% Add the tailing bits according to what TS36.212, Section 5.1.3.2.2 says
tail_bits = [
    encoded_bits_1(1,data_size+1) encoded_bits_1(2,data_size+2) encoded_bits_2(1,data_size+1) encoded_bits_2(2,data_size+2)
    encoded_bits_1(2,data_size+1) encoded_bits_1(1,data_size+3) encoded_bits_2(2,data_size+1) encoded_bits_2(1,data_size+3)
    encoded_bits_1(1,data_size+2) encoded_bits_1(2,data_size+3) encoded_bits_2(1,data_size+2) encoded_bits_2(2,data_size+3)
    ];

coded_bits = [ encoded_bits tail_bits ];