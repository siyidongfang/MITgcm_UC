
clear;close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/OT_hires/';

%%% Set colormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

%%%%%%%%%%%%%%% Hi-res
% expname =   'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
expname =   'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_60s'
loadexp;


PSIlim2=[-1.05 1.05];
% PSIlim2=[-0.3 0.3];

PSIlim1 = PSIlim2;

load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
load([prodir '/' expname,'_tidalMOC_1825days.mat']);

psi_tide_pt = psi_pt-G;
psi_eddy_pt = G-psim_pt; 

pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
[ZZ,YY] = meshgrid(zz,yy);


%%
figure(6);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1200 1050]);
set(gcf,'Color','w');
% subplotsize = [0.41 0.39];
% subplotsize = [0.41 0.39];
subplotsize = [0.41 0.26];

fontsize = 15;


%%
%%% Plot the residual overturning in y/z space

ax1 = subplot('position',[0.05 0.56+0.15 subplotsize]);
annotation('textbox',[0.05 0.55+0.15 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

YLIM = [36.4 37.5];

pcolor(yy/1000,ptlevs,psi_pt');
hold on;
[C,h]=contour(LL/1000,DD,psi_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,DD,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
shading interp;caxis(PSIlim1);ylim(YLIM)
colormap(mycolormap);
% xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('$\sigma_2\ (kg\ m^{-3})$','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{res}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])
axis ij

%%

[DD,LL] = meshgrid(ptlevs,yy);

ax2 = subplot('position',[0.52 0.56+0.15 subplotsize]);
annotation('textbox',[0.52 0.55+0.15 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
pcolor(LL/1000,-Zisop/1000,psi_pt);
shading interp;caxis(PSIlim1);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
% handle=colorbar;
% set(handle,'FontSize',fontsize);
colormap(mycolormap);
% xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{res}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

%%
ax3 = subplot('position',[0.05 0.06+0.32 subplotsize]);
annotation('textbox',[0.05 0.05+0.32 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

pcolor(LL/1000,-Zisop/1000,psim_pt);
shading interp;;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psim_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psim_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
% xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{mean}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

%%
ax4 = subplot('position',[0.52 0.06+0.32 subplotsize]);
annotation('textbox',[0.52 0.05+0.32 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


pcolor(LL/1000,-Zisop/1000,psie_pt);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psie_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psie_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
% xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{eddy}}$ + $\psi_{\mathrm{tide}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

handle=colorbar;set(handle,'position',[0.95 0.06 0.01 0.89])
annotation('textbox',[0.938 0.93 0.05 0.05],'String','(Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');




%%
ax5 = subplot('position',[0.05 0.05 subplotsize]);
annotation('textbox',[0.05 0.04 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

pcolor(LL/1000,-Zisop/1000,psi_tide_pt);
shading interp;;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_tide_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psi_tide_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{tide}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

%%
ax6 = subplot('position',[0.52 0.05 subplotsize]);
annotation('textbox',[0.52 0.04 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


pcolor(LL/1000,-Zisop/1000,psi_eddy_pt);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_eddy_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psi_eddy_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{eddy}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

handle=colorbar;set(handle,'position',[0.95 0.06 0.01 0.89])
annotation('textbox',[0.938 0.93 0.05 0.05],'String','(Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


%%

% print('-dpng','-r200',[outdir 'TidalEddyMean_OT_hires_ssurf33_prod_rho_Aocean_caxis.png']);
