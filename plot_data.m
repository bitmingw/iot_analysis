%M = readtable('Lexington+weather+10-29-15.xlsx')
clc;
clear;


lexington_data = xlsread('Lexington+weather+10-29-15.xlsx');
marlboro_data =  xlsread('Marlboro+weather+10-29-15.xlsx');
poughkeepsie_data = xlsread('Poughkeepsie+weather+10-29-15.xlsx');


idx_tem = 1;
idx_wind = 20;
idx_vap = 10;
idx_dairp = 11;
idx_waird = 17;
idx_rainr = 41;
flg_plot = false;
alpha = 0.25;
w = 30;
type = 1;

d_lex = [lexington_data(:,idx_tem), lexington_data(:,idx_wind),...
    lexington_data(:,idx_vap), lexington_data(:,idx_dairp),...
    lexington_data(:,idx_waird), lexington_data(:,idx_rainr)];



d_mar = [marlboro_data(:,idx_tem), marlboro_data(:,idx_wind),...
    marlboro_data(:,idx_vap), marlboro_data(:,idx_dairp),...
    marlboro_data(:,idx_waird), marlboro_data(:,idx_rainr)];

d_pou = [poughkeepsie_data(:,idx_tem), poughkeepsie_data(:,idx_wind),...
    poughkeepsie_data(:,idx_vap), poughkeepsie_data(:,idx_dairp),...
    poughkeepsie_data(:,idx_waird), poughkeepsie_data(:,idx_rainr)];

[a,b] = size(d_lex);
%multi-variable
t2 = zeros(a,1);

time = (0:1/60:48);



[mv_mu, mv_phi] = mv_thd_bound(d_mar(:,1:2), w, type);

for i = 1:a
   t2(i) = w*(d_lex(i,1:2)-mv_mu(i,:))*(mv_phi(2*i-1:2*i,:))*(d_lex(i,1:2)-mv_mu(i,:))' ;
   if t2(i) > 800
       t2(i) = 800;
   elseif t2(i) < 0
       t2(i) = 0;
   end
    
end





for i = 1:6
[d_pred, Err] = uni_EWMA(d_mar(:,i), alpha);
[mu, phi] = thd_bound(d_mar(:,i), w, type);

figure(i)
plot(time(1:length(mu))', mu-3*phi, 'r', 'LineWidth', 2.5);
hold on
plot(time(1:length(mu))', mu+3*phi, 'b', 'LineWidth', 2.5);
hold on
%plot(d_pred, 'k');
%hold on
plot(time(1:length(mu))', d_mar(:,i), 'k', 'LineWidth', 2.5);
xlim([0 49]);
h = legend('$\hat{\mu}+3\hat{\theta}$', '$\hat{\mu}-3\hat{\theta}$', 'Raw Data');
set(h,'Interpreter','latex', 'fontsize',24);
xlabel('Time (hours)', 'fontsize',24);
set(gca,'fontsize',18);
hold off;
switch i
    case 1
        title('Temperature');
        ylabel('K', 'fontsize',24);
    case 2
        title('Average Wind Speed');
        ylabel('Wind Speed(m/s)', 'fontsize',24);
    case 3
        title('Vaport Pressure');
    case 4
        title('Dry Air Pressure');
    case 5
        title('Wet Air Density');
    case 6
        title('Rain Rate')
    otherwise
        title('Unknown Parameter');
end


%event_idx = find(lex_d_pred>(lex_mu+3*lex_phi));
event_idx = find(d_mar(:,i)<(mu-3*phi) | d_mar(:,i)>(mu+3*phi));

end



if flg_plot == true

    figure(1);
    %title('Temperature')
    subplot(3,1,1)
    plot(lexington_data(:,idx_tem))
    title('Temperature')
    subplot(3,1,2)
    plot(marlboro_data(:,idx_tem));
    subplot(3,1,3)
    plot(poughkeepsie_data(:,idx_tem));

    figure(2);
    %title('Wind_speed_average')
    subplot(3,1,1)
    plot(lexington_data(:,idx_wind))
    title('Wind speed average')
    subplot(3,1,2)
    plot(marlboro_data(:,idx_wind));
    subplot(3,1,3)
    plot(poughkeepsie_data(:,idx_wind));


    figure(3);
    %title('Vapor_Pressure')
    subplot(3,1,1)
    plot(lexington_data(:,idx_vap))
    title('Vaport pressure')
    subplot(3,1,2)
    plot(marlboro_data(:,idx_vap));
    subplot(3,1,3)
    plot(poughkeepsie_data(:,idx_vap));



    figure(4);
    %title('Dry_Air_Pressure')
    subplot(3,1,1)
    plot(lexington_data(:,idx_dairp))
    title('Dry air pressure')
    subplot(3,1,2)
    plot(marlboro_data(:,idx_dairp));
    subplot(3,1,3)
    plot(poughkeepsie_data(:,idx_dairp));


    figure(5);
    %title('Wet_Air_Density')
    subplot(3,1,1)
    plot(lexington_data(:,idx_waird))
    title('Wet air density')
    subplot(3,1,2)
    plot(marlboro_data(:,idx_waird));
    subplot(3,1,3)
    plot(poughkeepsie_data(:,idx_waird));

end


[mar_mu, mar_phi] = thd_bound(d_mar(:,2), w, type);
[lex_mu, lex_phi] = thd_bound(d_lex(:,2), w, type);
[pou_mu, pou_phi] = thd_bound(d_pou(:,2), w, type);

figure;
plot(time(1:length(lex_mu)), lex_mu+3*lex_phi, 'k', 'LineWidth', 2.5);
hold on;
plot(time(1:length(mar_mu)), mar_mu+3*mar_phi, 'b', 'LineWidth', 2.5);
hold on;
plot(time(1:length(pou_mu)), pou_mu+3*pou_phi, 'r', 'LineWidth', 2.5);

h = legend('Lexington', 'Marlboro', 'Pougkeepsie');
set(h, 'fontsize',24);
xlabel('Time (hours)', 'fontsize',24);
ylabel('Wind Speed(m/s)', 'fontsize',24);
set(gca,'fontsize',18);

hold off;




%locations of weather stations (p, m, l)
%x = [41.708202;41.612339; 42.237212]
%y = [-73.917317; -73.979529; -74.358636]
%z(1,1,:)= poughkeepsie_data(:,3);
%z(41.612339,73.979529,:) = marlboro_data(:,3);
%z(42.237212,74.358636,:) = lexington_data(:,3);
%figure(2);
%surf(z)%
%figure(3)
%plot3(z)