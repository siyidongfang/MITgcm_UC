clear;

addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/data/MITgcm_ASF-csi/products-hires'
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';


expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis_new80s'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_new80s'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new80s'

loadexp;

nIter = 145800;


SIuice = rdmds([exppath,'/results/SIuice'],nIter);
SIvice = rdmds([exppath,'/results/SIvice'],nIter);
oceTAUX = rdmds([exppath,'/results/oceTAUX'],nIter);
SItaux = rdmds([exppath,'/results/SItaux'],nIter);
SIheff = rdmds([exppath,'/results/SIheff'],nIter);
SIarea = rdmds([exppath,'/results/SIarea'],nIter);
SIsig12 = rdmds([exppath,'/results/SIsig12'],nIter);
ETAN = rdmds([exppath,'/results/ETAN'],nIter);


% SIuice = (rdmds([exppath,'/results/SIuice'],1080*6)+...
%     rdmds([exppath,'/results/SIuice'],1080*7)+...
%     rdmds([exppath,'/results/SIuice'],1080*8)+...
%     rdmds([exppath,'/results/SIuice'],1080*9)+...
%     rdmds([exppath,'/results/SIuice'],1080*10))/5;
% SIvice = (rdmds([exppath,'/results/SIvice'],1080*6)+...
%     rdmds([exppath,'/results/SIvice'],1080*7)+...
%     rdmds([exppath,'/results/SIvice'],1080*8)+...
%     rdmds([exppath,'/results/SIvice'],1080*9)+...
%     rdmds([exppath,'/results/SIvice'],1080*10))/5;
% oceTAUX = (rdmds([exppath,'/results/oceTAUX'],1080*6)+...
%     rdmds([exppath,'/results/oceTAUX'],1080*7)+...
%     rdmds([exppath,'/results/oceTAUX'],1080*8)+...
%     rdmds([exppath,'/results/oceTAUX'],1080*9)+...
%     rdmds([exppath,'/results/oceTAUX'],1080*10))/5;
% SItaux = (rdmds([exppath,'/results/SItaux'],1080*6)+...
%     rdmds([exppath,'/results/SItaux'],1080*7)+...
%     rdmds([exppath,'/results/SItaux'],1080*8)+...
%     rdmds([exppath,'/results/SItaux'],1080*9)+...
%     rdmds([exppath,'/results/SItaux'],1080*10))/5;
% SIheff = (rdmds([exppath,'/results/SIheff'],1080*6)+...
%     rdmds([exppath,'/results/SIheff'],1080*7)+...
%     rdmds([exppath,'/results/SIheff'],1080*8)+...
%     rdmds([exppath,'/results/SIheff'],1080*9)+...
%     rdmds([exppath,'/results/SIheff'],1080*10))/5;
% SIarea = (rdmds([exppath,'/results/SIarea'],1080*6)+...
%     rdmds([exppath,'/results/SIarea'],1080*7)+...
%     rdmds([exppath,'/results/SIarea'],1080*8)+...
%     rdmds([exppath,'/results/SIarea'],1080*9)+...
%     rdmds([exppath,'/results/SIarea'],1080*10))/5;
% SIsig12 = (rdmds([exppath,'/results/SIsig12'],1080*6)+...
%     rdmds([exppath,'/results/SIsig12'],1080*7)+...
%     rdmds([exppath,'/results/SIsig12'],1080*8)+...
%     rdmds([exppath,'/results/SIsig12'],1080*9)+...
%     rdmds([exppath,'/results/SIsig12'],1080*10))/5;
% ETAN = (rdmds([exppath,'/results/ETAN'],1080*6)+...
%     rdmds([exppath,'/results/ETAN'],1080*7)+...
%     rdmds([exppath,'/results/ETAN'],1080*8)+...
%     rdmds([exppath,'/results/ETAN'],1080*9)+...
%     rdmds([exppath,'/results/ETAN'],1080*10))/5;
% % 
% Um_dPhiX = rdmds([exppath,'/results/Um_dPhiX'],nIter);
% Um_Advec = rdmds([exppath,'/results/Um_Advec'],nIter);
% Um_Diss = rdmds([exppath,'/results/Um_Diss'],nIter);
% Um_Ext = rdmds([exppath,'/results/Um_Ext'],nIter);



