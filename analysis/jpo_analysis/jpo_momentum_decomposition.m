%%%
%%% jpo_momentum_decomposition.m
%%%

% clear all;close all;
addpath /data/MITgcm_ASF-csi/newexp/analysis
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;
addpath ../jpo_analysis/
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
prodir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/products/';

blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 450 900]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 11;
boxcolor = [225 225 225]/255;
subplotsize = [0.86 0.27];

%%% Make the plot
clf;
%%

%%%%%%
expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2-daily' % Nlayers=50
loadexp
exppath = [expdir expname];
load([exppath '/' expname,'tidalEddyMeanAdvec_newDELR.mat']);
% load([exppath '/calcTidalEddyMeanTAUio.mat']);
%%%%%%

ax1 = subplot('position',[0.13 0.7 subplotsize]);
annotation('textbox',[0.9 0.685 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,totalAdvec_xzint/1e4,'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,eddyAdvec_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,meanAdvec_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,tidalAdvec_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);

yup = -4.5;
ydown = 2;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-4.1,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,-4.1,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-4.1,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,1.6,'Ref.','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1,'interpreter','latex');
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total ocean advection','Tidal component','Eddy component','Mean component',...
    'FontSize', fontsize,'interpreter','latex'); 
% 'Total ocean adv.','Tidal advection','Eddy advection','Mean advection',...
set(leg3,'position',[0.5762    0.8244    0.3277    0.1040])
xlim([20,420])
title('Decomposition of the total advection','FontSize',fontsize+2,'interpreter','latex');



%%

%%%%%%
expname = 'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily' % Nlayers=50
exppath = [expdir expname];
load([exppath '/' expname,'tidalEddyMeanAdvec_newDELR.mat']);
load([exppath '/calcTidalEddyMeanTAUio.mat']);
%%%%%%

ax2 = subplot('position',[0.13 0.38 subplotsize]);
annotation('textbox',[0.9 0.365 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,totalAdvec_xzint/1e4,'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,eddyAdvec_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,meanAdvec_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,tidalAdvec_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);

yup = -20;
ydown = 15;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-17.5,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,-17.5,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-17.5,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,13,'$\Delta\mathrm{S}=0.62$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,420])


%%

%%%%%%
expname = 'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily' % Nlayers=50
exppath = [expdir expname];
load([exppath '/' expname,'tidalEddyMeanAdvec_newDELR.mat']);
load([exppath '/calcTidalEddyMeanTAUio.mat']);
%%%%%%

ax3 = subplot('position',[0.13 0.06 subplotsize]);
annotation('textbox',[0.9 0.045 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,totalAdvec_xzint/1e4,'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,eddyAdvec_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,meanAdvec_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,tidalAdvec_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6;
ydown = 3.2;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-5.4,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,-5.4,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-5.4,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,2.7,'$\Delta\mathrm{S}=-1.17$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distsance (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([20,420])

%% Write to file
% print('-dpng','-r150','jpo_momentum_decomposition.png');