function data = LTE_Remove_CRC(data_and_crc,crc_type)
switch crc_type
    case '24a'
        data = data_and_crc(1:(end-24));
    case '24b'
        data = data_and_crc(1:(end-24));
    case '16'
        data = data_and_crc(1:(end-16));
end