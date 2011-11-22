function c = pseudo_random_seq(len, c_init_dec)

% this function is used to generate pseudo-random sequence according to 7.2 in TS 36.211
% 
% mentor: Xiaolin Hou
% author: Wei Xi, xi@docomolabs-beijing.com.cn
% created on Aug. 19th, 2009.

Nc = 1600;
x1 = zeros(1, Nc + len);
x2 = zeros(1, Nc + len);

x1(1) = 1;

c_init_bin = dec2bin(c_init_dec, 31);
% transformation from string to number
for idx = 1: 31
    x2(idx) = str2double(c_init_bin(idx));
end

for n = 1: len - 31
    x1(n + 31) = mod(x1(n + 3) + x1(n), 2);
    x2(n + 31) = mod(x2(n + 3) + x2(n + 2) + x2(n + 1) + x2(n), 2);
end

c = mod(x1([1: len] + Nc) + x2([1: len] + Nc), 2);

return;