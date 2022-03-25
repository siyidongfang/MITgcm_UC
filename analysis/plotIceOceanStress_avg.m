%%%
%%% plotIceOceanSTress_avg.m
%%%
%%% Plot IceOceanSTress
%%%

clear all;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/newexp/data_poster; 
addpath /data/MITgcm_ASF-csi/newexp/data_poster_backup; 


expdir = '/data/MITgcm_ASF-csi/newexp/';

load ice-ocn-stress.mat;

Lx = 400000;

% %%% Plotting options
fontsize = 11;

groupname = 'fresh02_ice'


figure(1);
plot(yy/1000,tao_iox_xavg(1,:),'LineWidth',1.5,'color',[0 0.4470 0.7410]);
hold on
plot(yy/1000,tao_iox_xavg(8,:),'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
plot(yy/1000,tao_iox_xavg(9,:),'LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);
plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)

hold off
set(gca,'fontsize',fontsize);
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(N/m$^2$)','FontSize', fontsize+2,'interpreter','latex');
title({'Zonal ice-ocean stress'},'interpreter','latex','FontSize', fontsize+4);
set(gcf,'position',[225 683 577 255]);
xlim([20 200]);
% ylim([-8 3]);
% legend('No tide','Weak tides','Strong tides','interpreter','latex')
legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
saveas(gcf,[expdir 'data_poster_backup/' groupname '_TAUiox2.png']);
saveas(gcf,[expdir 'data_poster_backup/img_fig/' groupname '_TAUiox.fig']);



figure(2);
plot(yy/1000,tao_ioy_xavg(1,:),'LineWidth',1.5,'color',[0 0.4470 0.7410]);
hold on
plot(yy/1000,tao_ioy_xavg(8,:),'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
plot(yy/1000,tao_ioy_xavg(9,:),'LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);
% plot(yy/1000,zeros(1,size(yy,2)),'--','color',[128 128 128]/255)

hold off
set(gca,'fontsize',fontsize);
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(N/m$^2$)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional ice-ocean stress'},'interpreter','latex','FontSize', fontsize+4);
set(gcf,'position',[225 683 577 255]);
xlim([20 200]);
% ylim([-8 3]);
% legend('No tide','Weak tides','Strong tides','interpreter','latex')
legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
saveas(gcf,[expdir 'data_poster_backup/' groupname '_TAUioy2.png']);
saveas(gcf,[expdir 'data_poster_backup/img_fig/' groupname '_TAUioy.fig']);



figure(3);
plot(yy/1000,SIuice_xavg(1,:),'-.','LineWidth',1.5,'color',[0 0.4470 0.7410]);
hold on
plot(yy/1000,Uo_surf_xavg(1,:),'LineWidth',1.5,'color',[0 0.4470 0.7410]);

plot(yy/1000,SIuice_xavg(8,:),'-.','LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
plot(yy/1000,Uo_surf_xavg(8,:),'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);

plot(yy/1000,SIuice_xavg(9,:),'-.','LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);
plot(yy/1000,Uo_surf_xavg(9,:),'LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);

% plot(yy/1000,zeros(1,size(yy,2)),'--','LineWidth',0.5,'color',[128 128 128]/255)

hold off
set(gca,'fontsize',fontsize);
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(m/s)','FontSize', fontsize+2,'interpreter','latex');
title({'Zonal ice and ocean surface velocities'},'interpreter','latex','FontSize', fontsize+4);
set(gcf,'position',[225 573 572 365]);
xlim([0 450]);
% ylim([-8 3]);
legend('No tides: u$_i$','No tides: u$_o$','Weak tides: u$_i$','Weak tides: u$_o$',...
    'Strong tides: u$_i$','Strong tides: u$_o$','interpreter','latex')
legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
saveas(gcf,[expdir 'data_poster_backup/' groupname '_ui_uo.png']);
saveas(gcf,[expdir 'data_poster_backup/img_fig/' groupname '_ui_uo.fig']);



figure(4);
plot(yy/1000,SIvice_xavg(1,:),'-.','LineWidth',1.5,'color',[0 0.4470 0.7410]);
hold on
plot(yy/1000,Vo_surf_xavg(1,:),'LineWidth',1.5,'color',[0 0.4470 0.7410]);

plot(yy/1000,SIvice_xavg(8,:),'-.','LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);
plot(yy/1000,Vo_surf_xavg(8,:),'LineWidth',1.5,'color',[0.4660 0.6740 0.1880]);

plot(yy/1000,SIvice_xavg(9,:),'-.','LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);
plot(yy/1000,Vo_surf_xavg(9,:),'LineWidth',1.5,'color',[0.8500 0.3250 0.0980]);

plot(yy/1000,zeros(1,size(yy,2)),'--','LineWidth',0.5,'color',[128 128 128]/255)

hold off
set(gca,'fontsize',fontsize);
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(m/s)','FontSize', fontsize+2,'interpreter','latex');
title({'Meridional ice and ocean surface velocities'},'interpreter','latex','FontSize', fontsize+4);
set(gcf,'position',[225 573 572 365]);
xlim([0 450]);
% ylim([-8 3]);
% legend('No tides: u$_i$','No tides: u$_o$','Weak tides: u$_i$','Weak tides: u$_o$',...
%     'Strong tides: u$_i$','Strong tides: u$_o$','interpreter','latex')
% legend('h$_{i0}$ = 1 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 0.2 m','interpreter','latex')
% legend('Reference: u$_{a0}$ = -6 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker u$_a$: u$_{a0}$= -4 m/s, v$_{a0}$= 6 m/s','Stronger u$_a$: u$_{a0}$ = -8 m/s, v$_{a0}$ = 6 m/s',...
%     'Weaker v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 4 m/s','Stronger v$_a$: u$_{a0}$ = -6 m/s, v$_{a0}$ = 8 m/s','interpreter','latex')
box on;
saveas(gcf,[expdir 'data_poster_backup/' groupname '_vi_vo.png']);
saveas(gcf,[expdir 'data_poster_backup/img_fig/' groupname '_vi_vo.fig']);