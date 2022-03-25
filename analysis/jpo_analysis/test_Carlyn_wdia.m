%%%
%%% plotAtmIceOcean.m
%%%
%%% Creates plots of winds, ice drift and SSH for a presentation at AGU
%%% 2018.
%%%

clear all;close all;

addpath /home/csi/research/code;
addpath /home/csi/research/CATS2008/TMD;
addpath /home/csi/research/CATS2008/TMD/DATA;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1000 1000]);
set(gcf,'Color','w');


%%% Plotting options
fontsize = 12;
framepos = [45           1        700         600];
cbpos = [0.85 0.06 0.01 0.16];
legpos = [0.4 0.01 0.2 0.03];
linewidth = 1.5;
latMin = -90;
latMax = -55;
lonMin = 0;
lonMax = 360;
boxcolor = [225 225 225]/255;


topog = ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','HGT');
lat_topog = double(ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','g5_lat_0'));
lon_topog = double(ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','g5_lon_1'));
topog(topog==0)=NaN;
topog(~isnan(topog))=0;
%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%% WIND FIGURE %%%%%
%%%%%%%%%%%%%%%%%%%%%%%

%%% Load data
load /home/csi/research/PolarWRF/AMPS_winds.mat
load /home/csi/research/etopo1/AntarcticCoastline.mat
% months = [1 2 3 4 5 6 7 8 9 10 11 12];
months = [6 7 8];
% months=[7];
zonal_winds_AMPS = nanmean(zonal_winds_AMPS(:,:,months,2:end-1),4);
merid_winds_AMPS = nanmean(merid_winds_AMPS(:,:,months,2:end-1),4);
zonal_winds_AMPS = squeeze(nanmean(zonal_winds_AMPS,3));
merid_winds_AMPS = squeeze(nanmean(merid_winds_AMPS,3));
[LA,LO] = meshgrid(ERA_lat,ERA_lon);
load coastlines
worldmap('antarctica')
antarctica = shaperead('landareas', 'UseGeoCoords', true,...
  'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});

%% Make the plot
clf;
ax1 = subplot('position',[0.01 0.5 0.45 0.45]);
annotation('textbox',[0.01 0.915 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
set(gca,'Color','w')
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
set(gca,'FontSize',fontsize);
setm(gca,'MLabelParallel','north') 
setm(gca,'PLabelLocation',[-80:10:-60]);
setm(gca,'PLineLocation',[-85:5:-60]);
setm(gca,'MLineLocation',[-180:30:180]);
setm(gca,'MLabelLocation',[-180:30:180]);
pcolorm(double(LA),double(LO),double(zonal_winds_AMPS'));        
shading interp;
% colormap(ax1,cmocean('balance',100));
colormap(ax1,cmocean_balance_0);
caxis([-10 10])
hold on
bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
% contourm(lat_topog,lon_topog,topog,[1 1]);
pcolor2 = pcolorm(lat_topog,lon_topog,topog);
% colormap(pcolor2,'gray');
%caxis([0 max(max(topog))]);
% coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
% patchm(antarctica.Lat, antarctica.Lon, [245 240 240]/255)
hold off;

handle = title({'Winter zonal wind speed (m/s)'},'FontSize',fontsize+3,'interpreter','latex'); % '2007-2014' 'Antarctic Mesoscale Prediction System'
set(handle,'Position',[0 0.75 0]);

%%% Add colorbar
handle = colorbar;
set(handle,'Position',[0.45 0.67 0.01 0.16]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Tidal Current Amplitude  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf

load /home/csi/research/etopo1/AntarcticCoastline.mat
load('/home/csi/research/CATS2008/TidalAmplitude.mat','lon','lat','meanspeed_tide')
meanspeed_tide(1:100,:) = -meanspeed_tide(1:100,:);
w_dia = meanspeed_tide;
xx =1:size(w_dia,1);
yy =1:size(w_dia,2);

[YY,XX] = meshgrid(yy,xx);

Negative = double(w_dia<0);
[Negative_x,Negative_y] = find(Negative == 1);
w_dia_log = log10(abs(w_dia));


figure(2)
pcolor(XX,YY,w_dia_log)
colormap(jet);colorbar;caxis([-1 2])
shading interp;
hold on;
interval = 2;
scatter1 = scatter(Negative_x(1:interval:end),Negative_y(1:interval:end),'.','LineWidth',0.1);
scatter1.MarkerFaceAlpha = .2;
scatter1.MarkerEdgeAlpha = .2;
hold off;
%%
ax2 = subplot('position',[0.5 0.5 0.45 0.45]);
annotation('textbox',[0.5 0.915 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
set(gca,'Color','w')
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel','north') 
setm(gca,'PLabelLocation',[-80:10:-60]);
setm(gca,'PLineLocation',[-85:5:-60]);
setm(gca,'MLineLocation',[-180:30:180]);
setm(gca,'MLabelLocation',[-180:30:180]);
pcolorm(lat,lon,meanspeed_tide);        
shading interp;
hold on;
bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
% coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
% patchm(antarctica.Lat, antarctica.Lon, [245 240 240]/255)
hold off;
colormap(ax2,WhiteBlueGreenYellowRed(0));
caxis([-1 2])
% caxis([0 100])
set(gca,'ColorScale','linear')
set(gca,'FontSize',fontsize);
handle = title({'Mean tidal current speed (cm/s)'},'FontSize',fontsize+3,'interpreter','latex');
set(handle,'Position',[0 0.75 0]);

%%% Add colorbar
handle = colorbar('XTickLabel',{'0.1','0.3','1.0','3.2','10','32','100'}, ...
               'XTick', -1:0.5:2);
set(handle,'Position',[0.94 0.67 0.01 0.16]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ICE DRIFT FIGURE %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data
load /home/csi/research/etopo1/AntarcticCoastline.mat
load /home/csi/research/NSIDC_icemotion/IceDriftClim_JJA.mat
dlon_dchi = 0*LO;
dlon_dchi(2:end-1,:) = (LO(3:end,:)-LO(1:end-2,:)) / d;
dlon_dchi([1 end],:) = dlon_dchi([2 end-1],:);
dlon_dxi = 0*LO;
dlon_dxi(:,2:end-1) = (LO(:,3:end)-LO(:,1:end-2)) / d;
dlon_dxi(:,[1 end]) = dlon_dchi(:,[2 end-1]);
grad_lon = sqrt(dlon_dchi.^2 + dlon_dxi.^2);
cosalpha = dlon_dchi ./ grad_lon;
sinalpha = dlon_dxi ./ grad_lon;
u_zonal = u_avg .* cosalpha + v_avg .* sinalpha;

%%% Plotting options
lonMin = -180;
lonMax = 180;


%%% Make the plot

ax3 = subplot('position',[0.01 0.03 0.45 0.45]);
annotation('textbox',[0.01 0.445 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
set(gca,'Color','w')
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel','north') 
setm(gca,'PLabelLocation',[-80:10:-60]);
setm(gca,'PLineLocation',[-85:5:-60]);
setm(gca,'MLineLocation',[-180:30:180]);
setm(gca,'MLabelLocation',[-180:30:180]);
pcolorm(double(LA),double(LO),double(u_zonal/10));        
shading interp;
hold on;
bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
% coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
% patchm(antarctica.Lat, antarctica.Lon, [245 240 240]/255)
hold off;
colormap(ax3,cmocean('balance',100));
caxis([-5 5])
set(gca,'FontSize',fontsize);
handle = title({'Winter zonal ice drift speed (cm/s)'},'FontSize',fontsize+3,'interpreter','latex');
% 1979-2015 ,'NASA Pathfinder'
set(handle,'Position',[0 0.75 0]);

%%% Add colorbar
handle = colorbar;
set(handle,'Position',[0.45 0.17 0.01 0.16]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SEA SURFACE HEIGHT FIGURE %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Load data
load /home/csi/research/etopo1/AntarcticCoastline.mat
load /home/csi/research/SouthernOceanSSH/DOT_climatology_JJA.mat


%%% Make the plot
ax4 = subplot('position',[0.5 0.03 0.45 0.45]);
annotation('textbox',[0.5 0.445 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% [im, map, alpha] = imread('arrows.png');
% f = imshow(im);
% set(f, 'AlphaData', alpha);
hold on;
set(gca,'Color','w')
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel','north') 
setm(gca,'PLabelLocation',[-80:10:-60]);
setm(gca,'PLineLocation',[-85:5:-60]);
setm(gca,'MLineLocation',[-180:30:180]);
setm(gca,'MLabelLocation',[-180:30:180]);
DOT_clim(isnan(DOT_clim))=0;
aa = pcolorm(double(Latitude),double(Longitude),double(DOT_clim));        
shading interp;
% hold on;
bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
% coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
% patchm(antarctica.Lat, antarctica.Lon, [245 240 240]/255)

hold off;
% col4 = colormap(ax4,'haxby');
% col4=flipud(cmocean('tarn',256));
% colormap(ax4,col4(1:end,:));
colormap(ax4,flipud(WhiteBlueGreenYellowRed(1)));


% caxis([-200 -165])
caxis([-215 -165])
set(gca,'FontSize',fontsize);
handle = title({'Winter sea surface elevation (cm)'},'FontSize',fontsize+3,'interpreter','latex');
% 2011-2016 ,'Armitage et al. (2018)' ,'and geostrophic currents (cm/s)
set(handle,'Position',[0 0.75 0]);

%%% Add colorbar
handle = colorbar;
set(handle,'Position',[0.94 0.17 0.01 0.16]);

%%% Add legend
% leghandle = legend([coasthandle,bathyhandle],{'Coastline','1000m depth contour'},...
%     'interpreter','latex','orientation','horizontal');
% set(leghandle,'FontSize',fontsize+2);
% set(leghandle,'Position',legpos);
% legend boxon;

leghandle = legend([bathyhandle],{'1000m depth contour'},...
    'interpreter','latex','orientation','horizontal');
set(leghandle,'FontSize',fontsize+2);
set(leghandle,'Position',legpos);
legend boxon;



%% Write to file

% saveas(gcf,'jpo_motivation','epsc');