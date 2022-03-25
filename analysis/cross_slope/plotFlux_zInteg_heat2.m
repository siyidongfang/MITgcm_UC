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







%%
% figure(1);
% clf
% l0=plot(yy/1000,cp_o*rho_o*VVELTH_zint_xavg(14,:)/10^6 ,'LineWidth',1.5)
% hold on
% l1=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(15,:)/10^6 ,'LineWidth',1.5) 
% l2=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(16,:)/10^6 ,'LineWidth',1.5)
% l3=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(17,:)/10^6 ,'LineWidth',1.5)
% l4=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(18,:)/10^6 ,'LineWidth',1.5)
% l5=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(19,:)/10^6 ,'LineWidth',1.5)
% plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
% line([125 125],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% line([175 175],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% hold off
% set(gca,'FontSize', fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
% title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+4);
% legend([l0 l1 l2 l3 l4 l5],'h$_{i0}$ = 0.2 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 1 m',...
%     'h$_{i0}$ = 1.4 m','h$_{i0}$ = 1.8 m','h$_{i0}$ = 2.2 m',...
%     'interpreter','latex','FontSize', fontsize+1,'Position',[0.6545 0.5550 0.1835 0.1748])
% text(50,0.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(135,0.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(260,0.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% ylim([-4 0.5])
% xlim([0 450])
% set(gcf,'OuterPosition',[267 121 639 734])
% 
% print('-dpng','-r150',[outdir 'new_heatflux_icethickness-hires.png']);
% 
% 
% 
% %%
% figure(1);
% clf
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(14,:)/10^6 ,'LineWidth',1.5,'color',gray)
% hold on;
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(15,:)/10^6 ,'LineWidth',1.5,'color',gray) 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(16,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(17,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(18,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(19,:)/10^6 ,'LineWidth',1.5,'color',gray)
% 
% l1=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(20,:)/10^6 ,'LineWidth',1.5)
% l2=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(21,:)/10^6 ,'LineWidth',1.5) 
% l3=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(22,:)/10^6 ,'LineWidth',1.5)
% l4=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(23,:)/10^6 ,'LineWidth',1.5)
% l5=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(24,:)/10^6 ,'LineWidth',1.5)
% 
% 
% plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
% line([125 125],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% line([175 175],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% hold off
% set(gca,'FontSize', fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
% title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+4);
% legend([l1,l2,l3,l4,l5],'Ws = 50 km','Ws = 100 km','Ws = 150 km','Ws = 200 km','Ws = 250 km',...
%     'interpreter','latex','FontSize', fontsize+1,'Position',[0.6144 0.6076 0.2064 0.1466])
% text(50,0.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(135,0.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(260,0.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% 
% ylim([-4 0.5])
% xlim([0 450])
% set(gcf,'OuterPosition',[267 121 639 734])
% 
% print('-dpng','-r150',[outdir 'new_heatflux_Ws-hires.png']);
% 
% 
% 
% 
% %%
% figure(1);
% clf
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(14,:)/10^6 ,'LineWidth',1.5,'color',gray)
% hold on;
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(15,:)/10^6 ,'LineWidth',1.5,'color',gray) 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(16,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(17,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(18,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(19,:)/10^6 ,'LineWidth',1.5,'color',gray)
% 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(20,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(21,:)/10^6 ,'LineWidth',1.5,'color',gray) 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(22,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(23,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(24,:)/10^6 ,'LineWidth',1.5,'color',gray)
% 
% 
% l1=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(6,:)/10^6 ,'LineWidth',1.5);
% l2=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(7,:)/10^6 ,'LineWidth',1.5); 
% l3=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(8,:)/10^6 ,'LineWidth',1.5);
% l4=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(9,:)/10^6 ,'LineWidth',1.5);
% l5=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(10,:)/10^6 ,'LineWidth',1.5);
% l6=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(12,:)/10^6 ,'LineWidth',1.5);
% l7=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(13,:)/10^6 ,'LineWidth',1.5);
% 
% plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
% line([125 125],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% line([175 175],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% hold off
% set(gca,'FontSize', fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
% title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+4);
% legend([l1,l2,l3,l4,l5,l6,l7],'Ua=0,Va=6 (unit:m/s)','Ua=-4,Va=6','Ua=-6,Va=6','Ua=-8,Va=6',...
%     'Ua=-6,Va=4','Ua=-6,Va=8','Ua=-6,Va=12',...
%     'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5295 0.5405 0.3023 0.2031])
% text(50,0.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(135,0.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(260,0.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% 
% ylim([-4 0.5])
% xlim([0 450])
% set(gcf,'OuterPosition',[267 121 639 734])
% 
% print('-dpng','-r150',[outdir 'new_heatflux_wind-hires.png']);
% 
% 
% 
% %%
% figure(1);
% clf
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(14,:)/10^6 ,'LineWidth',1.5,'color',gray)
% hold on;
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(15,:)/10^6 ,'LineWidth',1.5,'color',gray) 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(16,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(17,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(18,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(19,:)/10^6 ,'LineWidth',1.5,'color',gray)
% 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(20,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(21,:)/10^6 ,'LineWidth',1.5,'color',gray) 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(22,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(23,:)/10^6 ,'LineWidth',1.5,'color',gray)
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(24,:)/10^6 ,'LineWidth',1.5,'color',gray)
% 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(6,:)/10^6 ,'LineWidth',1.5,'color',gray);
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(7,:)/10^6 ,'LineWidth',1.5,'color',gray); 
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(8,:)/10^6 ,'LineWidth',1.5,'color',gray);
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(9,:)/10^6 ,'LineWidth',1.5,'color',gray);
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(10,:)/10^6 ,'LineWidth',1.5,'color',gray);
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(12,:)/10^6 ,'LineWidth',1.5,'color',gray);
% plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(13,:)/10^6 ,'LineWidth',1.5,'color',gray);
% 
% 
% l1=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(1,:)/10^6 ,'LineWidth',1.5);
% l2=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(2,:)/10^6 ,'LineWidth',1.5); 
% l3=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(3,:)/10^6 ,'LineWidth',1.5);
% l4=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(4,:)/10^6 ,'LineWidth',1.5);
% l5=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(5,:)/10^6 ,'LineWidth',1.5);
% 
% 
% plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
% line([125 125],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% line([175 175],[-4 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% hold off
% set(gca,'FontSize', fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
% title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+4);
% legend([l1,l2,l3,l4,l5],'A$_\mathrm{tide}$ = 0 m/s','A$_\mathrm{tide}$ = 0.025 m/s','A$_\mathrm{tide}$ = 0.05 m/s',...
%     'A$_\mathrm{tide}$ = 0.075 m/s','A$_\mathrm{tide}$ = 0.1 m/s',...
%     'interpreter','latex','FontSize', fontsize+1,'Position',[0.5794 0.5511 0.2461 0.1466])
% text(50,0.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(135,0.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(260,0.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% 
% ylim([-4 0.5])
% xlim([0 450])
% set(gcf,'OuterPosition',[267 121 639 734])
% 
% print('-dpng','-r150',[outdir 'new_heatflux_tides-hires.png']);
% 
% 




%%
figure(1);
clf
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(14,:)/10^6 ,'LineWidth',1.5,'color',gray)
hold on;
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(15,:)/10^6 ,'LineWidth',1.5,'color',gray) 
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(16,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(17,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(18,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(19,:)/10^6 ,'LineWidth',1.5,'color',gray)

plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(20,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(21,:)/10^6 ,'LineWidth',1.5,'color',gray) 
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(22,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(23,:)/10^6 ,'LineWidth',1.5,'color',gray)
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(24,:)/10^6 ,'LineWidth',1.5,'color',gray)

plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(6,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(7,:)/10^6 ,'LineWidth',1.5,'color',gray); 
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(8,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(9,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(10,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(12,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(13,:)/10^6 ,'LineWidth',1.5,'color',gray);

plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(1,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(2,:)/10^6 ,'LineWidth',1.5,'color',gray); 
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(3,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(4,:)/10^6 ,'LineWidth',1.5,'color',gray);
plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(5,:)/10^6 ,'LineWidth',1.5,'color',gray);

l1=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(25,:)/10^6 ,'LineWidth',4,'color',blue);
l2=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(26,:)/10^6 ,'LineWidth',1.5,'color',blue);
l3=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(27,:)/10^6 ,'LineWidth',1.5,'color',lightblue);
l4=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(28,:)/10^6 ,'LineWidth',1.5,'color',yellow);
l5=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(29,:)/10^6 ,'LineWidth',1.5,'color',orange);
l6=plot(yy/1000,cp_o*rho_o *VVELTH_zint_xavg(30,:)/10^6 ,'LineWidth',4,'color',orange);


plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)
line([125 125],[-9 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[-9 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
hold off
set(gca,'FontSize', fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional Heat Transport'},'interpreter','latex','FontSize', fontsize+5);
legend([l1 l2 l3 l4 l5 l6],...
    '\textbf{Fresh shelf}, S$_\mathrm{shelf}^\mathrm{bot}=33\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=33.59\ \mathrm{psu}$',...
    'Ref., S$_\mathrm{shelf}^\mathrm{bot}=34.17\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=34.43\ \mathrm{psu}$',...
    'S$_\mathrm{shelf}^\mathrm{bot}=34.70\ \mathrm{psu}$',...
    '\textbf{Dense shelf}, S$_\mathrm{shelf}^\mathrm{bot}=34.96\ \mathrm{psu}$',...
    'FontSize', fontsize,'interpreter','latex',...
    'Position',[0.2 0.1267 0.39 0.24]);
text(50,0.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(135,0.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,0.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');

ylim([-9 0.5])
xlim([0 450])

set(gcf,'OuterPosition',[267 121 540 734])
% set(gcf,'Position',[[267 300 534 453]])
% print('-dpng','-r150', 'heat_usscar.png');



