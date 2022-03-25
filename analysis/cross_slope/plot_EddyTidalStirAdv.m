
clear;

addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';


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
lightred = [249 140 60]/255;
seagreen = [46 139 87]/255;


rho_o = 1037;
cp_o = 3850;
Lx = 400000;

%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
% set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 600 600]);
set(gcf,'Position',[84 54 434 460]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 13;
boxcolor = [225 225 225]/255;
subplotsize = [0.88 0.4];

%%% Make the plot
clf;

rho_o = 1037;
cp_o = 3850;



%%

expname ='ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;
load([prodir expname,'_Feddy_adv_stir.mat']);
ax1 = subplot('position',[0.1 0.58 subplotsize]);
annotation('textbox',[0.01 0.96 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
ltot = plot(yy/1000,cp_o*rho_o*Ftide_adv/1e12,'--','Color',blue,'LineWidth',1.5);
hold on
plot(yy/1000,cp_o*rho_o*Ftide_stir/1e12,':','Color',lightblue,'LineWidth',2);
plot(yy/1000,cp_o*rho_o*Feddy_adv/1e12,'--','Color',orange,'LineWidth',1.5);
plot(yy/1000,cp_o*rho_o*Feddy_stir/1e12,':','Color',lightred,'LineWidth',2);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6;
ydown =6;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,0.7,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,0.7,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,0.7,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(25,-3.5,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('TW', 'FontSize', fontsize);
xlim([20 430])
set(gca,'YTick',[-4 -3 -2 -1 0 1 2])
set(gca,'XTick',[100 200 300 400])

leg3 = legend(...
    'Tidal advection','Tidal stirring','Eddy advection','Eddy stirring',...
    'FontSize', fontsize); 
set(leg3,'position',[0.6267    0.6021    0.33    0.1467])

%%
expname= 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
load([prodir expname,'_Feddy_adv_stir.mat']);

ax2 = subplot('position',[0.1 0.09 subplotsize]);
annotation('textbox',[0.01 0.47 0.05 0.05],'String','e','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,cp_o*rho_o*Ftide_adv/1e12,'--','Color',blue,'LineWidth',1.5);
hold on
plot(yy/1000,cp_o*rho_o*Ftide_stir/1e12,':','Color',lightblue,'LineWidth',2);
plot(yy/1000,cp_o*rho_o*Feddy_adv/1e12,'--','Color',orange,'LineWidth',1.5);
plot(yy/1000,cp_o*rho_o*Feddy_stir/1e12,':','Color',lightred,'LineWidth',2);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -4;
ydown = 1.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,0.7,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,0.7,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,0.7,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(25,-3.5,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('TW', 'FontSize', fontsize);
xlim([20 430])
set(gca,'YTick',[-4 -3 -2 -1 0 1 2])
set(gca,'XTick',[100 200 300 400])
xlabel('y (km)', 'FontSize', fontsize+1);


print('-djpeg','-r300',[figdir 'TidalEddyMean_heat_stir_adv.jpeg']);
