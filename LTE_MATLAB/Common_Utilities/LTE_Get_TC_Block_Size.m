function real_index = LTE_Get_TC_Block_Size(index_number,avg_code_block_size)
% this function gets the LTE turbo coding block size for the segmentation
% this function is faster than using find() to search
% input:
%     index_number: 
% output:
%     real_index:
    
if index_number > 60 && index_number <= 124
    real_index = avg_code_block_size/16 + 28;
elseif index_number > 124 && index_number <= 252
    real_index = avg_code_block_size/32 + 60;
elseif index_number > 252
    real_index = avg_code_block_size/64 + 92;
else
    real_index = index_number;
end