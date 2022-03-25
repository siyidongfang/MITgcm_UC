
clear;
% close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;
figname = 'fig3_ver7';

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/fig3_nature/';


%%% Set colormap
ncolors =  40;
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'},ncolors);

figure(6);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 950 950]);
set(gcf,'Color','w');
% subplotsize = [0.41 0.39];
% subplotsize = [0.41 0.39];
subplotsize = [0.41 0.26];
fontsize = 15;

%%

expname =  'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
% PSIlim2=[-1.05 1.05];
% PSIlim2=[-0.31 0.31];
PSIlim2=[-0.6 0.6];
PSIlim1 = PSIlim2;
load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
load([prodir '/' expname '_tavg_10yrs.mat'],'VVELTH','ADVy_TH');

[ZZ,YY] = meshgrid(zz,yy);

%% Heat flux
ax1 = subplot('position',[0.05 0.56+0.15 subplotsize]);
annotation('textbox',[0.015 0.55+0.4 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
vtheta_xavg = squeeze(nanmean(VVELTH,1));
vtheta_xavg(vtheta_xavg==0)=NaN;
pcolor(yy/1000,-zz/1000,1000*vtheta_xavg');shading interp
colormap(mycolormap);
caxis([-0.01 0.01]*1000);
hold on;
% [C,h]=contour(YY/1000,-ZZ/1000,vtheta_xavg,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
set(gca,'FontSize',fontsize)
% title('Advective heat flux $\langle\overline{v\theta}\rangle\ (^\circ \mathrm{C\ m/s})$','FontSize', fontsize+5,'interpreter','latex');
title('Advective heat flux {\it F}_{total}','FontSize', fontsize+2,'FontWeight','normal');
ylabel('Depth (km)','FontSize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YDir','reverse');
set(gca,'XTick',[0:100:400]);
set(gca,'YTick',[0:1:4]);
text(25,3.7,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);

%%
% Heat function
ax3 = subplot('position',[0.05 0.06+0.32 subplotsize]);
annotation('textbox',[0.015 0.62 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
cmax = 4;
cmin = -4;
rho_o = 999.8;
cp_o = 3994; % Unit: J/kg/degC
Tref = 0;
phi_new = rho_o*cp_o*squeeze(sum(cumsum(ADVy_TH,3,'reverse'),1))/1e12; % Heat function fie, on v-grid
phi_new(phi_new==0)=NaN;
pcolor(yy/1000,-zz/1000,phi_new');shading interp;
colormap(mycolormap);
% colorbar;
caxis([cmin cmax]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
set(gca,'FontSize',fontsize)
ylabel('Depth (km)','FontSize',fontsize);
% title('Heat function \phi, \theta_\mathrm{ref}= 0\ ^\circ C','FontSize', fontsize+5);
title('Heat function \phi','FontSize', fontsize+2,'FontWeight','normal');
[C,h]=contour(YY/1000,-ZZ/1000,phi_new,[-8:0.5:8],'EdgeColor','w');
% [C,h]=contour(YY/1000,-ZZ/1000,phi_new,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
% annotation('textbox',[0.81 0.95 0.15 0.05],'String','($10^{12}$ W)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YDir','reverse');
set(gca,'XTick',[0:100:400]);
set(gca,'YTick',[0:1:4]);
text(25,3.7,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);


%%

% Overturning streamfunction
ax5 = subplot('position',[0.05 0.05 subplotsize]);
annotation('textbox',[0.015 0.295 0.05 0.05],'String','e','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

pcolor(LL/1000,-Zisop/1000,psi_pt);
shading interp;caxis(PSIlim1);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);

[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1:0.05:1],'-.','EdgeColor','w','LineWidth',0.7);
[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1:0.1:1],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('Overturning streamfunction \psi_{isop}','FontSize',fontsize+2,'FontWeight','normal');
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
text(25,3.7,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
xlabel('y (km)','FontSize',fontsize);




%%
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';

expname =  'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;
% PSIlim2=[-1.05 1.05];
% PSIlim2=[-0.31 0.31];
% PSIlim1 = PSIlim2;
load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
load([prodir '/' expname '_tavg_10yrs.mat'],'VVELTH','ADVy_TH');
[ZZ,YY] = meshgrid(zz,yy);


% Heat flux
ax2 = subplot('position',[0.52 0.56+0.15 subplotsize]);
annotation('textbox',[0.485 0.55+0.4 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
vtheta_xavg = squeeze(nanmean(VVELTH,1));
vtheta_xavg(vtheta_xavg==0)=NaN;
pcolor(yy/1000,-zz/1000,1000*vtheta_xavg');shading interp
colormap(mycolormap);
caxis([-0.01 0.01]*1000);
hold on;
% [C,h]=contour(YY/1000,-ZZ/1000,vtheta_xavg,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
set(gca,'FontSize',fontsize)
% title('Advective heat flux $\langle\overline{v\theta}\rangle\ (^\circ \mathrm{C\ m/s})$','FontSize', fontsize+5,'interpreter','latex');
title('Advective heat flux {\it F}_{total}','FontSize', fontsize+2,'FontWeight','normal');
ylabel('Depth (km)','FontSize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YDir','reverse');
set(gca,'XTick',[0:100:400]);
set(gca,'YTick',[0:1:4]);
text(25,3.7,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);

handle=colorbar;
set(handle,'position',[0.95 0.71 0.007 0.26])
annotation('textbox',[0.89 0.955 0.15 0.05],'String',['(10^{-3} ' char(176) 'C m/s)'],'FontSize',fontsize,'LineStyle','None');


%% Heat function
ax4 = subplot('position',[0.52 0.06+0.32 subplotsize]);
annotation('textbox',[0.485 0.62 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
phi_new = rho_o*cp_o*squeeze(sum(cumsum(ADVy_TH,3,'reverse'),1))/1e12; % Heat function fie, on v-grid
phi_new(phi_new==0)=NaN;
pcolor(yy/1000,-zz/1000,phi_new');shading interp;
colormap(mycolormap);
% colorbar;
caxis([cmin cmax]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
set(gca,'FontSize',fontsize)
ylabel('Depth (km)','FontSize',fontsize);
% title('Heat function \phi, \theta_\mathrm{ref}= 0\ ^\circ C','FontSize', fontsize+5);
title('Heat function \phi','FontSize', fontsize+2,'FontWeight','normal');
[C,h]=contour(YY/1000,-ZZ/1000,phi_new,[-8:0.5:8],'EdgeColor','w');
% [C,h]=contour(YY/1000,-ZZ/1000,phi_new,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);

hold off;
% annotation('textbox',[0.81 0.95 0.15 0.05],'String','($10^{12}$ W)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YDir','reverse');
set(gca,'XTick',[0:100:400]);
set(gca,'YTick',[0:1:4]);
text(25,3.7,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);

handle=colorbar;
set(handle,'position',[0.95 0.38 0.007 0.26])
annotation('textbox',[0.935 0.623 0.05 0.05],'String','(TW)','FontSize',fontsize,'LineStyle','None');


%% Overturning streamfunction
ax6 = subplot('position',[0.52 0.05 subplotsize]);
annotation('textbox',[0.485 0.295 0.05 0.05],'String','f','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

pcolor(LL/1000,-Zisop/1000,psi_pt);
shading interp;caxis(PSIlim1);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[-1.5:0.1:1.5],'EdgeColor','w','LineWidth',0.7);
% [C,h]=contour(LL/1000,-Zisop/1000,psi_pt,[0 0],'EdgeColor',[200 200 200]/255,'LineWidth',1.5);
hold off;
colormap(mycolormap);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title('Overturning streamfunction \psi_{isop}','FontSize',fontsize+2,'FontWeight','normal');
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
text(25,3.7,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);
xlabel('y (km)','FontSize',fontsize);

handle=colorbar('XTickLabel',{'-0.6','-0.4','-0.2','0','0.2','0.4','0.6'}, ...
               'XTick', -0.6:0.2:0.6);
set(handle,'position',[0.95 0.05 0.007 0.26])
annotation('textbox',[0.938 0.29 0.05 0.05],'String','(Sv)','FontSize',fontsize,'LineStyle','None');
colormap(cmocean('balance',101));

%%

 print('-djpeg','-r300',[figdir figname '.jpeg']);