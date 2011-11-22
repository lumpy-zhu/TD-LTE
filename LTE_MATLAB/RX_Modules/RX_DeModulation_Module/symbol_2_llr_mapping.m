function out_llr = symbol_2_llr_mapping(in_symbol,in_order)
out_llr = length(in_symbol);
for i = 1:in_order
    LB = (i-1)*2;
    UB = i*2;
    idx = find(in_symbol>=LB & in_symbol<=UB);
    out_llr(idx) = i*(i-1) - i*in_symbol(idx);
    idx = find(in_symbol<= -LB & in_symbol>=-UB);
    out_llr(idx) = -i*(i-1) - i*in_symbol(idx);
end