clear all;close all;

%%% Plotting options
fontsize = 12;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 450]);
set(gcf,'Color','w');
legpos = [0.4 0.01 0.2 0.03];

%%% colormap
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
grey2 = [249 249 249]/255;
GRAY = [180 180 180]/255;

boxcolor = [0.85 0.85 0.85];

% %%% Load reference experiment
% expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
expdir = '/home/csi/MITgcm_ASF-experiments';
outdir = '/data/MITgcm_ASF-csi/experiments/products/';
% loadexp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SCHEMATIC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

EXPNAME = {...
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...   
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  };
% subplot('position',[0.02 0.48 0.9 0.4]);
% image( imread('u_strength.png') );
% box off;
% axis off;
ne = 1
expname = EXPNAME{ne};
loadexp;

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);



%%



XLIM = [90 210];
CLIM = [-0.5 0.5];

lineYLIM = [-0.37 0];

panelsize = [0.1 0.11 0.48];
panelsize_lines = [0.7 0.11 0.22];

annposition = [0.535 0.05 0.05];
annposition_lines = [0.875 0.05 0.05];

colorbarposition = [0.95 0.1 0.01 0.48];

ax1 = subplot('position',[0.05 panelsize]);
annotation('textbox',[0.045 annposition],'String','(h)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
title('u (m/s)','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax1,95,3.4,{'$A_{\mathrm{tide}}= 0.05$\ \ m/s','$H_{\mathrm{i0}}= 1$ m','$U_{\mathrm{a0}}= -6$ m/s'},'FontSize', fontsize-2,'interpreter','latex')
text(ax1,95,2.8,{'\textbf{Ref.}'},'FontSize', fontsize,'interpreter','latex','color',orange)

%%
ax11 = subplot('position',[0.05 panelsize_lines]);
annotation('textbox',[0.045 annposition_lines],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
% title('$u_i$, $u^s_o$ (m/s)', 'FontSize', fontsize+2,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
% ylabel('(m/s)', 'FontSize', fontsize-2,'interpreter','latex');
xlim(XLIM);
ylim(lineYLIM);
set(gca,'TickLength',[0.02 0.035])

%%

ne = 2
expname = EXPNAME{ne};
ax2 = subplot('position',[0.18 panelsize]);
annotation('textbox',[0.175 annposition],'String','(i)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap([boxcolor;mycolormap]);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax2,100,3.5,{'$A_{\mathrm{tide}}$','$= 0$ m/s'},'FontSize', fontsize,'interpreter','latex')

%%
ax21 = subplot('position',[0.18 panelsize_lines]);
annotation('textbox',[0.175 annposition_lines],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])


ne = 3
expname = EXPNAME{ne};
ax3 = subplot('position',[0.31 panelsize]);
annotation('textbox',[0.305 annposition],'String','(j)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax3,100,3.5,{'$A_{\mathrm{tide}}$','$= 0.1$ m/s'},'FontSize', fontsize,'interpreter','latex')
%%

ax31 = subplot('position',[0.31 panelsize_lines]);
annotation('textbox',[0.305 annposition_lines],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])



ne = 4
expname = EXPNAME{ne};
ax4 = subplot('position',[0.44 panelsize]);
annotation('textbox',[0.435 annposition],'String','(k)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax4,100,3.5,{'$H_{\mathrm{i0}}$','$= 0.6$ m'},'FontSize', fontsize,'interpreter','latex')

%%
ax41 = subplot('position',[0.44 panelsize_lines]);
annotation('textbox',[0.435 annposition_lines],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])


ne = 5
expname = EXPNAME{ne};
ax5 = subplot('position',[0.57 panelsize]);
annotation('textbox',[0.565 annposition],'String','(l)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax5,100,3.5,{'$H_{\mathrm{i0}}$','$= 0.2$ m'},'FontSize', fontsize,'interpreter','latex')

%%
ax51 = subplot('position',[0.57 panelsize_lines]);
annotation('textbox',[0.565 annposition_lines],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])




ne = 6
expname = EXPNAME{ne};
ax6 = subplot('position',[0.70 panelsize]);
annotation('textbox',[0.695 annposition],'String','(m)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax6,100,3.5,{'$U_{\mathrm{a0}}$','$= -4$ m/s'},'FontSize', fontsize,'interpreter','latex')

%%
ax61 = subplot('position',[0.70 panelsize_lines]);
annotation('textbox',[0.695 annposition_lines],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])




ne = 7
expname = EXPNAME{ne};
ax7 = subplot('position',[0.83 panelsize]);
annotation('textbox',[0.825 annposition],'String','(n)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',150,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])

%%% Add colorbar
handle = colorbar;
set(handle,'Position',colorbarposition);
text(ax7,100,3.5,{'$U_{\mathrm{a0}}$','$= -8$ m/s'},'FontSize', fontsize,'interpreter','latex')
%%

ax71 = subplot('position',[0.83 panelsize_lines]);
annotation('textbox',[0.825 annposition_lines],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])


leg3 = legend('$u^s_o$','$u_i$ (m/s)','FontSize', fontsize+2,'interpreter','latex','orientation','horizontal');
legend boxoff; set(leg3,'position',[0.1 0.93 0.05 0.05])
    
print('-dpng','-r150','jpo_circ_strength.png');


%%


EXPNAME = {...
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',... 
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
  };

XLIM = [90 290];
CLIM = [-0.5 0.5];


figure(2);
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 450]);
set(gcf,'Color','w');
clf;

