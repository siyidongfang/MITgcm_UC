clear;

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/newexp/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng';
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_heat-function/'

rho_o = 999.8;
cp_o = 3994; % Unit: J/kg/degC

% expname = 'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf34.12_0dS'
expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'

loadexp;

fname = {'Fresh shelf'}

load([prodir '/' expname '_tavg_10yrs.mat'],'VVEL','THETA','VVELTH','ADVy_TH');
VVELTH(VVELTH==0)=NaN; % on v-grid
THETA(THETA==0)=NaN;   % on mass-grid
VVEL(VVEL==0)=NaN;

dy = delY(1); % Uniform horizontal grid spacing
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
[ZZ,YY] = meshgrid(zz,yy);


%%
cmax = 4;
cmin = -4;
fontsize = 14;



figure(3)
clf;
Tref = 0;
phi_new = rho_o*cp_o*squeeze(sum(cumsum(ADVy_TH,3,'reverse'),1))/1e12; % Heat function fie, on v-grid
phi_new(phi_new==0)=NaN;
pcolor(yy/1000,-zz/1000,phi_new');shading interp;axis ij;
% colormap(redblue);
colormap(cmocean('balance',100));
colorbar;
caxis([cmin cmax]);
xlim([0 450])
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
set(gca,'FontSize',fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('Heat function $\phi$ ($^\circ \mathrm{C\ m^3/s}$), $$\theta_\mathrm{ref}= 0\ ^\circ$C','FontSize', fontsize+5,'interpreter','latex');
title('Heat function $\phi$, $$\theta_\mathrm{ref}= 0\ ^\circ$C','FontSize', fontsize+5,'interpreter','latex');
[C,h]=contour(YY/1000,-ZZ/1000,phi_new,[-8:0.5:8],'EdgeColor','w');
hold off;
annotation('textbox',[0.81 0.95 0.15 0.05],'String','($10^{12}$ W)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
text(10,3.5,fname,'FontSize', fontsize+10,'interpreter','latex')
set(gcf,'OuterPosition',[91 155 575 418])
set(gca,'XTick',[0:100:450]);
set(gca,'YTick',[0:1:4]);

% print('-dpng','-r150',[outdir expname '_phi_ADVyTH.png']);




%%




% 
% figure(1)
% clf;
% Tref = 0;
% Heatflux_xyz = VVELTH - Tref*VVEL;
% phi = rho_o*cp_o*squeeze(nansum(cumsum(Heatflux_xyz.*hFacS.*DZ_xyz*delX(1),3,'reverse','omitnan'),1))/1e6/Lx; % Heat function fie, on v-grid
% phi(phi==0)=NaN;
% pcolor(yy/1000,-zz/1000,phi');shading interp;axis ij;
% % colormap(redblue);
% colormap(cmocean('balance',100));
% colorbar;
% caxis([cmin cmax]);
% xlim([0 450])
% hold on;
% plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
% plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
% set(gca,'FontSize',fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% % title('Heat function $\phi$ ($^\circ \mathrm{C\ m^3/s}$), $$\theta_\mathrm{ref}= 0\ ^\circ$C','FontSize', fontsize+5,'interpreter','latex');
% title('Heat function $\phi$ (use VVELTH), $$\theta_\mathrm{ref}= 0\ ^\circ$C','FontSize', fontsize+5,'interpreter','latex');
% annotation('textbox',[0.81 0.95 0.15 0.05],'String','($10^6$ W/m)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% 
% [C,h]=contour(YY/1000,-ZZ/1000,phi,[cmin:1.5:cmax],'EdgeColor','w');
% hold off;
% text(30,2.8,fname,'FontSize', fontsize+4,'interpreter','latex')
% set(gcf,'OuterPosition',[91 155 599 411])
% % print('-dpng','-r150',[outdir expname '_phi_vvelth.png']);
% 
% 
% 
% figure(2)
% clf;
% vtheta_xavg = squeeze(nanmean(VVELTH,1));
% pcolor(yy/1000,-zz/1000,vtheta_xavg');shading interp;axis ij;
% colormap(cmocean('balance',100));
% colorbar;
% caxis([-0.01 0.01]);
% xlim([0 450])
% hold on;
% plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
% plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
% set(gca,'FontSize',fontsize)
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('Advective heat flux $\langle\overline{v\theta}\rangle\ (^\circ \mathrm{C\ m/s})$','FontSize', fontsize+5,'interpreter','latex');
% hold off;
% text(30,2.8,fname,'FontSize', fontsize+4,'interpreter','latex')
% set(gcf,'OuterPosition',[91 155 599 411])
% % print('-dpng','-r150',[outdir 'heatflux_' fname '.png']);
% 
% 
% 
% 
% 
% 
% 
% 
