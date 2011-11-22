function P = single_cell_MU_MIMO_precoder(H,MU_MIMO_precoding_type,MU_MIMO_precoding_params)
% this interface function calls the corresponding precoding matrix calculation function as
% defined in MU_MIMO_precoding_type; related parameters defined in
% MU_MIMO_precoding_params should be passed to the precoding function
% H has a cell structure , the dimension is defined as follows, H{K_MS}(N_AT_MS,N_AT_BS)
MU_MIMO_precoding_type(MU_MIMO_precoding_type==' ') = '_';
str_func_MU_MIMO_precoding = ['MU_MIMO_precode_' MU_MIMO_precoding_type];
P = eval([str_func_MU_MIMO_precoding '(H,MU_MIMO_precoding_params)']);