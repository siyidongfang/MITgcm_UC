clear all;close all;

%%% Plotting options
fontsize = 13;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 650]);
set(gcf,'Color','w');

%%% colormap
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap
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
bluegrey = [83,138,177]/255;

blue = blue;


load('/Volumes/si/MITgcm_ASF-csi/products-hires/icedrift_ystart125km_new.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SCHEMATIC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


nAtide  = 1:5;
Atide = [0 0.025 0.05 0.075 0.1];
nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];
nhi0 = 14:19;
hi0  = [0.2 0.6 1 1.4 1.8 2.2];
nws = 20:24;
ws = [25 50 75 100 125];
Ys = [150 175 200 225 250];
nbuoy = 25:30;
% buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 
buoy = [-1.076 -0.620 -0.207 0.000 0.204 0.409];
nres = [31:34];
res = [1 2 5 10];

%%
% panelsize = [0.36 0.18];
panelsize = [0.24 0.252];



YLIM1 = [0 0.4];
YLIM2 = [1 1.33];

ax1 = subplot('position',[0.05 0.74 panelsize]);
annotation('textbox',[0.05 0.947 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'tide';
yyaxis left
plot(Atide,-ui_slope(nAtide),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(Atide(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

% plot(Atide,vi_slope(nAtide),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex','Color',blue);
yyaxis right
plot(Atide,hi_slope(nAtide),'d-','Color',orange,'LineWidth',1.5)
scatter(Atide(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
hold off
ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$A_{\mathrm{tide}}$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax2 = subplot('position',[0.38 0.74 panelsize]);
annotation('textbox',[0.38 0.947 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');

group = 'buoy';
yyaxis left
plot(buoy,-ui_slope(nbuoy),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(buoy(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(buoy,vi_slope(nbuoy),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
yticks([0:0.1:0.5])
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(buoy,hi_slope(nbuoy),'d-','Color',orange,'LineWidth',1.5)
scatter(buoy(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta\sigma_4\ (\mathrm{kg\ m^{-3}})$', 'FontSize', fontsize+1,'interpreter','latex');
xlim([min(buoy) max(buoy)])
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax3 = subplot('position',[0.05 0.405 panelsize]);
annotation('textbox',[0.05 0.612 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');

group = 'ua';
yyaxis left
plot(abs_ua,-ui_slope(nabs_ua),'o-','Color',blue,'LineWidth',1.5)
hold on
% plot(abs_ua,vi_slope(nabs_ua),'o--','Color',blue,'LineWidth',1.5)
scatter(abs_ua(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(abs_ua,hi_slope(nabs_ua),'d-','Color',orange,'LineWidth',1.5)
scatter(abs_ua(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);

ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$|u_a|$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;

%%
ax4 = subplot('position',[0.38 0.405 panelsize]);
annotation('textbox',[0.38 0.612 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'va';

yyaxis left
plot(va,-ui_slope(nva),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(va(2),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);

% plot(va,vi_slope(nva),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(va,hi_slope(nva),'d-','Color',orange,'LineWidth',1.5)
scatter(va(2),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$v_a$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');


ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;



%%
ax5 = subplot('position',[0.05 0.07 panelsize]);
group = 'ws';
annotation('textbox',[0.05 0.277 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(ws,-ui_slope(nws),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(ws(1),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(ws,vi_slope(nws),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(ws,hi_slope(nws),'d-','Color',orange,'LineWidth',1.5);
scatter(ws(1),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);

ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$w_s$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([25 125]);
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax6 = subplot('position',[0.38 0.07 panelsize]);
group = 'res';
annotation('textbox',[0.38 0.277 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(res,-ui_slope(nres),'o-','Color',blue,'LineWidth',1.5)
hold on
scatter(res(1),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(res,vi_slope(nres),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(res,hi_slope(nres),'d-','Color',orange,'LineWidth',1.5);
scatter(res(1),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);

ylim(YLIM2);yticks([1:0.1:1.3]);
ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta x,\ \Delta y$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([1 10])

ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;

%%

ax7 = subplot('position',[0.71 0.27 0.24 0.5885*1.0889]);
group = 'ice';
annotation('textbox',[0.71 0.865 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
ll2 = plot(hi0,-ui_slope(nhi0),'o-','Color',blue,'LineWidth',1.5);
hold on
ss1 = scatter(hi0(3),-ui_slope(3),'filled','o','MarkerFaceColor',[0 0 0]);
% plot(hi0,vi_slope(nhi0),'o--','Color',blue,'LineWidth',1.5)
ylim([-0.32 0.65]*4/3.75+0.12);
yticks([0 0.1 0.2 0.3 0.4])

ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
ll1 = plot(hi0,hi_slope(nhi0),'d-','Color',orange,'LineWidth',1.5);
ss2 = scatter(hi0(3),hi_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim([0.2 2.3]);
yticks([0.2 0.6 1.0 1.4 1.8 2.2])

ylabel('(m)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$h_{i0}$ (m)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([0.2 2.2])
xticks([0.2 0.6 1.0 1.4 1.8 2.2])
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;

%%
ah=axes('position',get(ax7,'position'),'visible','off');

legpos = [0.75    0.1253    0.1800    0.0365];
nlegend = {'$|\langle \overline{u_\mathrm{i}} \rangle|$','$\big\langle \overline{h_\mathrm{i}} \big\rangle$'};
leghandle = legend(ah,[ll2, ll1],nlegend,'FontSize', fontsize,'interpreter','latex','orientation','horizontal');
set(leghandle,'FontSize',fontsize+2);
set(leghandle,'Position',legpos);
legend boxoff;

set(gcf,'InnerPosition',[44 173 916 522])

% legpos2 = [0.6478    0.06    0.1800    0.0365];
% leghandle2 = legend(ss1 ,'Reference simulation','FontSize', fontsize,'interpreter','latex','orientation','horizontal');
% legend boxoff;
% set(leghandle2,'FontSize',fontsize+2);
% set(leghandle2,'Position',legpos2);

%%
print('-dpng','-r200','jpo_icedrift.png');




