function [output] = LTE_Code_Block_Assembling(input,TC_control)
C = length(input);

if C==1
    % No extra CRC, return that the CRC was correct
    output = input{1}((TC_control.F+1):end);
else
    % First code block
    output = input{1}((TC_control.F+1):(end-24)); % Take out filler bits
    % Rest of code blocks
    for i=2:C
        % Check CRCs
        output = [output input{i}(1:(end-24))];
    end
end