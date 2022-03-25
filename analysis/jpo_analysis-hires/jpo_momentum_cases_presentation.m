%%%
%%% jpo_momentum_ref.m
%%%

clear all;close all;
addpath /data/MITgcm_ASF-csi/analysis
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
addpath ../jpo_analysis/
prodir = '/data/MITgcm_ASF-csi/products-hires/';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';

load('/data/MITgcm_ASF-csi/products-hires/sig12.mat')

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
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 950 1200]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 12;
boxcolor = [225 225 225]/255;
subplotsize = [0.43 0.2];

%%

%%% Make the plot
clf;
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis';
calcMomBudgetFromTendency_xint;
calcMomBudget_ice_xint;

yy_mid = 0.5*(yy(1:end-1)+yy(2:end));
%% 
ax1 = subplot('position',[0.065 0.77 subplotsize]);
annotation('textbox',[0.455 0.745 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

l1 = plot(yy/1000,windStress_xint/1e4,'--','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5,'Color',brown);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5,'Color',yellow);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5,'Color',purple);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5,'Color',green);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'Ref.','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
title('Ocean zonal force balance','FontSize',fontsize+2,'interpreter','latex');
ah=axes('position',get(ax1,'position'),'visible','off');
leg0 = legend(ah,l1,'Wind stress','FontSize', fontsize-1,'interpreter','latex');
leg1 = legend([l2 l5 l3 l4 l0],...
    'Ice-ocean stress',...
    'Ocean advection',...
    'Topog. form stress',...
    'Bottom friction',...
    'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
set(leg1,'position',[0.2732 0.8820 0.1996 0.0876])
set(leg0,'position',[0.2009    0.7942    0.2920    0.0686]);  legend boxoff;


ax2 = subplot('position',[0.56 0.77 subplotsize]);
annotation('textbox',[0.95 0.745 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5,'Color',brown);
hold on;
% l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5,'Color',blue);
l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
% l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'Ref.','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
int = 10;
Ny_int = floor(Ny/int)+1;
scale_sig12 = mean(abs(sig12_xavg(3,:)));
quiver(yy(1:int:end)/1000,(ydown-2)*ones(1,Ny_int),...
    sig12_xavg(3,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-.','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
leg2=legend([l1 l2 l4 l3],'Wind stress','Ocean-ice stress',...
    'Sea ice internal stress divergence','Coriolis force',...
    'interpreter','latex', 'FontSize', fontsize-1); %    'Residual terms'...
set(leg2,'position',[0.6775 0.882 0.3046 0.06])
xlim([20,420])
title('Sea ice zonal force balance','FontSize',fontsize+2,'interpreter','latex');




%%
expname = 'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis';
calcMomBudgetFromTendency_xint;
calcMomBudget_ice_xint;

ax1 = subplot('position',[0.065 0.53 subplotsize]);
annotation('textbox',[0.455 0.505 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

l1 = plot(yy/1000,windStress_xint/1e4,'--','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5,'Color',brown);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5,'Color',yellow);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5,'Color',purple);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5,'Color',green);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$A_{\mathrm{tide}}= 0$ m/s','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');

ax2 = subplot('position',[0.56 0.53 subplotsize]);
annotation('textbox',[0.95 0.505 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5,'Color',brown);
hold on;
% l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5,'Color',blue);
l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
% l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$A_{\mathrm{tide}}= 0$ m/s','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
quiver(yy(1:int:end)/1000,5*ones(1,Ny_int),...
    sig12_xavg(1,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-.','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,420])



%%
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis';
calcMomBudgetFromTendency_xint;
calcMomBudget_ice_xint;


ax1 = subplot('position',[0.065 0.29 subplotsize]);
annotation('textbox',[0.455 0.265 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

l1 = plot(yy/1000,windStress_xint/1e4,'--','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5,'Color',brown);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5,'Color',yellow);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5,'Color',purple);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5,'Color',green);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([375 375],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(225,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(280,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$W_s= 125$ km','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');

ax2 = subplot('position',[0.56 0.29 subplotsize]);
annotation('textbox',[0.95 0.265 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% l7 = plot(yy/1000,iceResidual/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5,'Color',brown);
hold on;
% l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5,'Color',blue);
l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
% l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([375 375],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(225,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
% text(280,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$W_s= 125$ km','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
quiver(yy(1:int:end)/1000,(ydown-2)*ones(1,Ny_int),...
    sig12_xavg(24,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-.','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,420])



%%
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis';
calcMomBudgetFromTendency_xint;
calcMomBudget_ice_xint;


ax1 = subplot('position',[0.065 0.05 subplotsize]);
annotation('textbox',[0.455 0.025 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

l1 = plot(yy/1000,windStress_xint/1e4,'--','LineWidth',1.5);
hold on;
l0 = plot(yy/1000,-totalchange_tendency/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,Um_Ext_xzint/1e4,'LineWidth',1.5,'Color',brown);
l3 = plot(yy/1000,Um_dPhiX_xzint/1e4,'LineWidth',1.5,'Color',yellow);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5,'Color',purple);
l5 = plot(yy/1000,Um_Advec_xzint/1e4,'LineWidth',1.5,'Color',green);
l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -15;
ydown = 15;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-13.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-13.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-13.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,13.5,'$\Delta \mathrm{S}=0.62$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
hold off;
set(gca,'fontsize',fontsize);
xlim([20,430])
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize+1,'interpreter','latex');


ax2 = subplot('position',[0.56 0.05 subplotsize]);
annotation('textbox',[0.95 0.025 0.05 0.05],'String','(h)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% l7 = plot(yy/1000,iceResidual/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',1.5,'Color',brown);
hold on;
% l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',1.5,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',1.5,'Color',blue);
l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
% l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',1.5,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = -8;
ydown = 7;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-7.2,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(132,-7.2,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,-7.2,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,6.2,'$\Delta \mathrm{S}=0.62$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
axis ij
quiver(yy(1:int:end)/1000,(ydown-2)*ones(1,Ny_int),...
    sig12_xavg(30,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-.','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,420])
xlabel('Offshore distance (km)', 'FontSize', fontsize+1,'interpreter','latex');

%% Write to file
print('-dpng','-r150','jpo_momentum_cases_pre.png');

