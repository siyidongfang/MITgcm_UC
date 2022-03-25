

clear;close all;
addpath ..;
addpath ../colormaps;
addpath ../colormaps/customcolormap;
addpath ../jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';


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
ncolor = 40;
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'},ncolor);


%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1050 1050]);
% set(gcf,'Position',[84 54 434 651])
set(gcf,'Color','w');

%%% Plotting options
fontsize = 15;
boxcolor = [225 225 225]/255;
% subplotsize = [0.88 0.27];
subplotsize = [0.41 0.27];

%%% Make the plot
clf;

ncolor = 40;
%%
expname = 'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
% %%%%%%
load([prodir expname '_KE_3650days_xzavg.mat'],...
    'KEuv_xzavg','TKEuv_xzavg','EKEuv_xzavg','MKEuv_xzavg','EKEuv_xavg')

%%%%%%
ax2 = subplot('position',[0.05 0.38 subplotsize]);
annotation('textbox',[0.01 0.62 0.05 0.05],'String','b','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

% ax1 = subplot('position',[0.1 0.7 subplotsize]);
% annotation('textbox',[0.01 0.95 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
ltot = plot(yy/1000,log10(KEuv_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKEuv_xzavg),'-.','Color',orange,'LineWidth',2.5);
lmean = plot(yy/1000,log10(MKEuv_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKEuv_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6.5;
ydown = -2;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-2.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-2.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-2.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(25,-6.2,'Ref.','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1);
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total KE','Tidal KE','Eddy KE','Mean KE',...
    'FontSize', fontsize); 
set(leg3,'position',[0.352 0.532 0.1000 0.08])
xlim([20 430])
set(gca,'XTick',[100 200 300 400])
set(gca, 'YGrid', 'on', 'XGrid', 'off')


ax5 = subplot('position',[0.53 0.38 subplotsize]);
annotation('textbox',[0.495 0.62 0.05 0.05],'String','e','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
pcolor(yy/1000,-zz/1000,EKEuv_xavg');shading interp;
colormap(cmocean('tempo',ncolor));
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(yy/1000,-zz/1000,EKEuv_xavg',[0:1:10]/1000,'EdgeColor','w','LineWidth',0.7);
text(25,3.75,'Ref.','FontSize',fontsize+1,'Color',[0 0 0]);

ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
caxis([0 6]/1000)



%%

%%%%%%
expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
% %%%%%%
load([prodir expname '_KE_3650days_xzavg.mat'],...
    'KEuv_xzavg','TKEuv_xzavg','EKEuv_xzavg','MKEuv_xzavg','EKEuv_xavg')

%%%%%%
ax1 = subplot('position',[0.05 0.7 subplotsize]);
annotation('textbox',[0.01 0.94 0.05 0.05],'String','a','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,log10(KEuv_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKEuv_xzavg),'-.','Color',orange,'LineWidth',2.5);
lmean = plot(yy/1000,log10(MKEuv_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKEuv_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6.5;
ydown = -2;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-2.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-2.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-2.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =-1.076\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0]);
text(25,-6.2,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
title('Decomposition of total kinetic energy','FontSize',fontsize+2,'fontweight', 'normal');
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
set(gca,'XTick',[100 200 300 400])

xlim([20 430])
set(gca, 'YGrid', 'on', 'XGrid', 'off')


ax4 = subplot('position',[0.53 0.7 subplotsize]);
annotation('textbox',[0.495 0.94 0.05 0.05],'String','d','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
pcolor(yy/1000,-zz/1000,EKEuv_xavg');shading interp;
colormap(cmocean('tempo',ncolor));
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(yy/1000,-zz/1000,EKEuv_xavg',[0:1:10]/1000,'EdgeColor','w','LineWidth',0.7);

text(25,3.75,'Fresh shelf','FontSize',fontsize+1,'Color',[0 0 0]);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
title('Eddy kinetic energy','FontSize',fontsize+2,'fontweight', 'normal');
colormap(mycolormap);
caxis([0 6]/1000)


%%

%%%%%%
expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;
% %%%%%%
load([prodir expname '_KE_3650days_xzavg.mat'],...
    'KEuv_xzavg','TKEuv_xzavg','EKEuv_xzavg','MKEuv_xzavg','EKEuv_xavg')

%%%%%%
ax3 = subplot('position',[0.05 0.06 subplotsize]);
annotation('textbox',[0.01 0.3 0.05 0.05],'String','c','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

ltot = plot(yy/1000,log10(KEuv_xzavg),'Color',green,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,log10(EKEuv_xzavg),'-.','Color',orange,'LineWidth',2.5);
lmean = plot(yy/1000,log10(MKEuv_xzavg),'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,log10(TKEuv_xzavg),'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
yup = -6.5;
ydown = -2;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,-2.3,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(133,-2.3,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
text(260,-2.3,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5]);
% text(25,-3.4,'$\Delta \sigma_4 =0.409\ \mathrm{kg\ m^{-3}}$','FontSize',fontsize+1,'Color',[0 0 0]);
text(25,-6.2,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);
hold off;
set(gca,'fontsize',fontsize);
ylabel('(log_{10} m^2/s^2)', 'FontSize', fontsize);
xlim([20 430])
set(gca,'XTick',[100 200 300 400])
xlabel('y (km)', 'FontSize', fontsize+1);
set(gca, 'YGrid', 'on', 'XGrid', 'off')


ax6 = subplot('position',[0.53 0.06 subplotsize]);
annotation('textbox',[0.495 0.3 0.05 0.05],'String','f','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
pcolor(yy/1000,-zz/1000,EKEuv_xavg');shading interp;
colormap(cmocean('tempo',ncolor));
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
[C,h]=contour(yy/1000,-zz/1000,EKEuv_xavg',[0:1:10]/1000,'EdgeColor','w','LineWidth',0.7);

ylabel('Depth (km)','FontSize',fontsize);
set(gca,'YDir','reverse');
set(gca,'fontsize',fontsize);
xlim([20 430]) 
ylim([0 4]) 
caxis([0 6]/1000)
text(25,3.75,'Dense shelf','FontSize',fontsize+1,'Color',[0 0 0]);

set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:400]);
xlabel('y (km)', 'FontSize', fontsize+1);

handle=colorbar;set(handle,'position',[0.955 0.25 0.007 0.53])
annotation('textbox',[0.945 0.785 0.15 0.05],'String','(m^2/s^2)','FontSize',fontsize,'LineStyle','None');


%% Write to file
print('-djpeg','-r300',[figdir 'KE_decomposition.jpeg']);
