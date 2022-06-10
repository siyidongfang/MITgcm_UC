

clear;close all;

addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;

expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/';
% prodir = '/Volumes/si/MITgcm_UC/products_uc/';
figdir = '/Users/csi/MITgcm_UC/analysis_uc/figures/';

ncolor=80;
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'},ncolor);
GREY = [180 180 180]/255;


%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 525 1050]);
% set(gcf,'Position',[84 54 434 651])
set(gcf,'Color','w');

%%% Plotting options
fontsize = 15;
boxcolor = [225 225 225]/255;
subplotsize = [0.8 0.27];

%%% Make the plot
clf;


%%
CLIM=[-0.4 0.4];


ax4 = subplot('position',[0.065 0.7 subplotsize]);
annotation('textbox',[0 0.95 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

expname= 'res2km_Ua-2Va2_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_stampede2'
loadexp;
% % load([prodir expname '_tavg_5yrs.mat'],'UVEL')
% % UVEL(UVEL==0) = NaN;
% % aaa1=squeeze(nanmean(UVEL,1));
aaaa1 = rdmds([exppath,'/results/UVEL'],1326280);
aaaa1(aaaa1==0)=NaN;
aaa1 = squeeze(nanmean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1');
shading interp;axis ij;
colormap(mycolormap);
caxis(CLIM);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% % load([prodir expname '_gamma_n.mat'])
% % gamma_n(gamma_n==0) = NaN;
% % gamma = squeeze(nanmean(gamma_n,1));
% % [M,c] = contour(yy/1000,-zz/1000,gamma',[27 27.5 28 28.25 28.3 28.35 28.6],'LineColor',GREY,'LineWidth',1);
% % % clabel(M,c,'LabelSpacing',300);
% % clabel(M,c,'manual');

ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
title('Zonal velocity','FontSize',fontsize+4,'fontweight', 'normal');
text(25,3.5,{'With sea ice,', 'no winds, no tides'},'FontSize',fontsize+1,'Color',[0 0 0]);






ax5 = subplot('position',[0.065 0.38 subplotsize]);
annotation('textbox',[0 0.63 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
expname= 'ssurf33_0dS_lores_Ua-2Va2_Atide0_Hi1Ai1_Ws25_prod';
loadexp;
load([prodir expname '_tavg_5yrs.mat'],'UVEL')
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
pcolor(yy/1000,-zz/1000,aaa1');
shading interp;axis ij;
colormap(mycolormap);
caxis(CLIM);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
load([prodir expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy/1000,-zz/1000,gamma',[27 27.5 28 28.25 28.3 28.35 28.6],'LineColor',GREY,'LineWidth',1);
% clabel(M,c,'LabelSpacing',300);
clabel(M,c,'manual');

ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
text(25,3.5,{'With sea ice,', 'weak winds, no tides'},'FontSize',fontsize+1,'Color',[0 0 0]);





%%
ax6 = subplot('position',[0.065 0.06 subplotsize]);
annotation('textbox',[0 0.31 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
expname= 'ssurf33_0dS_lores_Ua0Va0_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
load([prodir expname '_tavg_5yrs.mat'],'UVEL')
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
pcolor(yy/1000,-zz/1000,aaa1');
shading interp;axis ij;
colormap(mycolormap);
caxis(CLIM);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
load([prodir expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy/1000,-zz/1000,gamma',[27 27.5 28 28.25 28.3 28.35 28.6],'LineColor',GREY,'LineWidth',1);
% clabel(M,c,'LabelSpacing',300);
clabel(M,c,'manual');

ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
text(25,3.5,{'With sea ice,', 'no winds, with tides'},'FontSize',fontsize+1,'Color',[0 0 0]);

xlabel('y (km)', 'FontSize', fontsize+1);

handle=colorbar;set(handle,'position',[0.91 0.23 0.015 0.5])
annotation('textbox',[0.88 0.72 0.05 0.05],'String','(m/s)','FontSize',fontsize+2,'LineStyle','None');



%% Write to file
% print('-djpeg','-r300',[figdir 'zonal_circulation_with_ice.jpeg']);
