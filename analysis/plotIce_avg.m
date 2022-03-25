%%%
%%% plotIce_avg.m
%%%
%%% Plot the domain-averaged ice properties
%%%

clear all;close all;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/newexp/data_poster_backup; 

expdir = '/data/MITgcm_ASF-csi/newexp/';

load ice_xAvg_domainAvg_5yrs.mat;

% %%% Plotting options
fontsize = 11;

% groupname = 'den02_wind'

atide = [0,0.05,0.1];
hi_noTideweakTide_fresh = [SIheff_avg(2),SIheff_avg(1)];
hi_strongTide_fresh = [SIheff_avg(3)];

hi_noTideweakTide_den02 = [SIheff_avg(11),SIheff_avg(10)];
hi_strongTide_den02 = [SIheff_avg(12)];

hi_noTideweakTide_dense = [SIheff_avg(20),SIheff_avg(19)];
hi_strongTide_dense = [SIheff_avg(21)];


size_marker = 100;


figure(1)

l1 = plot(atide,[hi_noTideweakTide_fresh hi_strongTide_fresh],'color',[128 128 128]/255);
hold on;
s11 = scatter(atide(1:2), hi_noTideweakTide_fresh,size_marker,'o','filled',...
    'MarkerEdgeColor',[45 124 203]/255,'MarkerFaceColor',[115 176 238]/255,'LineWidth',1);
s12 = scatter(atide(3), hi_strongTide_fresh,size_marker,'o','filled',...
    'MarkerEdgeColor',[213 173 9]/255,'MarkerFaceColor',[240 202 48]/255,'LineWidth',1);

l2 = plot(atide,[hi_noTideweakTide_den02 hi_strongTide_den02],'color',[128 128 128]/255);
s21 = scatter(atide(1:2), hi_noTideweakTide_den02,size_marker,'d','filled',...
    'MarkerEdgeColor',[45 124 203]/255,'MarkerFaceColor',[115 176 238]/255,'LineWidth',1);
s22= scatter(atide(3), hi_strongTide_den02,size_marker,'d','filled',...
    'MarkerEdgeColor',[213 173 9]/255,'MarkerFaceColor',[240 202 48]/255,'LineWidth',1);

l3 = plot(atide,[hi_noTideweakTide_dense hi_strongTide_dense],'color',[128 128 128]/255);
s31 = scatter(atide(1:2), hi_noTideweakTide_dense,size_marker+40,'h','filled',...
    'MarkerEdgeColor',[45 124 203]/255,'MarkerFaceColor',[115 176 238]/255,'LineWidth',1);
s32 = scatter(atide(3), hi_strongTide_dense,size_marker+40,'h','filled',...
    'MarkerEdgeColor',[213 173 9]/255,'MarkerFaceColor',[240 202 48]/255,'LineWidth',1);
hold off;
set(gca,'fontsize',fontsize);
xlabel('Northern boundary tidal current amplitude (m/s)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('h$_i$ (m)','FontSize', fontsize+2,'interpreter','latex');
title('Domain-averaged sea ice thickness','FontSize', fontsize+3,'interpreter','latex');
legend([s11,s21,s31],{'Fresh shelf','Medium-density shelf','Dense shelf'},'FontSize', fontsize,'interpreter','latex');
% set(gcf,'Position',[435 253 583 257]);
set(gcf,'Position',[430 248 449 269]);
yticks([1 1.5]);
xticks([0 0.05 1]);

box on;

saveas(gcf,[expdir '/data_poster/hi_atide.png']);
% saveas(gcf,[expdir '/data_poster/hi_atide_avg.fig']);


%%% TODO: understand changes in SIdelta, SIpress, SIshear, SIzeta
%%% Easy to understand: changes in SIempmr, SIqnet