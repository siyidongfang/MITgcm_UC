
clear;
% close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';

%%% Set colormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

%%%%%%%%%%%%%%% Hi-res
expname =   'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;


% PSIlim2=[-1.05 1.05];
PSIlim2=[-0.8 0.8];

% PSIlim2=[-0.31 0.31];

PSIlim1 = PSIlim2;

load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
load([prodir '/' expname,'_tidalMOCz_3650days.mat']);
load([prodir '/' expname,'_tavg_10yrs.mat'],'VVEL');
vv=VVEL;
vv(vv==0)=NaN;
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

vE = squeeze(nansum(vv.*hFacS.*DZ_xyz.*DX_xyz,1));
vE(vE==0)=NaN;
psiE = zeros(Ny,Nr+1);
psiE(:,2:Nr+1) = cumsum(vE,2)/1e6; %%% Eulerian overturning
psi_standingeddy_z = psim_z-psiE;

% psi_tide_pt = psi_pt-G;
% psi_eddy_pt = G-psim_pt; 

pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
[ZZ,YY] = meshgrid(zz,yy);
[ZZF,YYF] = meshgrid(zzf,yy);


%%
figure(6);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1050 1050]);

set(gcf,'Color','w');
subplotsize = [0.41 0.26];

fontsize = 15;


%%
%%% Plot the residual overturning in y/z space

ax1 = subplot('position',[0.05+0.015 0.56+0.15 subplotsize]);
annotation('textbox',[0.015+0.015 0.55+0.4 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

YLIM = [36.6 37.5];
% YLIM = [35.9 37.4];


pcolor(yy/1000,ptlevs,psi_pt');
hold on;
% [C,h]=contour(LL/1000,DD,psi_pt,[-1:0.05:-0.05 0.05:0.05:1],'-.','EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,DD,psi_pt,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,DD,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
shading interp;caxis(PSIlim1);
ylim(YLIM)
colormap(mycolormap);
% xlabel('y (km)','FontSize',fontsize);
ylabel('\sigma_2 (kg m^{-3})','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('\psi_{isop}','FontSize',fontsize+5);
xlim([20 430]) 
axis ij
set(gca,'XTick',[0:100:400]);
% set(gca,'YTick',[36.4:0.2:37.4]);
% set(gca,'YTickLabel',{'36.4' '36.6' '36.8' '37.0' '37.2' '37.4'});
% set(gca,'YTick',[35.9:0.3:37.4]);

%%

[DD,LL] = meshgrid(ptlevs,yy);

ax2 = subplot('position',[0.53 0.56+0.15 subplotsize]);
annotation('textbox',[0.495 0.55+0.4 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
pcolor(LL/1000,-Zisop/1000,psi_pt);
shading interp;caxis(PSIlim1);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);

% [C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1:0.05:-0.05 0.05:0.05:1],'-.','EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
% handle=colorbar;
% set(handle,'FontSize',fontsize);
colormap(mycolormap);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('\psi_{isop}','FontSize',fontsize+5);
xlim([20 430]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
%%
ax3 = subplot('position',[0.05+0.015 0.06+0.32 subplotsize]);
annotation('textbox',[0.015+0.015 0.62 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

pcolor(YYF/1000,-ZZF/1000,psiE);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);

[C,h]=contour(YYF/1000,-ZZF/1000,psiE,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(YYF/1000,-ZZF/1000,psiE,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('\psi_{EM}','FontSize',fontsize+5);
xlim([20 430]) 
set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
%%
ax4 = subplot('position',[0.53 0.06+0.32 subplotsize]);
annotation('textbox',[0.495 0.62 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');


pcolor(YYF/1000,-ZZF/1000,psi_standingeddy_z);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(YYF/1000,-ZZF/1000,psi_standingeddy_z,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(YYF/1000,-ZZF/1000,psi_standingeddy_z,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('\psi_{SW}','FontSize',fontsize+5);
xlim([20 430]) 

set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);

%%
ax5 = subplot('position',[0.05+0.015 0.05 subplotsize]);
annotation('textbox',[0.015+0.015 0.295 0.05 0.05],'String','e','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

pcolor(LL/1000,-Zisop/1000,psi_tide_pt);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_tide_pt,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,-Zisop/1000,psi_tide_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('y (km)','FontSize',fontsize);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['\psi_{tide}'],'FontSize',fontsize+5);
xlim([20 430])
set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
%%
ax6 = subplot('position',[0.53 0.05 subplotsize]);
annotation('textbox',[0.495 0.295 0.05 0.05],'String','f','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');


pcolor(LL/1000,-Zisop/1000,psi_eddy_pt);
shading interp;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_eddy_pt,[-1:0.1:-0.1 0.1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,-Zisop/1000,psi_eddy_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
xlabel('y (km)','FontSize',fontsize);
ylabel('Depth  (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title(['\psi_{eddy}'],'FontSize',fontsize+5);
xlim([20 430]) 
set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
    
handle=colorbar;set(handle,'position',[0.96 0.23 0.007 0.55])
annotation('textbox',[0.952 0.77 0.05 0.05],'String','(Sv)','FontSize',fontsize+2,'LineStyle','None');


%%

print('-djpeg','-r300',[figdir 'OT_dense.jpeg']);
