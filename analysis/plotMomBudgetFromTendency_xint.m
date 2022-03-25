%%%
%%% plotMomBudgetFromTendency_xint.m
%%%
%%% Convenience script to plot the momentum budget from momentum tendency diagnostics.
%%%

clear all;close all;

basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/experiments/products;
addpath ../jpo_analysis/

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

fontsize = 13;

for n=1:1

expname = expnames{n};
calcMomBudgetFromTendency_xint;

figure(1)
l1 = plot(yy/1000,windStress_xint/1e4,'-.','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5);
l11 = plot(yy/1000,(Um_Advec_xzint+Um_Diss_xzint)/1e4,':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('Ocean zonal force balance (10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
legend([l1 l2 l3 l4 l5 l11 l0],'Wind stress',...
    'Ice-ocean drag',...
    'Topog. form stress',...
    'Dissipation',...
    'Advection terms',...
    'Advection + Dissipation',...
    'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
title(titlenames{n},'FontSize',fontsize+2,'interpreter','latex');
set(gcf,'position',[225 422 676 516]);
% saveas(gcf,[outdir '/' imgname '/' expname '_MomentumTendency.png']);




figure(2)
l1 = plot(yy/1000,windStress_xint/1e4,'-.','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5);
% l6 = plot(yy/1000,AB_gU_xzint/1e4,'LineWidth',1.5);
l7 = plot(yy/1000,Um_Cori_xzint/1e4,'--','LineWidth',0.2,'color','r');
l8 = plot(yy/1000,Um_AdvZ3_xzint/1e4,'--','LineWidth',0.2);
l9 = plot(yy/1000,Um_AdvRe_xzint/1e4,'--','LineWidth',0.2);
l10 = plot(yy/1000,(Um_Cori_xzint+Um_AdvZ3_xzint+Um_AdvRe_xzint)/1e4,'*','LineWidth',0.2,'color',[0.3010 0.7450 0.9330]);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('Ocean zonal force balance (10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
legend([l1 l2 l3 l4 l5 l7 l8 l9 l10 l0],'Wind stress',...
    'Ice-ocean drag',...
    'Topog. form stress',...
    'Dissipation',...
    'Advection terms',...
    'Coriolis term',...
    'Vorticity Advection',...
    'Vertical Advection (Explicit part)',...
    'Cori.+Vort. Adv.+Vert. Adv.(Explicit)',...  
    'Residual term', 'FontSize', fontsize,'interpreter','latex');
%     'Adams-Bashforth',...

title(titlenames{n},'FontSize',fontsize+3,'interpreter','latex');
% ylim([-10 10])
set(gcf,'position',[335 272 1349 791]);
% saveas(gcf,[outdir '/' imgname '/' expname '_MomentumTendency_all.png']);

end