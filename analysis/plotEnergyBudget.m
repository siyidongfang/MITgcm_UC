%%%
%%% plotEnergyBudget.m
%%%
%%% Makes plots of the energy budget.
%%%

clear;

addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/data/MITgcm_ASF-csi/products-hires';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
outdir = '/data/MITgcm_ASF-csi/cross_slope_exchange/figures_energy/'

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
imgname = 'figures_energy';

% fname = 'Dense shelf'
fname = 'Reference'

%%% Load experiment data
loadexp;
load([prodir '/' expname '_EnergyBudget_5yrs.mat']);


%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 13;
% framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];



[ZZ,YY] = meshgrid(zz,yy);
% handle = figure(14);
% set(handle,'Position',framepos);


figure(1)
clf;
set(gcf,'color','w');  
subplot(2,2,1)
% contourf(YY/1000,-ZZ/1000,log10(EKE_xavg),100,'EdgeColor','None');  
pcolor(YY/1000,-ZZ/1000,log10(EKE_xavg)); shading interp;axis ij;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);hold off;
xlabel('y (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
handle=colorbar;
set(handle,'FontSize',fontsize);
% set(gca,'Position',plotloc);
set(gca,'FontSize',fontsize);
colormap jet;
% caxis([-1 1]*5e-9);
% annotation('textbox',[0.6 0.04 0.45 0.05],'String','$\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^2$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('$\log_{10}(\mathrm{EKE})$ ($\mathrm{m}^2$/$\mathrm{s}^2$)','interpreter','latex','FontSize',fontsize+2);
text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex');

subplot(2,2,3)
% contourf(YY/1000,-ZZ/1000,PE_EKE_xavg,[-9e-5:1e-6:9e-5],'EdgeColor','None');  
pcolor(YY/1000,-ZZ/1000,PE_EKE_xavg); shading interp;axis ij;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);hold off;
xlabel('y (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
title ('$\mathrm{PE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
handle=colorbar;
set(handle,'FontSize',fontsize);
% set(gca,'Position',plotloc);
set(gca,'FontSize',fontsize);
colormap redblue;
caxis([-1 1]*1e-7);
% annotation('textbox',[0.6 0.04 0.45 0.05],'String','$\mathrm{PE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% saveas(gcf,[outdir '/' imgname '/' expname '_energy_PE2EKE.png']);
text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(2,2,4)
% contourf(YY/1000,-ZZ/1000,MKE_EKE_xavg,[-6e-7:1e-9:6e-7],'EdgeColor','None');  
pcolor(YY/1000,-ZZ/1000,MKE_EKE_xavg);   shading interp;axis ij;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);hold off;
xlabel('y (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
title ('$\mathrm{MKE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
handle=colorbar;
set(handle,'FontSize',fontsize);
% set(gca,'Position',plotloc);
set(gca,'FontSize',fontsize);
colormap redblue;
caxis([-5 5]*1e-8);
% annotation('textbox',[0.6 0.04 0.45 0.05],'String','$\mathrm{MKE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% saveas(gcf,[outdir '/' imgname '/' expname '_energy_MKE2EKE.png']);
text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


subplot(2,2,2)
pcolor(YY/1000,-ZZ/1000,PE_MKE_xavg);  shading interp;axis ij;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);hold off;
xlabel('y (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
title ('$\mathrm{PE}\to\mathrm{MKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
handle=colorbar;
set(handle,'FontSize',fontsize);
% set(gca,'Position',plotloc);
set(gca,'FontSize',fontsize);
colormap redblue;
caxis([-5 5]*1e-5);
% annotation('textbox',[0.6 0.04 0.45 0.05],'String','$\mathrm{PE}\to\mathrm{MKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% saveas(gcf,[outdir '/' imgname '/' expname '_energy_PE2MKE.png']);
text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')


print('-dpng','-r150',[outdir 'hires-' fname '.png']);
