clear all;close all;

%%% Plotting options
fontsize = 12;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 900 850]);
set(gcf,'Color','w');

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

load('/data/MITgcm_ASF-csi/experiments/products/icedrift.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SCHEMATIC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

nws = [3 27 28];
ws = [25 75 125];

nva = [29 3 30];
va = [4 6 8];

nres = [3 31 32];
res = [2 5 10];


%%
panelsize = [0.36 0.18];

YLIM1 = [0 0.32];
YLIM2 = [0 1.7];

ax1 = subplot('position',[0.07 0.81 panelsize]);
annotation('textbox',[0.07 0.937 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'tide';
% yyaxis left
plot(Atide,-ui_slope(nAtide),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(Atide(2),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

% plot(Atide,vi_slope(nAtide),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
% yyaxis right
% plot(Atide,hi_slope(nAtide),'d-','Color',orange,'LineWidth',1.5)
% scatter(Atide(2),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
xlabel('$A_{\mathrm{tide}}$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

%%
ax2 = subplot('position',[0.57 0.81 panelsize]);
annotation('textbox',[0.57 0.937 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'ua';
% yyaxis left
plot(abs_ua,-ui_slope(nabs_ua),'o-','Color',blue,'LineWidth',1.5)
hold on
% plot(abs_ua,vi_slope(nabs_ua),'o--','Color',blue,'LineWidth',1.5)
scatter(abs_ua(2),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% plot(abs_ua,hi_slope(nabs_ua),'d-','Color',orange,'LineWidth',1.5)
% scatter(abs_ua(2),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$|u_a|$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');



%%
ax3 = subplot('position',[0.07 0.56 panelsize]);
group = 'va';
annotation('textbox',[0.07 0.69 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
% yyaxis left
plot(va,-ui_slope(nva),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(va(2),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

% plot(va,vi_slope(nva),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% plot(va,hi_slope(nva),'d-','Color',orange,'LineWidth',1.5)
% scatter(va(2),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$v_a$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

%%
ax4 = subplot('position',[0.57 0.56 panelsize]);
group = 'buoy';
annotation('textbox',[0.57 0.69 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
% yyaxis left
plot(buoy,-ui_slope(nbuoy),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(buoy(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(buoy,vi_slope(nbuoy),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
yticks([0:0.1:0.5])
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% plot(buoy,hi_slope(nbuoy),'d-','Color',orange,'LineWidth',1.5)
% scatter(buoy(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta$S (psu)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([min(buoy) max(buoy)])


%%
ax5 = subplot('position',[0.07 0.31 panelsize]);
group = 'ws';
annotation('textbox',[0.07 0.44 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
% yyaxis left
plot(ws,-ui_slope(nws),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(ws(1),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(ws,vi_slope(nws),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% plot(ws,hi_slope(nws),'d-','Color',orange,'LineWidth',1.5);
% scatter(ws(1),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% 
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$w_s$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([25 125]);

%%
ax6 = subplot('position',[0.57 0.31 panelsize]);
group = 'res';
annotation('textbox',[0.57 0.44 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
% yyaxis left
plot(res,-ui_slope(nres),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(res(1),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(res,vi_slope(nres),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% plot(res,hi_slope(nres),'d-','Color',orange,'LineWidth',1.5);
% scatter(res(1),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% 
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta x,\ \Delta y$ (km)', 'FontSize', fontsize+1,'interpreter','latex');




%%

ax7 = subplot('position',[0.07 0.06 panelsize]);
group = 'ice';
annotation('textbox',[0.07 0.19 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
% yyaxis left
ll2 = plot(hi0,-ui_slope(nhi0),'o-','Color',blue,'LineWidth',1.5);
hold on
ss1 = scatter(hi0(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(hi0,vi_slope(nhi0),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
% yyaxis right
% ll1 = plot(hi0,hi_slope(nhi0),'d-','Color',orange,'LineWidth',1.5);
% ss2 = scatter(hi0(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
% ylim(YLIM2);
% ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$h_{i0}$ (m)', 'FontSize', fontsize+1,'interpreter','latex');



%%
ah=axes('position',get(ax7,'position'),'visible','off');

legpos = [0.6478    0.1253    0.1800    0.0365];
% nlegend = {'$u_i$','$h_i$'};
% leghandle = legend(ah,[ll1, ll2],nlegend,'FontSize', fontsize,'interpreter','latex','orientation','horizontal');
nlegend = {'$u_i$'};
leghandle = legend(ah,[ll2],nlegend,'FontSize', fontsize,'interpreter','latex','orientation','horizontal');
set(leghandle,'FontSize',fontsize+2);
set(leghandle,'Position',legpos);
legend boxoff;


% legpos2 = [0.6478    0.06    0.1800    0.0365];
% leghandle2 = legend(ss1 ,'Reference simulation','FontSize', fontsize,'interpreter','latex','orientation','horizontal');
% legend boxoff;
% set(leghandle2,'FontSize',fontsize+2);
% set(leghandle2,'Position',legpos2);

%%
print('-dpng','-r150','jpo_icedrift_ui.png');




