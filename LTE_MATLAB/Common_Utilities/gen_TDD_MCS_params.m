function MCS_params = gen_TDD_MCS_params(type_modulation,codebits_1024)
MCS_params.CQI = 0;
MCS_params.modulation = type_modulation;
switch type_modulation
    case 'QPSK'
        MCS_params.modulation_order = 2;
    case '16QAM'
        MCS_params.modulation_order = 4;
    case '64QAM'
        MCS_params.modulation_order = 6;
end
MCS_params.coding_rate_x_1024 = codebits_1024;
MCS_params.efficiency = codebits_1024/1024*MCS_params.modulation_order;