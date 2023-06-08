%%%
%%% plot_heatbudget.m
%%%
%%% Plot the heat budget of the ocean
%%% (1) Vertical- and zonal-integrated heat budget for the whole column
%%% (2) Vertical- and zonal-integrated heat budget for the surface layer
%%% (2) Vertical- and zonal-integrated heat budget for the CDW layer




loadcolors





figure(1)
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1200 500]);
fontsize = 21;
subplotsize = [0.27 0.81];
set(gcf,'Color','w');
clf



ax1 = subplot('position',[0.05 0.125 subplotsize]);
ann1 = annotation('textbox',[0.005 0.95 0.05 0.05],'String','A','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod_new';
load([prodir expname '_heatbudget_xzint.mat'])
Ny = length(yy);
plot(yy/1000,zeros(1,length(yy)),':','LineWidth',1,'color','k')
hold on;
L1 = plot((yy(1:end-1)+yy(2:end))/2/1000,(TFLUX_int(1:end-1)+dADVdy-Ttend_int(1:end-1))/1e6...
    ,'Color',[0.9 0.9 0.9],'LineWidth',7);
L5 = plot(yy/1000,zeros(1,Ny),':','Color',darkgray,'LineWidth',2);
L3 = plot(yy/1000,TFLUX_int/1e6,'-','LineWidth',3.5,'Color',[0 0.4470 0.7410]);
L4 = plot((yy(1:end-1)+yy(2:end))/2/1000,dADVdy/1e6,'-','LineWidth',3.5,'Color',[0.4660 0.6740 0.1880]);
L2 = plot(yy/1000,Ttend_int/1e6,'--','LineWidth',2.5,'Color',[0.4940 0.1840 0.5560]);
yup = 8;
ydown = -8;
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
hold off;
set(gca,'FontSize',fontsize);
text(58,7.3,'Shelf','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(125,7.3,'Slope','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(260,7.3,'Deep ocean','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
ylabel('(10^6 W/m)','FontSize',fontsize-1)
xlabel('Latitude, y (km)','FontSize',fontsize)
xlim([50 427])
ylim([-8 8])
xticks([50 100 200 300 400])
title('Fresh shelf','FontSize',fontsize+2,'fontweight', 'normal')



ax2 = subplot('position',[0.39 0.125 subplotsize]);
ann2 = annotation('textbox',[0.345 0.95 0.05 0.05],'String','B','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
expname = 'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
load([prodir expname '_heatbudget_xzint.mat']);
Ny = length(yy);
plot(yy/1000,zeros(1,length(yy)),':','LineWidth',1,'color','k')
hold on;
L1 = plot((yy(1:end-1)+yy(2:end))/2/1000,(TFLUX_int(1:end-1)+dADVdy-Ttend_int(1:end-1))/1e6...
    ,'Color',[0.9 0.9 0.9],'LineWidth',7);
L5 = plot(yy/1000,zeros(1,Ny),':','Color',darkgray,'LineWidth',2);
L3 = plot(yy/1000,TFLUX_int/1e6,'-','LineWidth',3.5,'Color',[0 0.4470 0.7410]);
L4 = plot((yy(1:end-1)+yy(2:end))/2/1000,dADVdy/1e6,'-','LineWidth',3.5,'Color',[0.4660 0.6740 0.1880]);
L2 = plot(yy/1000,Ttend_int/1e6,'--','LineWidth',2.5,'Color',[0.4940 0.1840 0.5560]);
yup = 8;
ydown = -8;
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
hold off;
set(gca,'FontSize',fontsize);
text(58,7.3,'Shelf','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(125,7.3,'Slope','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(260,7.3,'Deep ocean','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
ylabel('(10^6 W/m)','FontSize',fontsize-1)
xlabel('Latitude, y (km)','FontSize',fontsize)
xlim([50 427])
ylim([-8 8])
xticks([50 100 200 300 400])
title('Reference','FontSize',fontsize+2,'fontweight', 'normal')
leg1=legend([L4,L3,L2,L1],...
    'Advective heat flux convergence',...  %%% When this curve is positive, ocean temperature increases due to advective heat flux convergence
    'Surface (ice-ocean) heat flux',... %%% When this curve is positive, ocean temperature increases due to ice-ocean heat flux
    'Heat content tendency',... %%% When this curve is positive, heat content increases
    'Residual term',...
    'FontSize', fontsize-2.5,'Position',[0.3967 0.6450 0.2583 0.1870]);



ax3 = subplot('position',[0.725 0.125 subplotsize]);
ann3 = annotation('textbox',[0.68 0.95 0.05 0.05],'String','C','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod_new';
load([prodir expname '_heatbudget_xzint.mat']);
Ny = length(yy);
plot(yy/1000,zeros(1,length(yy)),':','LineWidth',1,'color','k')
hold on;
L1 = plot((yy(1:end-1)+yy(2:end))/2/1000,(TFLUX_int(1:end-1)+dADVdy-Ttend_int(1:end-1))/1e6...
    ,'Color',[0.9 0.9 0.9],'LineWidth',7);
L5 = plot(yy/1000,zeros(1,Ny),':','Color',darkgray,'LineWidth',2);
L3 = plot(yy/1000,TFLUX_int/1e6,'-','LineWidth',3.5,'Color',[0 0.4470 0.7410]);
L4 = plot((yy(1:end-1)+yy(2:end))/2/1000,dADVdy/1e6,'-','LineWidth',3.5,'Color',[0.4660 0.6740 0.1880]);
L2 = plot(yy/1000,Ttend_int/1e6,'--','LineWidth',2.5,'Color',[0.4940 0.1840 0.5560]);
yup = 8;
ydown = -8;
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
hold off;
set(gca,'FontSize',fontsize);
text(58,7.3,'Shelf','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(125,7.3,'Slope','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
text(260,7.3,'Deep ocean','FontSize',fontsize-3,'Color',[0.5 0.5 0.5]);
ylabel('(10^6 W/m)','FontSize',fontsize-1)
xlabel('Latitude, y (km)','FontSize',fontsize)
xlim([50 427])
ylim([-8 8])
xticks([50 100 200 300 400])
title('Dense shelf','FontSize',fontsize+2,'fontweight', 'normal')


figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig_heatbudget';
figname = 'fig_heatbudget-ver1.png';

print('-dpng','-r300',[figdir figname]);
