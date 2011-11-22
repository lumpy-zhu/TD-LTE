function [output_data, output_control]= LTE_Code_Block_Segmentation(input_data,LTE_params_common)
% this function divides the input bit stream into code blocks according to
% the process defined in 3GPP TS 36.212
% input:
%     input_data: input bit stream
%     LTE_params_common: structure that stores the common LTE parameters
%                           the LTE_NULL value and the interleaver table is needed in this function
% output:
%     output_data: output blocks (each block is appended a crc)
%     output_control: turbo coding control information, would be needed in the subsequent encoding process and decoding process
% created by Chongning Na, Oct. 12, 2010

LTE_NULL = LTE_params_common.LTE_NULL;

%% Segmentation parameters
% number of bits of the given Transport Block
B = length(input_data);
% max code block size defined in TS 36.212
Z = 6144;

% when the input block is shorter than the minimum allowable block size,
% add LTE_NULL to make the block size equal to 40
if B<40
    F = 40-B;
    output_data{1}(1:F) = LTE_NULL;
    output_data{1} = [output_data{1} input_data];
    C = 1;
    output_control.K_plus  = 40;
    output_control.K_minus = 0;
    output_control.F = F;
    output_control.C = C;
    return
end

% compute the segmentation parameters
if  B<=Z
	L = 0;
	C = 1;
    B_p = B;
else
	L = 24;
	C = ceil(B/(Z-L));
    B_p = B + C*L;
end

%% Get K+ and K-
% Calculate the index in the table from the Block size
avg_code_block_size = (B_p/C);
index_number = avg_code_block_size/8 - 4;
real_index = LTE_Get_TC_Block_Size(index_number,avg_code_block_size);

% First segmentation size K+ = minimum K in table 5.1.3-3 such that C*K>=B'
% Second segmentation size K- = maximum K in table 5.1.3-3 such that K- < K+
K_plus = LTE_params_common.TC_interleaver_table.k(ceil(real_index));
if C==1
    K_minus = 0;
else
    K_minus = LTE_params_common.TC_interleaver_table.k(ceil(real_index)-1);
end

%% Determine the segmentation
% calculate number of blocks of each size
if C==1
    C_plus = 1;
    K_minus = 0;
    C_minus = 0;
else
    diff_K = K_plus - K_minus;
    C_minus = floor((C*K_plus-B_p)/diff_K);
    C_plus = C - C_minus;
end

% Calculate number of filler bits
F = C_plus*K_plus + C_minus*K_minus - B_p;

%% Generate ouput (cell array of code blocks)
% preallocate resources
output_data = cell(C,1);
% add filler bits. 
output_data{1}(1:F) = LTE_NULL;
% add the rest of bits
k = F+1; %output position index
s = 1;   %input position index
for r=1:C
    if r<=C_minus
        K_r = K_minus;
    else
        K_r = K_plus;
    end
    bits_to_write = K_r-L;
    if r==1 %The first code block may have filler bits
        bits_to_write = bits_to_write-F;
    end
    output_data{r}(k:(k+bits_to_write-1)) = input_data(s:(s+bits_to_write-1));
    %Update position of indexes
    s = s + bits_to_write;
    k = 1;
end

% add 24b type crc to the code blocks when necessary
if C>1
    for i=1:C
        output_data{i} = LTE_Append_CRC(output_data{i},'24b',LTE_params_common);
    end
end

% Generate the data that will be signalled
output_control.F = F;               % number of filler bits
output_control.C = C;               % number of blocks in total
output_control.K_plus  = K_plus;    % first segmentation block size
output_control.K_minus = K_minus;   % second segmentation block size
output_control.Z = Z;               % max code block size
output_control.B = B;               % number of bits of the given Transport Block
for i=1:length(output_data)
    output_control.CB_sizes(i) = length(output_data{i});    % length of each block
end