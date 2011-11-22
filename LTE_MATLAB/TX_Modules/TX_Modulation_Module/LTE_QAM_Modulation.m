function d_symbol=LTE_QAM_Modulation(data_in, LTE_link_params)

modulation_order = LTE_link_params.MCS_params.modulation_order;

m_bits_per_num = modulation_order/2;
%check the length is proper for conversion
Len = length(data_in);
if mod(Len,modulation_order)~=0
    disp('Input length must be multiplication of 2 and bit_per_symbol!');
end
bit_i=reshape(data_in(1:2:Len),m_bits_per_num,Len/modulation_order);
bit_q=reshape(data_in(2:2:Len),m_bits_per_num,Len/modulation_order);
OutTemp_i=zeros(1,Len/modulation_order);
OutTemp_q=zeros(1,Len/modulation_order);
for ii=1:m_bits_per_num
    OutTemp_i=OutTemp_i+bit_i(ii,:)*2^(m_bits_per_num-ii);
    OutTemp_q=OutTemp_q+bit_q(ii,:)*2^(m_bits_per_num-ii);
end

switch modulation_order
    case 2
        symbol_I=(1-2*OutTemp_i)./sqrt(2);
        symbol_Q=(1-2*OutTemp_q)./sqrt(2);
    case 4
        book_code=[1,3,-1,-3];
        symbol_I=book_code(OutTemp_i+1)./sqrt(10);
        symbol_Q=book_code(OutTemp_q+1)./sqrt(10);

    case 6
        book_code=[3, 1, 5, 7,-3,-1,-5,-7];
        symbol_I=book_code(OutTemp_i+1)./sqrt(42);
        symbol_Q=book_code(OutTemp_q+1)./sqrt(42);
    otherwise
        disp('wrong because of m again');
end
d_symbol=symbol_I+1i*symbol_Q;