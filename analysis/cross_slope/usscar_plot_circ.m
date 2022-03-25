clear;close all;

%%% Plotting options
fontsize = 12;
addpath ../jpo_analysis-hires/
XLIM = [0 450];
CLIM = [-0.35 0.35];
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_usscar/'

%%% colormap
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

% GRAY = [180 180 180]/255;
GRAY = [130 130 130]/255;
boxcolor = [0.85 0.85 0.85];

expdir = '/Users/csi/MITgcm_ASF-csi/experiments/';
prodir = '/Users/csi/MITgcm_ASF-csi/products-hires/';
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';
loadexp;

%%

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL');
load([prodir '/' 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis' '_gamma_n.mat'])
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));

%%
figure(1)
clf;
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',2.5);
% [M,c] = contour(yy(1:Ny)/1000,-zz/1000,gamma(1:Ny,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
[M,c] = contour(yy(1:Ny)/1000,-zz/1000,gamma(1:Ny,:)',[27 27.5 28 28.25 28.3 28.35 28.6],'LineColor',GRAY);
clabel(M,c,'LabelSpacing',500);
hold off;
set(gca,'fontsize',fontsize);
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('$\overline{u}$ (m/s)','FontSize', fontsize+6,'interpreter','latex');
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(30,2.8,{'Dense shelf'},'FontSize', fontsize+4,'interpreter','latex','color','k')
colorbar;

set(gcf,'OuterPosition',[91 155 599 411])
print('-dpng','-r200',[outdir 'dense_shelf.png']);




%%

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL');
load([prodir '/' expname '_gamma_n.mat'])
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
%%
figure(2)
clf;
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',2.5);
[M,c] = contour(yy(1:Ny)/1000,-zz/1000,gamma(1:Ny,:)',[27 27.5 28 28.25 28.3 28.35 28.4],'LineColor',GRAY);
clabel(M,c,'LabelSpacing',500);
hold off;
set(gca,'fontsize',fontsize);
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('$\overline{u}$ (m/s)','FontSize', fontsize+6,'interpreter','latex');
title('$\overline{u}$ (m/s)','FontSize', fontsize+6,'interpreter','latex');
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(30,2.8,{'Fresh shelf'},'FontSize', fontsize+4,'interpreter','latex','color','k')
colorbar
set(gcf,'OuterPosition',[91 155 599 411])
print('-dpng','-r200',[outdir 'fresh_shelf.png']);





