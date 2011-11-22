function mapping_table = LTE_Get_Interleaving_Mapping_Table(LTE_params,code_block_size)
% Generates the interleaver mapping for a given block size.
% [mapping] = LTE_common_turbo_encoder_generate_interleaving_mapping(code_block_size)
% Author: Josep Colom Ikuno, jcolom@nt.tuwien.ac.at
% (c) 2008 by INTHFT
% www.nt.tuwien.ac.a
%
% input:    code_block_size  ... Code Block size in bits
% 
% output:   mapping          ... The mapping (0-indexed, not as in Matlab). In
%                                the standard it is 0-indexed, so I left it like that!
%
% date of creation: 2008/08/11
% last changes:


%% Calculate the index in the table from the Block size
index_number = code_block_size/8 - 4;

if index_number > 60 && index_number <= 124
    real_index = code_block_size/16 + 28;
elseif index_number > 124 && index_number <= 252
    real_index = code_block_size/32 + 60;
elseif index_number > 252
    real_index = code_block_size/64 + 92;
else
    real_index = index_number;
end

if real_index-floor(real_index)~=0 || real_index-floor(real_index)<0
    error(['The given Code Block size' num2str(code_block_size) 'is not valid']);
end

%% Get the f1 and f2 values
f1 = LTE_params.TC_interleaver_table.f1(real_index);
f2 = LTE_params.TC_interleaver_table.f2(real_index);

%% Calculate the mapping for the interleaver 
mapping_table = mod(f1*(0:(code_block_size-1))+f2*(0:(code_block_size-1)).^2,code_block_size) + 1; % 1-indexed!!