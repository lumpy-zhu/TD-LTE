function y = get_post(x)
j = 1;
for i = 1:length(x)
    if x(i) ~= 0
        y(j) = i;
        j = j + 1;
    end
end
    