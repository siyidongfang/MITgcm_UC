clear all;close all;

%%% Plotting options
fontsize = 13;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 650]);
set(gcf,'Color','w');
legpos = [0.4 0.01 0.2 0.03];

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
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;
gold = [255 215 0]/255;
bluegrey = [100,150,185]/255;

blue = blue;
expdir = '/Users/csi/MITgcm_ASF-csi/experiments';

load('/Volumes/si/MITgcm_ASF-csi/products-hires/alongslopcirc_ystart125km_new2.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SCHEMATIC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';

loadexp;

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);



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
panelsize = [0.24 0.255];

YLIM1 = [0 0.7];
YLIM2 = [0 0.55];

ax1 = subplot('position',[0.05 0.74 panelsize]);
annotation('textbox',[0.05 0.947 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'tide';
yyaxis left
plot(Atide,umax(nAtide),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
plot(Atide,ubotmax(nAtide),'o--','Color',blue,'LineWidth',1.5)
scatter(Atide(3),umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(Atide(3),ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
ylim(YLIM1);yticks([0:0.2:0.6]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex','Color',blue);
yyaxis right
plot(Atide,Tbt_slope(nAtide),'d--','Color',orange,'LineWidth',1.5)
plot(Atide,Tbc_slope(nAtide),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)
scatter(Atide(3),Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(Atide(3),Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim(YLIM2);yticks([0:0.2:0.4])
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex','Color',orange);
hold off
xlabel('$A_{\mathrm{tide}}$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');

ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax2 = subplot('position',[0.38 0.74 panelsize]);
annotation('textbox',[0.38 0.947 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');

group = 'ice';
yyaxis left
plot(hi0,umax(nhi0),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
plot(hi0,ubotmax(nhi0),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);yticks([0:0.2:0.6]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
scatter(hi0(3),umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(hi0(3),ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
yyaxis right
plot(hi0,Tbt_slope(nhi0),'d--','Color',orange,'LineWidth',1.5)
plot(hi0,Tbc_slope(nhi0),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)

scatter(hi0(3),Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(hi0(3),Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim(YLIM2);yticks([0:0.2:0.4])
xlim([0.2 2.2])
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$h_{i0}$ (m)', 'FontSize', fontsize+1,'interpreter','latex');


ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;




%%
ax3 = subplot('position',[0.05 0.405 panelsize]);
annotation('textbox',[0.05 0.612 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'ua';
yyaxis left
plot(abs_ua,umax(nabs_ua),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
plot(abs_ua,ubotmax(nabs_ua),'o--','Color',blue,'LineWidth',1.5)
scatter(abs_ua(3),umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(abs_ua(3),ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
ylim(YLIM1);
yticks([0:0.2:0.6]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(abs_ua,Tbt_slope(nabs_ua),'d--','Color',orange,'LineWidth',1.5)
plot(abs_ua,Tbc_slope(nabs_ua),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)
ylim(YLIM2);yticks([0:0.2:0.4])

scatter(abs_ua(3),Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(abs_ua(3),Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$|U_{a0}|$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');




ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%

ax4 = subplot('position',[0.38 0.405 panelsize]);
annotation('textbox',[0.38 0.612 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
group = 'va';
yyaxis left
plot(va,umax(nva),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
scatter(6,umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(6,ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
plot(va,ubotmax(nva),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
yticks([0:0.2:0.6]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(va,Tbt_slope(nva),'d--','Color',orange,'LineWidth',1.5)
plot(va,Tbc_slope(nva),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)
ylim(YLIM2);yticks([0:0.2:0.4])
scatter(6,Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(6,Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$V_{a0}$ (m/s)', 'FontSize', fontsize+1,'interpreter','latex');
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax5 = subplot('position',[0.05 0.07 panelsize]);
group = 'ws';
annotation('textbox',[0.05 0.277 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(ws,umax(nws),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
plot(ws,ubotmax(nws),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);yticks([0:0.2:0.6])
scatter(25,umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(25,ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(ws,Tbt_slope(nws),'d--','Color',orange,'LineWidth',1.5)
plot(ws,Tbc_slope(nws),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)
ylim(YLIM2);yticks([0:0.2:0.4])
scatter(25,Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(25,Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$W_s$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([25 125]);
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
ax6 = subplot('position',[0.38 0.07 panelsize]);
group = 'res';
annotation('textbox',[0.38 0.277 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
plot(res,umax(nres),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5)
hold on
plot(res,ubotmax(nres),'o--','Color',blue,'LineWidth',1.5)
ylim(YLIM1);
yticks([0:0.2:0.6])
scatter(1,umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(1,ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
plot(res,Tbt_slope(nres),'d--','Color',orange,'LineWidth',1.5)
plot(res,Tbc_slope(nres),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5)
scatter(1,Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(1,Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim(YLIM2);yticks([0:0.2:0.4])
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta_x,\ \Delta_y$ (km)', 'FontSize', fontsize+1,'interpreter','latex');
xlim([1 10])
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;

%%


ax7 = subplot('position',[0.71 0.27 0.24 0.5885*1.0889]);
group = 'buoy';
annotation('textbox',[0.71 0.865 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
yyaxis left
l1 = plot(buoy,umax(nbuoy),'o-','Color',blue,'MarkerFaceColor',blue,'LineWidth',1.5);
hold on
l2 = plot(buoy,ubotmax(nbuoy),'o--','Color',blue,'LineWidth',1.5);
scatter(buoy(3),umax(3),'filled','o','MarkerFaceColor',[0 0 0]);
scatter(buoy(3),ubotmax(3),'filled','o','MarkerFaceColor',[0 0 0]);
ylim([-0.55 0.7563]*1.2368*1.0889+0.37);
yticks([0:0.2:0.6])
ylabel('(m/s)','FontSize', fontsize-1,'interpreter','latex');
yyaxis right
l3 = plot(buoy,Tbt_slope(nbuoy),'d--','Color',orange,'LineWidth',1.5);
l4 = plot(buoy,Tbc_slope(nbuoy),'d-','Color',orange,'MarkerFaceColor',orange,'LineWidth',1.5);
scatter(buoy(3),Tbt_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
scatter(buoy(3),Tbc_slope(3),'filled','d','MarkerFaceColor',[0 0 0]);
ylim([-0.6 0.8]);
ylabel('(Sv/km)','FontSize', fontsize-1,'interpreter','latex');
hold off
xlabel('$\Delta\sigma_4\ (\mathrm{kg\ m^{-3}})$', 'FontSize', fontsize+1,'interpreter','latex');
xlim([min(buoy) max(buoy)])
ax = gca;
ax.YAxis(1).Color = blue;
ax.YAxis(2).Color = orange;
%%
legpos = [0.74 0.1 0.18 0.03];
nlegend = {'$|\overline{u_\mathrm{o}}|_{\mathrm{max}}$','$|\overline{u_\mathrm{o}^\mathrm{bot}}|_{\mathrm{max}}$','$T_\mathrm{BT}$','$T_\mathrm{BC}$'};
leghandle = legend([l1 l2 l3 l4],nlegend,'FontSize', fontsize,'interpreter','latex','orientation','horizontal');
legend boxoff;
set(leghandle,'FontSize',fontsize);
set(leghandle,'Position',legpos);


set(gcf,'InnerPosition',[44 173 916 522])


%%
print('-dpng','-r200','jpo_circ_lines.png');




