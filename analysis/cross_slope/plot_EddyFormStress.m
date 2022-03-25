clear;

addpath ../../../MITgcm_ASF-csi/utils/matlab/; 
addpath ../../../MITgcm_ASF-csi/analysis/;
addpath ../../../MITgcm_ASF-csi/newexp/;
addpath ../../../MITgcm_ASF-csi/analysis/colormaps/;
addpath  ../../../MITgcm_ASF-csi/analysis/jpo_analysis/;
prodir = '../../../MITgcm_ASF-csi/products-hires/';
% expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/exps_cross-slope-exchange';
expdir = '../../../MITgcm_ASF-csi/experiments/';
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'; % load experimental configuration
loadexp;

outdir = '../../../MITgcm_ASF-csi/cross_slope_exchange/figures_EddyFormStress/'
expname = 'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
fname = 'Atide=0.025m/s'

%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'

load([prodir 'IFS/' expname '-IFS.mat'],'IFS_standing_Estimate_xavg','IFS_transient_Estimate_xavg','yy','zz');
load([prodir 'IFS/' expname '-wu.mat'],'uw_standing_xavg','uw_transient_xavg');

total_transient = IFS_transient_Estimate_xavg+uw_transient_xavg;
total_standing = IFS_standing_Estimate_xavg+uw_standing_xavg;

[ZZ,YY] = meshgrid(zz,yy);
fontsize=13;
cmin = -0.001;
cmax = 0.001;


%%
figure(1)

subplot(3,2,1)
pcolor(yy/1000,zz/1000,IFS_transient_Estimate_xavg');shading interp;
% colormap(cmocean('balance',101));
colormap('redblue')
colorbar;
caxis([cmin cmax]);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Transient: IFS','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(3,2,2)
pcolor(yy/1000,zz/1000,IFS_standing_Estimate_xavg');shading interp;
colorbar;
caxis([cmin cmax]/10);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Standing: IFS','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(3,2,3)
pcolor(yy/1000,zz/1000,uw_transient_xavg');shading interp;
colorbar;
caxis([cmin cmax]);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Transient: uw','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(3,2,4)
pcolor(yy/1000,zz/1000,uw_standing_xavg');shading interp;
colorbar;
caxis([cmin cmax]/10);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Standing: uw','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(3,2,5)
pcolor(yy/1000,zz/1000,total_transient');shading interp;
colorbar;
caxis([cmin cmax]);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Transient: total','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(3,2,6)
pcolor(yy/1000,zz/1000,total_standing');shading interp;
colorbar;
caxis([cmin cmax]/10);
hold on;plot(yy/1000,bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,bathy(50,:)/1000,'k','LineWidth',1.5);
xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
ylabel('z (km)','FontSize', fontsize,'interpreter','latex');
title('Standing: total','FontSize', fontsize+2,'interpreter','latex');
hold off;
set(gca,'FontSize',fontsize)
text(20,-3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


print('-dpng','-r150',[outdir expname '.png']);
