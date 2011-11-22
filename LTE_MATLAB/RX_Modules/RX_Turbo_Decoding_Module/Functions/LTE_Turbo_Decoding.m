function [detected_data TC_control] = LTE_Turbo_Decoding(LLR_bits,block_idx,LTE_params,LTE_link_params,TC_control)
% TurboDecode decodes a received sequence that was encoded by a binary turbo code.  
% If input_decoder_c has multiple rows, then multiple codewords will be decoded (one for each row).
%
% The calling syntax is:
%     [detected_data, errors, output_decoder_c, [output_decoder_u] ] =
%                     TurboDecode( input_decoder_c, data, turbo_iterations, decoder_type,  ... 
%                          code_interleaver, pun_pattern, tail_pattern, g1, nsc_flag1, g2, ...
%                          nsc_flag2, [input_decoder_u] )
%
%     detected_data = a row vector containing the detected data
%     errors = a column vector containing the number of errors per
%              iteration for all the codewords.
%     output_decoder_c = the extrinsic information of the code bits
%     output_decoder_u = the extrinsic information of the systematic bits (optional)
%
%     input_decoder_c = the decoder input, in the form of bit LLRs
%                       this could have multiple rows if the data is longer
%                       than the interleaver
%     data = the row vector of data bits (used to count errors and for early halting of iterative decoding)
%     turbo_iterations = the number of turbo iterations
%     decoder_type = the decoder type
%              = 0 For linear-log-MAP algorithm, i.e. correction function is a straght line.
%              = 1 For max-log-MAP algorithm (i.e. max*(x,y) = max(x,y) ), i.e. correction function = 0.
%              = 2 For Constant-log-MAP algorithm, i.e. correction function is a constant.
%              = 3 For log-MAP, correction factor from small nonuniform table and interpolation.
%              = 4 For log-MAP, correction factor uses C function calls.
%     code_interleaver = the turbo interleaver
%     pun_pattern = the puncturing pattern for all but the tail
%     tail_pattern = the puncturing pattern just for the tail
%     g1 = the first generator polynomial
%     nsc_flag1 = 0 if first encoder is RSC and 1 if NSC
%     g2 = the second generator polynomial
%     nsc_flag2 = 0 if second encoder is RSC and 1 if NSC
%     [input_decoder_u] = the a priori information about systematic bits (optional input)
%
% Copyright (C) 2005-2006, Matthew C. Valenti
%
% Last updated on Apr. 23, 2006
%
% Function TurboDecode is part of the Iterative Solutions Coded Modulation
% Library (ISCML).  
%
% The Iterative Solutions Coded Modulation Library is free software;
% you can redistribute it and/or modify it under the terms of 
% the GNU Lesser General Public License as published by the 
% Free Software Foundation; either version 2.1 of the License, 
% or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public
% License along with this library; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

iterations = LTE_link_params.MCS_params.TC_decoding_max_iterations;

% Generator polynomial
g_turbo = [1 0 1 1
    1 1 0 1];
% Decoder type (code tested only with the max-log-map configuration, not with any other decoder type)
decoder_type = 1;

nsc_flag = 0; % Recursive-systematic code
% Get Code Block size
code_block_size = (size(LLR_bits,1)*size(LLR_bits,2)-12)/3;

% Get interleaver mapping
interleaver_mapping = LTE_Get_Interleaving_Mapping_Table(LTE_params,code_block_size);

% Add tail bits
y0_1 = [ LLR_bits(1,1:end-4) LLR_bits(1,end-3) LLR_bits(3,end-3) LLR_bits(2,end-2) ];
y1   = [ LLR_bits(2,1:end-4) LLR_bits(2,end-3) LLR_bits(1,end-2) LLR_bits(2,end-2) ];

y0_2 = zeros(size(y1)); % Initialize systematic part of second decoder with zero conforming CML. Thanks for finding this error go to Klaus Hueske :)
y2   = [ LLR_bits(3,1:end-4) LLR_bits(2,end-1) LLR_bits(1,end)   LLR_bits(3,end)   ];

SISO1_input = reshape([y0_1;y1],1,length(y0_1)+length(y1));
SISO2_input = reshape([y0_2;y2],1,length(y0_2)+length(y2));

%% Initialise APP from SISO1
SISO1_APP = zeros(1,code_block_size);

%% Choose which CRC to use to check the code blocks
% If the TB is just one code block, then CRC24a is used. If not, CRC24b.
switch TC_control.C
    case 1
        crc_type = '24a';
    otherwise
        crc_type = '24b';
end

%% Start iterations
for turbo_iteration = 1:iterations
    % First decoder
    SISO1_output = SisoDecode(SISO1_APP,SISO1_input,g_turbo,nsc_flag,decoder_type);
    % Second decoder
    SISO2_APP = LTE_Interleaving(SISO1_output-SISO1_APP,interleaver_mapping,1);
    SISO2_output = SisoDecode(SISO2_APP,SISO2_input,g_turbo,nsc_flag,decoder_type);
    SISO1_APP = LTE_Interleaving(SISO2_output-SISO2_APP,interleaver_mapping,0);
    
    % Get decoded bits so far
    decoded_bits = LTE_Interleaving(LTE_Hard_Decision(SISO2_output),interleaver_mapping,0);
    
%     % Get the data after deCRC
%     data_DCRC=F_CRC(decoded_bits,24,TC_control.CB_sizes(block_idx),TC_control.CB_sizes(block_idx),1);
%     err = any(data_DCRC(end-23:end));
%     

    if block_idx == 1
        decoded_bits(1:TC_control.F) = 0;
    end
    if TC_control.C == 1
        decoded_bits(1:TC_control.F) = [];
    end
    
    % If CRC is correct, halt iterations
    if LTE_Check_CRC(decoded_bits,crc_type)
        break;
    end
end
detected_data = LTE_Interleaving(LTE_Hard_Decision(SISO2_output),interleaver_mapping,0);
TC_control.check_crc_result(block_idx) = LTE_Check_CRC(decoded_bits,crc_type);