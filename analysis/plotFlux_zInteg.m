%%%
%%% plotFlux_zInteg.m
%%%
%%% Plot vertical integral of T/S fluxes
%%%

clear;
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;

prodir = '/Users/csi/MITgcm_ASF-csi/products-hires/';
load([prodir 'Flux_zInteg_hires.mat']);
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_HeatSaltFlux/'

rho_o = 1037;
Lx = 400000;
cp_o = 3850;

% %%% Plotting options
fontsize = 14;



nAtide  = 1:5;
Atide = [0 0.025 0.05 0.075 0.1];
nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];
nhi0 = 14:19;
hi0  = [0.2 0.6 1 1.4 1.8 2.2];
nws = 20:24;
ws = [25 50 75 100 125];
Ys = [150 175 200 225 250];
nbuoy = 25:30;
buoy = [33 33.59 34.17 34.38 34.59 34.69 34.79]-34.17; 

blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
% orange = [230 45 34]/255;
yellow = [0.9290 0.6940 0.1250];
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
gray2 = [249 249 249]/255;
olive = [107 142 35]/255;


figure(1)
clf;
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(25,:)/10^12,'LineWidth',4,'color',blue)
hold on
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(26,:)/10^12,'LineWidth',1,'color',lightblue)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(26,:)/10^12,'LineWidth',1,'color',blue)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(27,:)/10^12,'LineWidth',1,'color','k')
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(27,:)/10^12,'LineWidth',1,'color',lightblue)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(28,:)/10^12,'LineWidth',1,'color',yellow)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(29,:)/10^12,'LineWidth',1,'color',yellow)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(29,:)/10^12,'LineWidth',1,'color',orange)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(30,:)/10^12,'LineWidth',4,'color',orange)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(25,:)/10^12,'LineWidth',1.5)
% hold on
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(26,:)/10^12,'LineWidth',1.5)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(27,:)/10^12,'LineWidth',1.5)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(28,:)/10^12,'LineWidth',1.5)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(29,:)/10^12,'LineWidth',1.5)
% plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(30,:)/10^12,'LineWidth',1.5)
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)

% legend(...
%     'Very fresh, $\mathrm{\Delta \sigma_4}=-1.076\mathrm{kg\ m}^{-3}$',...
%     '$\mathrm{\Delta \sigma_4}=-0.620\mathrm{kg\ m}^{-3}$',...
%     'Ref., $\mathrm{\Delta \sigma_4}=-0.207\mathrm{kg\ m}^{-3}$',...
%     '$\mathrm{\Delta \sigma_4}=0.000\mathrm{kg\ m}^{-3}$',...
%     '$\mathrm{\Delta \sigma_4}=0.204\mathrm{kg\ m}^{-3}$',...
%     'Very dense, $\mathrm{\Delta \sigma_4}=0.409\mathrm{kg\ m}^{-3}$',...
%     'FontSize', fontsize,'interpreter','latex',...
%     'Position',[0.1437 0.1267 0.4197 0.2275]);


legend(...
    'Very fresh, S$_\mathrm{shelf}^\mathrm{bot}=33\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=33.59\ \mathrm{psu}$',...
    'Ref., S$_\mathrm{shelf}^\mathrm{bot}=34.17\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=34.43\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=34.70\ \mathrm{psu}$',...
    'Very dense, S$_\mathrm{shelf}^\mathrm{bot}=34.96\ \mathrm{psu}$',...
    'FontSize', fontsize,'interpreter','latex',...
    'Position',[0.1437 0.1267 0.4197 0.2275]);
set(gca,'FontSize', fontsize)

xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
title('Meridional Heat Transport','FontSize', fontsize+4,'interpreter','latex');

ylim([-4 0.5])
xlim([0 450])
% print('-dpng','-r150',[outdir 'heatflux_buoyancygradient-hires.png']);


%%




figure(2);
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(14,:)/10^12,'LineWidth',1.5)
hold on
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(15,:)/10^12,'LineWidth',1.5) 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(16,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(17,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(18,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(19,:)/10^12,'LineWidth',1.5)
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
hold off
set(gca,'FontSize', fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+4);
legend('h$_{i0}$ = 0.2 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 1 m',...
    'h$_{i0}$ = 1.4 m','h$_{i0}$ = 1.8 m','h$_{i0}$ = 2.2 m',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.2035 0.4015])

ylim([-0.5 0.35])
xlim([0 450])
% print('-dpng','-r150',[outdir 'heatflux_icethickness-hires.png']);






%%




figure(3);
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(1,:)/10^12,'LineWidth',1.5)
hold on
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(2,:)/10^12,'LineWidth',1.5) 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(3,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(4,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(5,:)/10^12,'LineWidth',1.5)
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
hold off
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional Heat Transport'},'interpreter','latex');
legend('A$_\mathrm{tide}$ = 0 m/s','A$_\mathrm{tide}$ = 0.025 m/s','A$_\mathrm{tide}$ = 0.05 m/s',...
    'A$_\mathrm{tide}$ = 0.075 m/s','A$_\mathrm{tide}$ = 0.1 m/s',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.2035 0.4015])