%%

lineYLIM = [-0.37 0];

panelsize = [0.1 0.13 0.48];
panelsize_lines = [0.7 0.13 0.22];

annposition = [0.535 0.05 0.05];
annposition_lines = [0.875 0.05 0.05];

colorbarposition = [0.945 0.1 0.01 0.48];


ne = 1
expname = EXPNAME{ne};
ax1 = subplot('position',[0.05 panelsize]);
annotation('textbox',[0.045 annposition],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',64,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
title('u (m/s)','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax1,90,3.5,{'$\mathrm{\Delta S}=$','$-1.17$ psu'},'FontSize', fontsize-1,'interpreter','latex')


ax11 = subplot('position',[0.05 panelsize_lines]);
annotation('textbox',[0.045 annposition_lines],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
% title('$u_i$, $u^s_o$ (m/s)', 'FontSize', fontsize+2,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
% ylabel('(m/s)', 'FontSize', fontsize-2,'interpreter','latex');
xlim(XLIM);
ylim(lineYLIM);
set(gca,'TickLength',[0.02 0.035])

%%
ne = 2
expname = EXPNAME{ne};
ax2 = subplot('position',[0.2 panelsize]);
annotation('textbox',[0.195 annposition],'String','(h)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',65,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax2,90,3.5,{'$\mathrm{\Delta S}=$','$-0.58$ psu'},'FontSize', fontsize-1,'interpreter','latex')


ax21 = subplot('position',[0.2 panelsize_lines]);
annotation('textbox',[0.195 annposition_lines],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])

%%
ne = 3
expname = EXPNAME{ne};
ax3 = subplot('position',[0.35 panelsize]);
annotation('textbox',[0.345 annposition],'String','(i)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',68,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax3,100,3.5,{'$\mathrm{\Delta S}=$','$0$ psu'},'FontSize', fontsize-1,'interpreter','latex')
text(ax3,100,3,{'\textbf{Ref.}'},'FontSize', fontsize-1,'interpreter','latex','color',orange)


ax31 = subplot('position',[0.35 panelsize_lines]);
annotation('textbox',[0.345 annposition_lines],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])

%%
ne = 4
expname = EXPNAME{ne};
ax4 = subplot('position',[0.5 panelsize]);
annotation('textbox',[0.495 annposition],'String','(j)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',60,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax4,95,3.5,{'$\mathrm{\Delta S}=$','$0.21$ psu'},'FontSize', fontsize-1,'interpreter','latex')


ax41 = subplot('position',[0.5 panelsize_lines]);
annotation('textbox',[0.495 annposition_lines],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])

%%
ne = 5
expname = EXPNAME{ne};
ax5 = subplot('position',[0.65 panelsize]);
annotation('textbox',[0.645 annposition],'String','(k)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',90,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax5,95,3.5,{'$\mathrm{\Delta S =}$','$0.42$ psu'},'FontSize', fontsize-1,'interpreter','latex')


ax51 = subplot('position',[0.65 panelsize_lines]);
annotation('textbox',[0.645 annposition_lines],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])

%%
ne = 6
expname = EXPNAME{ne};
ax6 = subplot('position',[0.8 panelsize]);
load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL','SIuice','SIarea','SIheff');
UVEL(UVEL==0) = NaN;
aaa1=squeeze(nanmean(UVEL,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));
set(gca,'color',boxcolor);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
load([outdir '/' expname '_gamma_n.mat'])
gamma_n(gamma_n==0) = NaN;
gamma = squeeze(nanmean(gamma_n,1));
[M,c] = contour(yy(1:Ny-25)/1000,-zz/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
% clabel(M,c,'LabelSpacing',90,'FontSize', fontsize-2.5,'interpreter','latex');
hold off;
set(gca,'fontsize',fontsize-2);
colormap(mycolormap);
caxis(CLIM);
xlim(XLIM);
set(gca,'YTick',[0:1:4]);
set(gca,'TickLength',[0.02 0.035])
text(ax6,95,3.5,{'$\mathrm{\Delta S =}$','$0.62$ psu'},'FontSize', fontsize-1,'interpreter','latex')
annotation('textbox',[0.795 annposition],'String','(l)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');

%%% Add colorbar
handle = colorbar;
set(handle,'Position',colorbarposition);


ax61 = subplot('position',[0.8 panelsize_lines]);
annotation('textbox',[0.795 annposition_lines],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
uso = mean(UVEL(:,:,1),1);
uice = mean(SIuice(:,:,1),1);
plot(yy(1:Ny-12)/1000,uso(1:Ny-12))
hold on;
plot(yy(1:Ny-12)/1000,uice(1:Ny-12));
set(gca,'FontSize',fontsize-2)
hold off;
xlim(XLIM);
ylim(lineYLIM);
set(gca,'yticklabel', [],'TickLength',[0.02 0.035])



leg3 = legend('$u^s_o$','$u_i$ (m/s)','FontSize', fontsize+2,'interpreter','latex','orientation','horizontal');
legend boxoff; set(leg3,'position',[0.1 0.93 0.05 0.05])
  

%%
print('-dpng','-r150','jpo_circ_structure.png');
% export_fig jpo_circ_structure.png -native