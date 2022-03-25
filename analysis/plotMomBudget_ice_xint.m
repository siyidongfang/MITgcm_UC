%%%
%%% plotMomBudget_ice_xint.m
%%%
%%% Plot the time-and-zonal-mean momentum budget terms for sea ice
%%%
clear all; close all

basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/experiments/products;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;

% expdir = '/data/MITgcm_ASF-csi/experiments/';
expdir = '/home/csi/MITgcm_ASF-experiments';
outdir = '/data/MITgcm_ASF-csi/experiments/products';
expnames = { ...
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'fresh02-bumps4depth600-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  'fresh02-bumps8depth300-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25'
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'  
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2' 
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5' 
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   
};
titlenames = {...
    'Reference case'
    'Sea ice thickness = 0.2 m'
    'Bump width = 100km, depth = 400m'
    'Bump width = 50km, depth = 300m'
    'Sea ice thickness = 0.6 m'
    'No tides'
    'A$_{tide} = 0.075$ m/s'
    'A$_{tide} = 0.1$ m/s'
    'Reference case (smaller ui, vi)'
    'Weaker zonal wind (Ua$_{south} = -4$ m/s)'
    'Stronger zonal wind (Ua$_{south} = -8$ m/s)'
    'Weaker meridional wind (Va$_{south} = 4$ m/s)'
    'S$_{diff} = 2 \Delta $S'
    'S$_{diff} = 2.5 \Delta $S'
    'Very dense: S$_{diff} = 3 \Delta $S'
    'Very fresh: S$_{south} = 33$ psu'
    'S$_{south} = 33.59$ psu'
    'Slope half-width = 75 km'
    'Slope half-width = 125 km'
    'Low res: dx = dy = 5 km'
    'Low res: dx = dy = 10 km'};


Nexp = length(expnames);
fontsize = 15;

imgname = 'figures_icemomentum_zint'


% for n=2:Nexp
for n=1:1

expname = expnames{n};
calcMomBudget_ice_xint;

%%% Plot terms in momentum budget
figure(1)
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5);
hold on;
l7 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5);
l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5);
l5 = plot(yy/1000,meanAdv_xint/1e4,'LineWidth',1.5);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
set(gca,'fontsize',fontsize);
ylabel('Sea ice zonal force balance (10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
legend([l1 l2 l3 l4 l5 l7],'Wind stress','Ocean-ice drag','Coriolis force',...
    'Sea ice internal stress','Mean advection','Residual term','interpreter','latex', 'FontSize', fontsize);
xlim([20,420])
title(titlenames{n},'FontSize',fontsize+2,'interpreter','latex');
% ylim([-10 10])
set(gcf,'position',[225 321 759 617]);
% saveas(gcf,[outdir '/' imgname '/' expname '_iceMomentumZint.png']);

%%% Plot terms in momentum budget
figure(10)
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5);
hold on;
l7 = plot(yy/1000,-(meanAdv_xint + TAUai_xint + TAUoi_xint + coriolisforce)/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5);
l5 = plot(yy/1000,meanAdv_xint/1e4,'LineWidth',1.5);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
set(gca,'fontsize',fontsize);
ylabel('Sea ice zonal force balance (10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
legend([l1 l2 l3 l5 l7],'Wind stress','Ocean-ice drag','Coriolis force','Mean advection',...
    'Residual terms','interpreter','latex', 'FontSize', fontsize);
xlim([20,420])
title(titlenames{n},'FontSize',fontsize+2,'interpreter','latex');
set(gcf,'position',[225 321 759 617]);
% saveas(gcf,[outdir '/' imgname '/' expname '_iceMomentumZint_truncated.png']);


figure(2)
l1 = plot(yy/1000,uo_xavg,'LineWidth',1.5);
hold on;
l2 = plot(yy/1000,ui_xavg,'LineWidth',1.5);
% l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
set(gca,'fontsize',fontsize);
ylabel('(m/s)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
Legenduiuo = legend([l1 l2],'Ocean surface zonal velocity','Ice zonal velocity $u_i$','FontSize', fontsize,'interpreter','latex');
set(Legenduiuo,'Position',[0.4740 0.2575 0.3939 0.1774]);
title(titlenames{n},'FontSize',fontsize+2,'interpreter','latex');
xlim([25,425])
set(gcf,'position',[225 321 759 296]);
saveas(gcf,[outdir '/' imgname '/' expname '_UiUo.png']);

figure(3)
l1 = plot(yy/1000,hi_xavg,'LineWidth',1.5);
hold on;
l2 = plot(yy/1000,Ai_xavg,'LineWidth',1.5);
% l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
hold off;
set(gca,'fontsize',fontsize);
% ylabel('(m/s)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
Legenduiuo = legend([l1 l2],'Sea ice thickness $h_i$ (m)','Sea ice fraction $A_i$','FontSize', fontsize,'interpreter','latex');
set(Legenduiuo,'Position',[0.4740 0.2575 0.3939 0.1774]);
title(titlenames{n},'FontSize',fontsize+2,'interpreter','latex');
xlim([25,425])
% ylim([0.99 1])
set(gcf,'position',[225 321 759 296]);
% saveas(gcf,[outdir '/' imgname '/' expname '_hiAi.png']);


figure(4);
pcolor(xx/1000,yy/1000,dsig12_dy');shading interp;
set(gca,'fontsize',fontsize);
xlabel('Alongshore distance (km)','interpreter','latex', 'FontSize', fontsize+2);
ylabel('Offshore distance (km)','interpreter','latex','FontSize', fontsize+2);
title([titlenames{n} ': $\partial_y \sigma_{12}$'],'interpreter','latex','FontSize', fontsize+2);
colormap('redblue');colorbar;
caxis([-6,6])
% saveas(gcf,[outdir '/' imgname '/' expname '_dsig12dy.png']);
% 
% figure(Nexp*4+n);
% pcolor(xx/1000,yy/1000,SIeta(:,:,1)');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title('SIeta' );
% colormap('redblue');colorbar;
% 
% figure(Nexp*5+n);
% pcolor(xx/1000,yy/1000,(dvi_dx + dui_dy)');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title('(dvi_dx + dui_dy)' );
% colormap('redblue');colorbar;
% caxis([-10 10]/1e7)
% 
% 
% figure(200);
% clf;
% subplot(1,2,1)
% pcolor(xx/1000,yy/1000,(ui-mean(mean(ui)))');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title('u_{ice} (m/s)');
% colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-0.01 0.01]);
% 
% subplot(1,2,2)
% pcolor(xx/1000,yy/1000,(vi-mean(mean(vi)))');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title('v_{ice} (m/s)');
% colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-0.01 0.01]);



end

