hh = gca;
get(hh);
h = get(hh,'Children');
xi = (-10:2:28)';
yi = zeros(7,20);
for i = 1:7
    x = get(h(i),'XData')';
    y = get(h(i),'YData')';
    yi(i,:) = interp1q(x,y,xi);
end

yi = max(yi);

figure(2)
grid on;
hold on;
plot(xi,yi);