ylim([-1.5 0.5])
xlim([0 450])
print('-dpng','-r150',[outdir 'heatflux_tides-hires.png']);




%%
figure(4);
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(20,:)/10^12,'LineWidth',1.5)
hold on
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(21,:)/10^12,'LineWidth',1.5) 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(22,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(23,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(24,:)/10^12,'LineWidth',1.5)
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
hold off
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional Heat Transport'},'interpreter','latex');
legend('Ws = 50 km','Ws = 100 km','Ws = 150 km','Ws = 200 km','Ws = 250 km',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.2035 0.3])
ylim([-0.5 0.5])
xlim([0 450])
print('-dpng','-r150',[outdir 'heatflux_ws-hires.png']);






%%

nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];


figure(5);
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(6,:)/10^12,'LineWidth',1.5)
hold on
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(7,:)/10^12,'LineWidth',1.5) 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(8,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(9,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(10,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(12,:)/10^12,'LineWidth',1.5)
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg(13,:)/10^12,'LineWidth',1.5)
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
hold off
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional Heat Transport'},'interpreter','latex');
legend('Ua=0,Va=6 (unit:m/s)','Ua=-4,Va=6','Ua=-6,Va=6','Ua=-8,Va=6',...
    'Ua=-6,Va=4','Ua=-6,Va=8','Ua=-6,Va=12',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.1388 0.5839 0.3728 0.3359])
ylim([-0.5 0.5])
xlim([0 450])
print('-dpng','-r150',[outdir 'heatflux_wind-hires.png']);






%%
% set(gca,'fontsize',fontsize);
% set(gcf,'position',[220 694 453 238]);
% xlim([0 450]);
% % ylim([-1.1 1]);
% legend('Ws = 25 km','Ws = 75 km','Ws = 125 km','interpreter','latex', 'FontSize', fontsize-1)
% % legend('Fresh shelf, S$_{shelf}$=33 psu','Fresh shelf, S$_{shelf}$=34.17 psu',...
% %     'Medium-density shelf','Dense shelf','Very dense shelf','interpreter','latex', 'FontSize', fontsize-1)
% 
% % legend('No tide','Weak tides','Strong tides','interpreter','latex')
% % legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% % legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
% %     'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
% %     'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','FontSize', fontsize-3,'interpreter','latex')
% box on;
% saveas(gcf,[prodir '/HeatSaltFlux/' groupname '_vheat.png']);
% saveas(gcf,[prodir '/HeatSaltFlux/img_fig/' groupname '_vheat.fig']);


figure(2);
plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(1,:)/1e6,'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
hold on
plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(2,:)/1e6,'LineWidth',1.5,'color',[0 0.4470 0.7410])
plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(3,:)/1e6,'LineWidth',1.5,'color',[0.9290 0.6940 0.1250])

% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(4,:)/1e6,'LineWidth',1.5,'color',[102 178 255]/255)
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(5,:)/1e6,'-.','LineWidth',1.5,'color',[102 178 255]/255)
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(6,:)/1e6,'LineWidth',1.5,'color',[255 211 30]/255)
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(7,:)/1e6,'-.','LineWidth',1.5,'color',[255 211 30]/255)

% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(1,:)/1e6,'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(10,:)/1e6,'LineWidth',1.5);
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(23,:)/1e6,'LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);
% plot(yy/1000,rho_o*Lx/1000*VVELSLT_zint_xavg(24,:)/1e6,'LineWidth',1.5,'color',[0.6350 0.0780 0.1840]);

plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
hold off

xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^6$ kg/s)','FontSize', fontsize+2,'interpreter','latex');
title({'Depth-integrated Meridional Transport of Salt'},'interpreter','latex');
set(gca,'fontsize',fontsize);
set(gcf,'position',[220 694 453 238]);
xlim([0 450]);
% ylim([-8 3]);
legend('Ws = 25 km','Ws = 75 km','Ws = 125 km','interpreter','latex', 'FontSize', fontsize-1)
% legend('No tide','Weak tides','Strong tides','interpreter','latex')
% legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
saveas(gcf,[prodir '/HeatSaltFlux/' groupname '_vsalt.png']);
saveas(gcf,[prodir '/HeatSaltFlux/img_fig/' groupname '_vsalt.fig']);