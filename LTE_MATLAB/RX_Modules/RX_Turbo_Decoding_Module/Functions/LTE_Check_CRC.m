function crc_check_result = LTE_Check_CRC(data_and_crc,crc_type)
% this function checks the CRC of a given bits block
% input:
%     data_and_crc: data with crc bits attached at the end
%     crc_type: type of crc {24a, 24b, 16}
% output:
%     check_result: {0 = false, 1 = true}
% created by Chongning Na, Oct. 12, 2010

switch crc_type
    case '24a'
        fun_crc = @crc24a;
        data = data_and_crc(1:(end-24));
        crc = data_and_crc((end-23):end);
    case '24b'
        fun_crc = @crc24b;
        data = data_and_crc(1:(end-24));
        crc = data_and_crc((end-23):end);
    case '16'
        fun_crc = @crc16;
        data = data_and_crc(1:(end-16));
        crc = data_and_crc((end-15):end);
end

crc_check = byte2bit(fun_crc(bit2byte(logical(data))));
if any(crc_check-crc)
    crc_check_result = 0;
else
    crc_check_result = 1;
end