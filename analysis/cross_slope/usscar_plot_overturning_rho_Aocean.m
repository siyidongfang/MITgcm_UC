%%%
%%% Plots the overturning circulation in potential density space, for
%%% US-SCAR meeting
%%%
clear;close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/OT_hires/';

%%% Set colormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});


%%%%%%%%%%%%%%% Hi-res
% expname =   'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_daily_calgfd'
loadexp;

% exppath = fullfile(expdir,expname);
% inputpath = fullfile(exppath,'input');
% run(fullfile(inputpath,'params.m'));

%%% Grid dimensions (not specified explicitly in params.m)
% Nx = length(delX);
% Ny = length(delY);
% Nr = length(delR);

%%% Domain dimensions
% Lx = sum(delX);
% Ly = sum(delY);
% H = sum(delR);

%%% Gridpoint locations are at the centre of each grid cell
% xx = cumsum((delX + [0 delX(1:Nx-1)])/2)-Lx/2;
% yy = cumsum((delY + [0 delY(1:Ny-1)])/2);
% zz = -cumsum((delR + [0 delR(1:Nr-1)])/2);

% fid = fopen(fullfile(inputpath,bathyFile),'r','b');
% bathy = fread(fid,[Nx Ny],'real*8');
% fclose(fid);

PSIlim2=[-0.3 0.3];
% PSIlim2=[-1.05 1.05];
PSIlim1 = PSIlim2;

load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
% pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
[ZZ,YY] = meshgrid(zz,yy);


%%
figure(6);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1200 700]);
set(gcf,'Color','w');
subplotsize = [0.41 0.39];

fontsize = 15;


%%
%%% Plot the residual overturning in y/z space

ax1 = subplot('position',[0.05 0.56 subplotsize]);
annotation('textbox',[0.05 0.55 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

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

ax2 = subplot('position',[0.52 0.56 subplotsize]);
annotation('textbox',[0.52 0.55 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
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
ax3 = subplot('position',[0.05 0.06 subplotsize]);
annotation('textbox',[0.05 0.05 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

pcolor(LL/1000,-Zisop/1000,psim_pt);
shading interp;;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psim_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psim_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{mean}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

%%
ax4 = subplot('position',[0.52 0.06 subplotsize]);
annotation('textbox',[0.52 0.05 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


pcolor(LL/1000,-Zisop/1000,psie_pt);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psie_pt,[-1:0.2:1],'EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psie_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['$\psi_{\mathrm{eddy}}$ + $\psi_{\mathrm{tide}}$'],'FontSize',fontsize+10,'interpreter','latex');
xlim([20 430])

% ax5 = subplot('position',[0.9 0.05 0.08 0.9]);
handle=colorbar;set(handle,'position',[0.95 0.06 0.01 0.89])
annotation('textbox',[0.938 0.93 0.05 0.05],'String','(Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


%%

% print('-dpng','-r200',[outdir 'OT_hires_sdiff3_prod_rho_Aocean.png']);