calcMomBudget_ice_xint;
% calcMomBudgetFromTendency_xint;





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
fontsize = 15;


figure(19)
% subplot(1,2,1)
% l1 = plot(yy/1000,windStress_xint/1e4,'--','LineWidth',1.5);
% hold on;
% l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
% l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5,'Color',brown);
% l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5,'Color',yellow);
% l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5,'Color',purple);
% l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5,'Color',green);
% l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
% yup = -15;
% ydown = 15;
% ylim([yup ydown]);
% line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
% text(60,-13.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(132,-13.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(260,-13.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(25,13.5,'$\Delta \sigma_4 =0.409\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
% axis ij
% hold off;
% set(gca,'fontsize',fontsize);
% xlim([20,430])
% ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize+1,'interpreter','latex');


subplot(1,2,2)
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5,'Color',brown);
hold on;
l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5,'Color',blue);
% l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$\Delta \sigma_4 =0.409\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
% quiver(yy(1:int:end)/1000,5*ones(1,Ny_int),...
%     sig12_xavg(30,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'--','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,420])
xlabel('y (km)', 'FontSize', fontsize+1,'interpreter','latex');



% %% Check diffusive heat flux
% 
% nIter = 1080*10
% 
% 
% ADVr_TH = rdmds([exppath,'/results/ADVr_TH'],nIter);
% ADVx_TH = rdmds([exppath,'/results/ADVx_TH'],nIter);
% ADVy_TH = rdmds([exppath,'/results/ADVy_TH'],nIter);
% DFxE_TH = rdmds([exppath,'/results/DFxE_TH'],nIter);
% DFyE_TH = rdmds([exppath,'/results/DFyE_TH'],nIter);
% DFrI_TH = rdmds([exppath,'/results/DFrI_TH'],nIter);
% 
% 
% ADVr_SLT = rdmds([exppath,'/results/ADVr_SLT'],nIter);
% ADVx_SLT = rdmds([exppath,'/results/ADVx_SLT'],nIter);
% ADVy_SLT = rdmds([exppath,'/results/ADVy_SLT'],nIter);
% DFxE_SLT = rdmds([exppath,'/results/DFxE_SLT'],nIter);
% DFyE_SLT = rdmds([exppath,'/results/DFyE_SLT'],nIter);
% DFrI_SLT = rdmds([exppath,'/results/DFrI_SLT'],nIter);
% 
% 
% ADVr_TH_xavg = squeeze(mean(ADVr_TH));
% ADVx_TH_xavg = squeeze(mean(ADVx_TH));
% ADVy_TH_xavg = squeeze(mean(ADVy_TH));
% DFxE_TH_xavg = squeeze(mean(DFxE_TH));
% DFyE_TH_xavg = squeeze(mean(DFyE_TH));
% DFrI_TH_xavg = squeeze(mean(DFrI_TH));
% 
% ADVr_SLT_xavg = squeeze(mean(ADVr_SLT));
% ADVx_SLT_xavg = squeeze(mean(ADVx_SLT));
% ADVy_SLT_xavg = squeeze(mean(ADVy_SLT));
% DFxE_SLT_xavg = squeeze(mean(DFxE_SLT));
% DFyE_SLT_xavg = squeeze(mean(DFyE_SLT));
% DFrI_SLT_xavg = squeeze(mean(DFrI_SLT));
% % max(max(max(abs(DFrI_TH_xavg))))
% 
% figure(1)
% subplot(2,3,1)
% pcolor(ADVx_TH_xavg);shading interp;colorbar;caxis([-1e4 1e4])
% subplot(2,3,2)
% pcolor(ADVy_TH_xavg);shading interp;colorbar;caxis([-1e3 1e3])
% subplot(2,3,3)
% pcolor(ADVr_TH_xavg);shading interp;colorbar;caxis([-1e3 1e3])
% subplot(2,3,4)
% pcolor(DFxE_TH_xavg);shading interp;colorbar;caxis([-0.5 0.5])
% subplot(2,3,5)
% pcolor(DFyE_TH_xavg);shading interp;colorbar;caxis([-20 20])
% subplot(2,3,6)
% pcolor(DFrI_TH_xavg);shading interp;colorbar;caxis([-20 20])
% colormap(redblue);