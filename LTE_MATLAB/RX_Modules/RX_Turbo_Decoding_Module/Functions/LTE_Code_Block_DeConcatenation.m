function output = LTE_Code_Block_DeConcatenation(input, TC_control)
output = cell(TC_control.C,1);
idx_end = 0;
for i = 1:TC_control.C
    idx_start = idx_end + 1;
    idx_end = idx_start - 1 + TC_control.E(i);
    idx = idx_start:idx_end;
    output{i} = input(idx);
end