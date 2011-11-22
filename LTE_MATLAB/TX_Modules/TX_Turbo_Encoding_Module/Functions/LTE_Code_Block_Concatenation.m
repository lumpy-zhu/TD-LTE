function output = LTE_Code_Block_Concatenation(input)
output = input{1};
for i=2:length(input)
    output=[output input{i}];
end