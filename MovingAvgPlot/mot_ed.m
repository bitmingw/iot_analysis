%motivation for event detection
clear;
clc;

t = 1:0.05:50;
ns = normrnd(0,1, length(t),1);
y = cos(t) + ns';

y(10*20) = 11;
y(44*20) = -9;

plot(t,y, 'LineWidth', 2.5);
xlabel('time(s)', 'fontsize',18);
ylabel('Signal', 'fontsize',18);
set(gca,'fontsize',18)