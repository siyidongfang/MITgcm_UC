%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/newexp/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/;
expdir = '/home/csi/MITgcm_ASF-experiments';
outdir = '/data/MITgcm_ASF-csi/experiments/products/'
imgname = 'JPO2020_figures'

EXPNAME = char( ...
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25',...  
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',...  
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10',...   
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5',... 
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
  'den02uniformS_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws2',... 
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  ...
  'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
  );

ne = 1
expname = strtrim(EXPNAME(ne,:))
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'])

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});



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

for ne = 1:1
expname = strtrim(EXPNAME(ne,:))
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat']);




idx_bathy = (SALT==0);
figure(1)

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
PLOT.Position = position_1;
% PLOT.Position = [222 575 257 321];

% saveas(gcf,[outdir imgname '/' expname '_U3.png']);


end
