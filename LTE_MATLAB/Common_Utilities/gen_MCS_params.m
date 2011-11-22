function CQI_params = gen_MCS_params()

%% Store CQI parameters
% CQI 1 is index 1, CQI 2 is index 2, etc...
CQI_params(1).CQI = 1;
CQI_params(1).modulation = 'QPSK';
CQI_params(1).modulation_order = 2;
CQI_params(1).coding_rate_x_1024 = 78;
CQI_params(1).efficiency = 0.1523;

CQI_params(2).CQI = 2;
CQI_params(2).modulation = 'QPSK';
CQI_params(2).modulation_order = 2;
CQI_params(2).coding_rate_x_1024 = 120;
CQI_params(2).efficiency = 0.2344;

CQI_params(3).CQI = 3;
CQI_params(3).modulation = 'QPSK';
CQI_params(3).modulation_order = 2;
CQI_params(3).coding_rate_x_1024 = 193;
CQI_params(3).efficiency = 0.3770;

CQI_params(4).CQI = 4;
CQI_params(4).modulation = 'QPSK';
CQI_params(4).modulation_order = 2;
CQI_params(4).coding_rate_x_1024 = 308;
CQI_params(4).efficiency = 0.6016;

CQI_params(5).CQI = 5;
CQI_params(5).modulation = 'QPSK';
CQI_params(5).modulation_order = 2;
CQI_params(5).coding_rate_x_1024 = 449;
CQI_params(5).efficiency = 0.8770;

CQI_params(6).CQI = 6;
CQI_params(6).modulation = 'QPSK';
CQI_params(6).modulation_order = 2;
CQI_params(6).coding_rate_x_1024 = 602;
CQI_params(6).efficiency = 1.1758;

CQI_params(7).CQI = 7;
CQI_params(7).modulation = '16QAM';
CQI_params(7).modulation_order = 4;
CQI_params(7).coding_rate_x_1024 = 378;
CQI_params(7).efficiency = 1.4766;

CQI_params(8).CQI = 8;
CQI_params(8).modulation = '16QAM';
CQI_params(8).modulation_order = 4;
CQI_params(8).coding_rate_x_1024 = 490;
CQI_params(8).efficiency = 1.9141;

CQI_params(9).CQI = 9;
CQI_params(9).modulation = '16QAM';
CQI_params(9).modulation_order = 4;
CQI_params(9).coding_rate_x_1024 = 616;
CQI_params(9).efficiency = 2.4063;

CQI_params(10).CQI = 10;
CQI_params(10).modulation = '64QAM';
CQI_params(10).modulation_order = 6;
CQI_params(10).coding_rate_x_1024 = 466;
CQI_params(10).efficiency = 2.7305;

CQI_params(11).CQI = 11;
CQI_params(11).modulation = '64QAM';
CQI_params(11).modulation_order = 6;
CQI_params(11).coding_rate_x_1024 = 567;
CQI_params(11).efficiency = 3.3223;

CQI_params(12).CQI = 12;
CQI_params(12).modulation = '64QAM';
CQI_params(12).modulation_order = 6;
CQI_params(12).coding_rate_x_1024 = 666;
CQI_params(12).efficiency = 3.9023;

CQI_params(13).CQI = 13;
CQI_params(13).modulation = '64QAM';
CQI_params(13).modulation_order = 6;
CQI_params(13).coding_rate_x_1024 = 772;
CQI_params(13).efficiency = 4.5234;

CQI_params(14).CQI = 14;
CQI_params(14).modulation = '64QAM';
CQI_params(14).modulation_order = 6;
CQI_params(14).coding_rate_x_1024 = 873;
CQI_params(14).efficiency = 5.1152;

CQI_params(15).CQI = 15;
CQI_params(15).modulation = '64QAM';
CQI_params(15).modulation_order = 6;
CQI_params(15).coding_rate_x_1024 = 948;
CQI_params(15).efficiency = 5.5547;

CQI_params(16).CQI = 16;
CQI_params(16).modulation = 'QPSK';
CQI_params(16).modulation_order = 2;
CQI_params(16).coding_rate_x_1024 = 1024/3;
CQI_params(16).efficiency = 2/3;

CQI_params(17).CQI = 17;
CQI_params(17).modulation = '16QAM';
CQI_params(17).modulation_order = 4;
CQI_params(17).coding_rate_x_1024 = 1024/2;
CQI_params(17).efficiency = 4/2;