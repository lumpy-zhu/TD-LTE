function r = Modified_Jakes(fd,deltaT,N)

omiga = 2*pi*fd;
M = 8;
r = zeros(1,N);
theta = (2*rand - 1)*pi;
t = [1:N]*deltaT;

for n = 1:M
    phi = (2*rand - 1)*pi;
    psi = (2*rand - 1)*pi;
    r = r + (cos(omiga*t*cos((2*pi*n - pi + theta)/(4*M)) + phi) + j*cos(omiga*t*sin((2*pi*n - pi + theta)/(4*M)) + psi));
end

r = r*sqrt(1/M);