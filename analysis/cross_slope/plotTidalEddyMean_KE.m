

clear;close all;
addpath ..;
addpath ../colormaps;
addpath ../jpo_analysis-hires/;
expdir = '/Users/csi/MITgcm_ASF-csi/experiments/';
prodir = '/Users/csi/MITgcm_ASF-csi/products-hires/';
% figdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_CrossShelfHeatFlux/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';

expname= 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
loadexp;

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
scrsz = get(0,'ScreenSize');
% set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 600 900]);
set(gcf,'Position',[84 54 434 651])
set(gcf,'Color','w');

%%% Plotting options
fontsize = 13;
boxcolor = [225 225 225]/255;
subplotsize = [0.88 0.27];

%%% Make the plot
clf;


%%

% %%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_KE_1825days.mat'],...
    'KE_xzavg','TKE_xzavg','EKE_xzavg','MKE_xzavg')

%%%%%%
ax1 = subplot('position',[0.1 0.38 subplotsize]);
annotation('textbox',[0.01 0.63 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

% ax1 = subplot('position',[0.1 0.7 subplotsize]);
% annotation('textbox',[0.01 0.95 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
ltot = plot(yy/1000,log10(KE_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKE_xzavg),'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,log10(MKE_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKE_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6;
ydown = -0.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-0.8,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-0.8,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-0.8,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(25,-5.5,'Ref.','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1);
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total KE','Tidal KE','Eddy KE','Mean KE',...
    'FontSize', fontsize); 
set(leg3,'position',[0.73 0.385 0.24 0.1043])
xlim([20 430])
set(gca,'XTick',[100 200 300 400])





%%

%%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_KE_540days.mat'],...
    'KE_xzavg','TKE_xzavg','EKE_xzavg','MKE_xzavg')

%%%%%%
ax2 = subplot('position',[0.1 0.7 subplotsize]);
annotation('textbox',[0.01 0.95 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,log10(KE_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKE_xzavg),'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,log10(MKE_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKE_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6;
ydown = -0.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-0.8,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-0.8,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-0.8,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =-1.076\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0]);
text(25,-5.5,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
title('Decomposition of total kinetic energy','FontSize',fontsize+2,'fontweight', 'normal');
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
set(gca,'XTick',[100 200 300 400])

xlim([20 430])



%%

%%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod_KE_1825days.mat'],...
    'KE_xzavg','TKE_xzavg','EKE_xzavg','MKE_xzavg')

%%%%%%
ax3 = subplot('position',[0.1 0.06 subplotsize]);
annotation('textbox',[0.01 0.31 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,log10(KE_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKE_xzavg),'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,log10(MKE_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKE_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6;
ydown = -0.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-0.8,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-0.8,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-0.8,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =0.409\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0]);
text(25,-5.5,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
xlim([20 430])
set(gca,'XTick',[100 200 300 400])

xlabel('y (km)', 'FontSize', fontsize+1);



%% Write to file
print('-djpeg','-r300',[figdir 'TidalEddyMean_KE.jpeg']);
% savefig([figdir 'TidalEddyMean_KE.fig'])