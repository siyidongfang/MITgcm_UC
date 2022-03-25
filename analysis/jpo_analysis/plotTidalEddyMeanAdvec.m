clear all;close all

addpath ../analysis/colormaps/
expdir = '/data/MITgcm_ASF-csi/experiments/';
expname = 'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily'   % Nlayers=53
% expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2-daily' % Nlayers=50
% expname = 'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily'  % Nlayers=47

outdir = '/data/MITgcm_ASF-csi/experiments/products'
imgname = 'figures_tidaleddymean';

loadexp;
load([exppath '/' expname,'tidalEddyMeanAdvec_newDELR.mat']);
load([exppath '/' expname '_tavg_5yrs16-20_momAdvec.mat'],'WVEL');
load([exppath '/input/setParams.mat']);


fontsize = 13;
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

figure(1)
plot(yy/1000,tidalAdvec_xzint/1e4,'Color',green,'LineWidth',1)
hold on
plot(yy/1000,eddyAdvec_xzint/1e4,'LineWidth',1)
plot(yy/1000,meanAdvec_xzint/1e4,'LineWidth',1)
plot(yy/1000,totalAdvec_xzint/1e4,'Color',lightblue,'LineWidth',2)
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1)
hold off 
xlim([20,430])
legend('Tidal advection','Eddy advection','Mean advection','Total advection','FontSize', fontsize,'interpreter','latex')
title('Decomposition of the total advection','FontSize',fontsize+2,'interpreter','latex')
xlabel('Offshore distance y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('$(10^4\ N/m)$','FontSize', fontsize+2,'interpreter','latex');
% saveas(gcf,[outdir '/' imgname '/' expname(1:9) '_advec.png']);

figure(2)
plot(yy/1000,meanVorAdv_xzint/1e4,'Color',yellow,'LineWidth',1)
hold on
plot(yy/1000,meanVerAdv_xzint/1e4,'Color',blue,'LineWidth',1)
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1)
xlim([30 420])
hold off
legend('Mean vorticity advection','Mean vertical advection','FontSize', fontsize,'interpreter','latex')
title('Decomposition of the mean advection','FontSize',fontsize+2,'interpreter','latex')
xlabel('Offshore distance y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('$(10^4\ N/m)$','FontSize', fontsize+2,'interpreter','latex');
% saveas(gcf,[outdir '/' imgname '/' expname(1:9) '_meanVorVer.png']);


figure(3)
plot(yy/1000,eddyVorAdv_xzint/1e4,'Color',green,'LineWidth',1)
hold on
plot(yy/1000,eddyVerAdv_xzint/1e4,'Color',lightblue,'LineWidth',1)
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1)
xlim([30 420])
hold off
legend('Eddy vorticity advection','Eddy vertical advection','FontSize', fontsize,'interpreter','latex')
title('Decomposition of the eddy advection','FontSize',fontsize+2,'interpreter','latex')
xlabel('Offshore distance y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('$(10^4\ N/m)$','FontSize', fontsize+2,'interpreter','latex');
% saveas(gcf,[outdir '/' imgname '/' expname(1:9) '_eddyVorVer.png']);



figure(4)
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
wm_zint = sum(WVEL.*hFacC.*DZ_xyz,3)./abs(h);
pcolor(xx/1000,yy/1000,wm_zint'*1000)
ylim([20 420])
shading interp;   
set(gca,'fontsize',fontsize);
colorbar;caxis([-1 1]);
colormap('redblue')
title('Depth-averaged vertical velocity (10$^{-3}\ m/s$)','FontSize',fontsize+2,'interpreter','latex')
ylabel('Offshore distance y (km)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('Along-slope distance x (km)','FontSize', fontsize+2,'interpreter','latex');
% saveas(gcf,[outdir '/' imgname '/' expname(1:9) '_w.png']);
