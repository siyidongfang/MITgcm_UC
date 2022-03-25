%%%
%%% plotStress_zInteg.m
%%%
%%% Plot stress terms
%%%

clear all;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/newexp/data_poster; 
addpath /data/MITgcm_ASF-csi/newexp/data_poster_backup; 


expdir = '/data/MITgcm_ASF-csi/newexp/';

load stress.mat;

Lx = 400000;
rho0 = 1000;

% %%% Plotting options
fontsize = 11;

groupname = 'fresh02_ice'


figure(1);
% plot(yy/1000,-oceTAUX_xavg(2,:),'--','color',[0.9290 0.6940 0.1250],'LineWidth',1.5);
hold on
ax = gca;
ax.ColorOrderIndex = 4;
% plot(yy/1000,rho0*Um_Diss_zint_xavg(2,:),'--','LineWidth',1.5);
ax.ColorOrderIndex = 3;
plot(yy/1000,-oceTAUX_xavg(3,:),'color',[0.9290 0.6940 0.1250],'LineWidth',1.5);
plot(yy/1000,-SIatmTx_xavg(2,:),'LineWidth',1.5);
% plot(yy/1000,SIatmTx_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*DuveddyDy_zint_xavg(2,:),'--','LineWidth',1.5);
% plot(yy/1000,rho0*DuveddyDy_zint_xavg(3,:),'LineWidth',1.5);
plot(yy/1000,rho0*Um_Diss_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_Advec_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_Cori_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_dPhiX_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_Ext_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_AdvZ3_zint_xavg(3,:),'LineWidth',1.5);
% plot(yy/1000,rho0*Um_AdvRe_zint_xavg(3,:),'LineWidth',1.5);


plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)


hold off
set(gca,'fontsize',fontsize);
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(N/m$^2$)','FontSize', fontsize+2,'interpreter','latex');
title({'Zonal momentum budget'},'interpreter','latex','FontSize', fontsize+4);
set(gcf,'position',[225 683 577 255]);
xlim([20 200]);
% ylim([-8 3]);
% legend('oceTAUX_xavg','DuveddyDy_zint_xavg','Um_Diss_zint_xavg','Um_Advec_zint_xavg',...
%     'Um_Cori_zint_xavg','Um_dPhiX_zint_xavg','Um_Ext_zint_xavg','Um_AdvZ3_zint_xavg','Um_AdvRe_zint_xavg',...
%     'interpreter','latex')
% legend('No tide','Weak tides','Strong tides','interpreter','latex')
% legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
% saveas(gcf,[expdir 'data_poster_backup/' groupname '_TAUiox2.png']);
% saveas(gcf,[expdir 'data_poster_backup/img_fig/' groupname '_TAUiox.fig']);



