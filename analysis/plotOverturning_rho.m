%%%
%%% plotOverturning.m
%%%
%%% Plots the overturning circulation in potential density space.
%%%
clear all; 
% close all

basedir = '/data/MITgcm_ASF-csi/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/analysis;
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
addpath /data/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
addpath /data/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /data/MITgcm_ASF-csi/analysis/jpo_analysis;

% expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
expdir = '/home/csi/MITgcm_ASF-experiments';
outdir = '/data/MITgcm_ASF-csi/cross_slope_exchange';
prodir = '/data/MITgcm_ASF-csi/products-lores/moc/';


%%%%%%%%%%%%%%% Low-res
EXPNAME = { ...
  'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
%   'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
%   'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
%   ...
%   'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
%   'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',...
%   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
%   'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
};

% titlenames = {...
%     '(Low-res) Ws = 75 km'
%     '(Low-res) Ws = 125 km'
%     '(Low-res) S$_{south} = 33$ psu'
%     '(Low-res) S$_{south} = 33.59$ psu'
%     '(Low-res) Reference case '
%     '(Low-res) S$_{diff} = 1 \Delta $S'
%     '(Low-res) S$_{diff} = 2 \Delta $S'
%     '(Low-res) S$_{diff} = 2.5 \Delta $S'
%     '(Low-res) S$_{diff} = 3 \Delta $S'
% %     'Low res: dx = dy = 5 km'
% %     'Low res: dx = dy = 10 km'...
% %     'Sea ice thickness = 0.2 m'
% %     'Sea ice thickness = 0.6 m'
% %     '(Low-res) No tides'
% %     'A$_{tide} = 0.075$ m/s'
% %     'A$_{tide} = 0.1$ m/s'
% %     'Weaker zonal wind (Ua$_{south} = -4$ m/s)'
% %     'Stronger zonal wind (Ua$_{south} = -8$ m/s)'
% %     'Weaker meridional wind (Va$_{south} = 4$ m/s)'
%     };


Nexp = length(EXPNAME);


%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 16;
framepos = [0 scrsz(4)/2 1200 1200];
plotloc = [0.15 0.15 0.7 0.75];

PSIlim1=[-0.3 0.3];
PSIlim2=[-1.2 1.2];
%%% Set colormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
imgname = 'figures_overturning_new';

figure(12)


%% Load experiment and pre-computed MOC data
for n=1:Nexp
expname = EXPNAME{n}
% titlename = titlenames{n}
titlename = '';
clear layers_name
loadexp;
load([prodir '/' expname,'_MOC_rho_Aocean.mat']);
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
[ZZ,YY] = meshgrid(zz,yy);


%%
%%% Plot the residual overturning in y/z space
YLIM = [36.2 37.3];
clf;
axes('FontSize',fontsize);
subplot(2,2,1)
pcolor(yy/1000,ptlevs,psi_pt');
shading interp;colormap('redblue');colorbar;caxis(PSIlim1);ylim(YLIM);
handle=colorbar;
set(handle,'FontSize',fontsize);
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('$\sigma_2\ (kg\ m^{-3})$','interpreter','latex','FontSize',fontsize);
% set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title([titlename '$\psi_{\mathrm{res}}$ (Sv)'],'FontSize',fontsize+1,'interpreter','latex');


%%
[DD,LL] = meshgrid(ptlevs,yy);
subplot(2,2,2)
pcolor(LL/1000,-Zisop/1000,psi_pt);
shading interp;colormap('redblue');colorbar;caxis(PSIlim1);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
% set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title([titlename '$\psi_{\mathrm{res}}$ (Sv)'],'FontSize',fontsize+1,'interpreter','latex');

%%
subplot(2,2,3)
pcolor(LL/1000,-Zisop/1000,psim_pt);
shading interp;colormap('redblue');colorbar;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% [C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title([titlename '$\psi_{\mathrm{mean}}$ (Sv)'],'FontSize',fontsize+1,'interpreter','latex');

subplot(2,2,4)
pcolor(LL/1000,-Zisop/1000,psie_pt);
shading interp;colormap('redblue');colorbar;caxis(PSIlim2);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% [C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
colormap(mycolormap);
xlabel('$y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
title([titlename '$\psi_{\mathrm{eddy}}$ (Sv)'],'FontSize',fontsize+1,'interpreter','latex');

saveas(gcf,[outdir '/' imgname '/' expname '_OT.png']);



end
