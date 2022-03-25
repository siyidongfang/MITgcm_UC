

clear;close all;
addpath ..;
addpath ../colormaps;
addpath ../jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';



blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;

%%% Initialize figure
figure(2);
clf;
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 600 900]);
set(gcf,'Position',[84 54 434 651]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 13;
boxcolor = [225 225 225]/255;
subplotsize = [0.88 0.27];

%%% Make the plot
clf;

rho_o = 1037;
cp_o = 3850;
Lx = 400000;

% load ([prodir expname,'_Feddy_adv_stir.mat'])

%%
expname= 'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;
% %%%%%%
load([prodir expname '_heat_3650days.mat'],...
    'Fmean_xzint','Feddy_xzint','Ftide_xzint')
Ftotal = Fmean_xzint+Feddy_xzint+Ftide_xzint;

%%%%%%
ax2 = subplot('position',[0.1 0.38 subplotsize]);
annotation('textbox',[0.01 0.63 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');


ltot = plot(yy/1000,cp_o*rho_o*Ftotal/1e12,'Color',green,'LineWidth',2);
hold on
leddy = plot(yy/1000,cp_o*rho_o*Feddy_xzint/1e12,'-.','Color',orange,'LineWidth',1.5);
lmean = plot(yy/1000,cp_o*rho_o*Fmean_xzint/1e12,'-.','Color',yellow,'LineWidth',1.5);
ltidal = plot(yy/1000,cp_o*rho_o*Ftide_xzint/1e12,'-.','Color',blue,'LineWidth',1.5);
% leddystir = plot(yy/1000,cp_o*rho_o*Feddy_stir/1e12,':','Color',pink,'LineWidth',2);
% leddyadv = plot(yy/1000,cp_o*rho_o*Feddy_adv/1e12,'--','Color',pink,'LineWidth',2);

plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);

yup = -4;
ydown = 4;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,3.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,3.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,3.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(25,-3.4,'Reference','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('TW', 'FontSize', fontsize);
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1,'interpreter','latex');
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total meridional heat transport','Tidal component','Eddy component','Mean component',...
    'FontSize', fontsize); 
set(leg3,'position',[0.46 0.3855 0.5109 0.1043])
% set(leg3,'position',[0.4102 0.3548 0.5691 0.1300])

xlim([20 430])
set(gca,'XTick',[100 200 300 400])






%%
expname= 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;

%%%%%%
load([prodir expname '_heat_3650days.mat'],...
    'Fmean_xzint','Feddy_xzint','Ftide_xzint')
Ftotal = Fmean_xzint+Feddy_xzint+Ftide_xzint;

%%%%%%
ax1 = subplot('position',[0.1 0.7 subplotsize]);
annotation('textbox',[0.01 0.95 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
ltot = plot(yy/1000,cp_o*rho_o*Ftotal/1e12,'Color',green,'LineWidth',2);
hold on
leddy = plot(yy/1000,cp_o*rho_o*Feddy_xzint/1e12,'-.','Color',orange,'LineWidth',1.5);
lmean = plot(yy/1000,cp_o*rho_o*Fmean_xzint/1e12,'-.','Color',yellow,'LineWidth',1.5);
ltidal = plot(yy/1000,cp_o*rho_o*Ftide_xzint/1e12,'-.','Color',blue,'LineWidth',1.5);
% leddystir = plot(yy/1000,cp_o*rho_o*Feddy_stir/1e12,':','Color',pink,'LineWidth',2);
% leddyadv = plot(yy/1000,cp_o*rho_o*Feddy_adv/1e12,'--','Color',pink,'LineWidth',2);

plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);

yup = -4;
ydown = 4;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,3.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,3.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,3.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =-1.076\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
text(25,-3.4,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
% text(25,-3.4,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0],'fontweight', 'normal');

set(gca,'XTick',[100 200 300 400])
hold off;
set(gca,'fontsize',fontsize);
ylabel('TW', 'FontSize', fontsize);

xlim([20 430])

title('Decomposition of total meridional heat transport','FontSize',fontsize+2,'fontweight', 'normal');





%%
expname= 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;

%%%%%%
load([prodir expname '_heat_3650days.mat'],...
    'Fmean_xzint','Feddy_xzint','Ftide_xzint')
Ftotal = Fmean_xzint+Feddy_xzint+Ftide_xzint;

% load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod_Feddy_adv_stir.mat'])


%%%%%%
ax3 = subplot('position',[0.1 0.06 subplotsize]);
annotation('textbox',[0.01 0.31 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,cp_o*rho_o*Ftotal/1e12,'Color',green,'LineWidth',2);
hold on
leddy = plot(yy/1000,cp_o*rho_o*Feddy_xzint/1e12,'-.','Color',orange,'LineWidth',1.5);
lmean = plot(yy/1000,cp_o*rho_o*Fmean_xzint/1e12,'-.','Color',yellow,'LineWidth',1.5);
ltidal = plot(yy/1000,cp_o*rho_o*Ftide_xzint/1e12,'-.','Color',blue,'LineWidth',1.5);
% leddystir = plot(yy/1000,cp_o*rho_o*Feddy_stir/1e12,':','Color',pink,'LineWidth',2);
% leddyadv = plot(yy/1000,cp_o*rho_o*Feddy_adv/1e12,'--','Color',pink,'LineWidth',2);

plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);

yup = -4;
ydown = 4;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,3.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,3.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,3.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =0.409\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
text(25,-3.4,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);

% text(25,-3.4,'Dense shelf','FontSize',fontsize+4,'Color',[0 0 0],'fontweight', 'normal');


hold off;
set(gca,'fontsize',fontsize);
ylabel('TW', 'FontSize', fontsize);
xlim([20 430])
xlabel('y (km)', 'FontSize', fontsize+1);
set(gca,'XTick',[100 200 300 400])




% set(gcf,'InnerPosition',[84 54 434 651])

%% Write to file
print('-djpeg','-r300',[figdir 'TidalEddyMean_heat.jpeg']);
% savefig([figdir 'TidalEddyMean_heat.fig'])