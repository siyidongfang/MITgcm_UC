clear all;close all;

%%% Plotting options
fontsize = 12;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 650]);
set(gcf,'Color','w');
legpos = [0.4 0.01 0.2 0.03];

%%% colormap
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
% orange = [230 45 34]/255;
yellow = [0.9290 0.6940 0.1250];
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
gray2 = [249 249 249]/255;

expdir = '/home/csi/MITgcm_ASF-experiments';
prodir = '/data/MITgcm_ASF-csi/experiments/products/';

load([prodir '/calcFeddy_batch.mat'])


expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
loadexp;

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

nbuoy  = 1:7;
buoy = [33 33.59 34.17 34.38 34.59 34.69 34.79]-34.17; 
% Salinity differences (at z=-500m) between the continental shelf and the open ocean

nAtide  = [10 3 11 12];
Atide = [0 0.05 0.075 0.1];
%         Atide = [0 0.025 0.05 0.075 0.1 0.125];

nhi0 = [8 9 3];
hi0  = [0.2 0.6 1];
%         hi0  = [0.2 0.6 1 1.4 1.8 2.2];

nabs_ua = [13 3 14];
abs_ua = [4 6 8];

nws = [3 17 18];
ws = [25 75 125];

nva = [15 3 16];
va = [4 6 8];

nres = [3 19 20];
res = [2 5 10];


%%
panelsize = [0.24 0.255];


% YLIM1 = [-0.5 0.9]*100;
YLIM1 = [-30 30]
% YLIM2 = [-0.25 0.07]*100;
YLIM2 = [-30 3 ]

ax1 = subplot('position',[0.05 0.73 panelsize]);
annotation('textbox',[0.05 0.937 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'tide';
yyaxis left
plot(Atide,-uw_std_eddy_shelf(nAtide),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(Atide,fs_std_eddy_shelf(nAtide),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex','Color',blue);
yyaxis right
plot(Atide,-uw_tran_eddy_shelf(nAtide),'d--','Color',orange,'LineWidth',1.5)
plot(Atide,fs_tran_eddy_shelf(nAtide),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$A_{\mathrm{tide}}$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

%%
ax2 = subplot('position',[0.38 0.73 panelsize]);
annotation('textbox',[0.38 0.937 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'ua';
yyaxis left
plot(abs_ua,-uw_std_eddy_shelf(nabs_ua),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(abs_ua,fs_std_eddy_shelf(nabs_ua),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(abs_ua,-uw_tran_eddy_shelf(nabs_ua),'d--','Color',orange,'LineWidth',1.5)
plot(abs_ua,fs_tran_eddy_shelf(nabs_ua),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$|u_a|$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');



%%
ax3 = subplot('position',[0.05 0.395 panelsize]);
group = 'va';
annotation('textbox',[0.05 0.602 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(va,-uw_std_eddy_shelf(nva),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(va,fs_std_eddy_shelf(nva),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(va,-uw_tran_eddy_shelf(nva),'d--','Color',orange,'LineWidth',1.5)
plot(va,fs_tran_eddy_shelf(nva),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$v_a$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

%%

ax4 = subplot('position',[0.38 0.395 panelsize]);
group = 'ice';
annotation('textbox',[0.38 0.602 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(hi0,-uw_std_eddy_shelf(nhi0),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(hi0,fs_std_eddy_shelf(nhi0),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(hi0,-uw_tran_eddy_shelf(nhi0),'d--','Color',orange,'LineWidth',1.5)
plot(hi0,fs_tran_eddy_shelf(nhi0),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$h_i$ (m)', 'FontSize', fontsize+1,'interpreter','latex');



%%
ax5 = subplot('position',[0.05 0.06 panelsize]);
group = 'ws';
annotation('textbox',[0.05 0.267 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(ws,-uw_std_eddy_shelf(nws),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(ws,fs_std_eddy_shelf(nws),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(ws,-uw_tran_eddy_shelf(nws),'d--','Color',orange,'LineWidth',1.5)
plot(ws,fs_tran_eddy_shelf(nws),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$w_s$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([25 125]);

%%
ax6 = subplot('position',[0.38 0.06 panelsize]);
group = 'res';
annotation('textbox',[0.38 0.267 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(res,-uw_std_eddy_shelf(nres),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(res,fs_std_eddy_shelf(nres),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(res,-uw_tran_eddy_shelf(nres),'d--','Color',orange,'LineWidth',1.5)
plot(res,fs_tran_eddy_shelf(nres),'d-','Color',orange,'LineWidth',1.5)
% ylim(YLIM2);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta x,\ \Delta y$ (km)', 'FontSize', fontsize+1,'interpreter','latex');

%%


ax7 = subplot('position',[0.71 0.395 panelsize(1) panelsize(2)]);
group = 'buoy';
annotation('textbox',[0.71 0.602 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(buoy,-uw_std_eddy_shelf(nbuoy),'o--','Color',blue,'LineWidth',1.5)
hold on
plot(buoy,fs_std_eddy_shelf(nbuoy),'o-','Color',blue,'LineWidth',1.5)
% ylim(YLIM1);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(buoy,-uw_tran_eddy_shelf(nbuoy),'d--','Color',orange,'LineWidth',1.5)
plot(buoy,fs_tran_eddy_shelf(nbuoy),'d-','Color',orange,'LineWidth',1.5)
% ylim([-0.3 0.3]);
ylabel('(m$^2$/s$^2$)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta$S (psu)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([min(buoy) max(buoy)])


%%
legpos = [0.75 0.01 0.18 0.3];
% nlegend = {'$\overline{w^{\prime}u^{\prime}}$',...
%     '$-f_0\overline{v^{\prime}b^{\prime}}/\overline{b_z}$ ',...
%     '$\overline{u^{\prime}v^{\prime}}$'};
nlegend = {'$-\bigg[w^{\star}u^{\star}\bigg]$',...
    '$+\bigg[f(\beta v^{\star}S^{\star} -\alpha v^{\star}\theta^{\star}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$',...
    '$-\bigg[\overline{w^{\prime}u^{\prime}}\bigg]$',...
    '$+\bigg[f(\beta\overline{v^{\prime}S^{\prime}} -\alpha\overline{v^{\prime}\theta^{\prime}}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$'};
leghandle = legend(nlegend,'FontSize', fontsize,'interpreter','latex','orientation','vertical');
legend boxoff;
set(leghandle,'FontSize',fontsize);
set(leghandle,'Position',legpos);

%%
% print('-dpng','-r150','plotFeddy_shelf.png');




