function data_and_crc = LTE_Append_CRC(data,crc_type,LTE_params_common)
% this function computes the crc and append it to the given data
% input:
%     data: input bit stream
%     crc_type: type of crc {24a, 24b, 16}, depending on the crc type, this
%     function will call crc24a.mexw32 or crc24b.mexw32 or crc16.mexw32
%     bit2byte.mexw32 and byte2bit.mexw32 functions are needed to produce
%     the required data type for the crc functions
%     LTE_params_common: structure that stores the common LTE parameters
%                           the LTE_NULL value is needed in this function
% output:
%     data_and_crc: data and crc bits
% created by Chongning Na, Oct. 12, 2010

LTE_NULL = LTE_params_common.LTE_NULL;

switch crc_type
    case '24a'
        fun_crc = @crc24a;
    case '24b'
        fun_crc = @crc24b;
    case '16'
        fun_crc = @crc16;
end

% for crc computation, LTE_NULL valued elements are treated as 0
data(data==LTE_NULL) = 0;
crc = byte2bit(fun_crc(bit2byte(logical(data))));

data_and_crc = [data crc];