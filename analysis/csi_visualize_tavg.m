%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/newexp/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/;
expdir = '/data/MITgcm_ASF-csi/experiments/';
outdir = '/data/MITgcm_ASF-csi/experiments/products/'
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});



loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'])

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 11;

position_1 = [222 575 524 284.5000];
position_2 = [563   282   820   306]*1.5;
position_topview = [401   259   537   546];

%%% For ice-ocean stress calculation
C_io = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
rho_o = 1027;                %%% Water density, kg/m^3
Rio = 0; %%% SEAICE_waterTurnAngle

fignum = 1;

loadexp;
% load([exppath '/' expname '_tavg_5yrs.mat']);


figure(1);
clf;
salt0=SALT;
BATHY = salt0;
idx_bathy = (BATHY==0);
salt0(idx_bathy) = NaN;
salt=squeeze(nanmean(salt0,1));
FIG = pcolor(yy/1000,-zz/1000,salt');shading interp;axis ij;
set(FIG,'alphadata',~isnan(salt'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(yy/1000,-zz/1000,salt',[33 34.5 34.55 34.6 34.65 34.66 34.67 34.68 34.69 34.7 34.75 34.8 34.85 34.9 34.95],'LineColor','w');
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('S (psu)','FontSize', fontsize+2,'interpreter','latex');
colormap(Colormap.haline);
% colormap(mycolormap);
h1=colorbar;
set(gca,'fontsize',fontsize);
% caxis([min(min(salt)) max(max(salt))+0.2
caxis([33.75 34.7])
% caxis([33.6 34.75]); % dense shelf
% freezeColors;cbfreeze(h1)
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[outdir imgname '/' expname '_S.png']);


figure(2);
theta0=THETA;
theta0(idx_bathy) = NaN;
theta=squeeze(nanmean(theta0,1));
FIG = pcolor(yy/1000,-zz/1000,theta');shading interp;axis ij;
set(FIG,'alphadata',~isnan(theta'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
% contour(yy/1000,-zz/1000,theta','LineColor','w');
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('T ($^\circ$C)','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
h2=colorbar;set(gca,'fontsize',fontsize);
 caxis([-2 2]);
% freezeColors;cbfreeze(h2)
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[outdir imgname '/' expname '_T.png']);


figure(3)
uvel=UVEL;
uvel(idx_bathy) = NaN;
aaa1=squeeze(nanmean(uvel,1));
FIG = pcolor(yy/1000,-zz/1000,aaa1');
box on
shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
% contour(aaa1','LineColor','w')
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('u (m/s)','FontSize', fontsize+3,'interpreter','latex');
colormap(mycolormap);
h3=colorbar;set(gca,'fontsize',fontsize);
caxis([-0.4 0.4]);
% caxis([-0.2 0.2]);
xlim([20 300]);
set(gca,'YTick',[0:1:4]);
PLOT = gcf;
PLOT.Position = [222 564 347 295.5000];

% saveas(gcf,[outdir imgname '/' expname '_U3.png']);

