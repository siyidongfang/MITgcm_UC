%%%
%%% plot_en4.m
%%%
%%% Make cross sections with the EN4 dataset: https://www.metoffice.gov.uk/hadobs/en4/
%%% 
%%% Observations of the Amundsen continental shelf:
%%% 2022 02-08
%%% 2020 03-09
%%% 2019 02-11
%%% 2016 01-02
%%% Use 2019, 2020, 2022 3-year average??

%%% Plot one crose-section first??


clear;

addpath /Users/csi/MITgcm_UC/analysis_uc;
addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;

addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/;
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2022
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2020
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2019
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2016
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2014
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2013

addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.analyses.g10.2020


% % %%% Load the data
% ncfname = 'EN.4.2.2.f.analysis.g10.202004.nc';
% 
% %%% Load file data
% lat = ncread(ncfname,'lat');
% lon = ncread(ncfname,'lon');
% depth = ncread(ncfname,'depth');
% temperature = ncread(ncfname,'temperature');
% salinity = ncread(ncfname,'salinity');
% 
% figure(1)
% pcolor(lon,lat,temperature(:,:,1)');shading flat;colorbar;


%%% Load the data
ncfname = 'EN.4.2.2.f.profiles.g10.201212.nc';

%%% Load file data
LATITUDE = ncread(ncfname,'LATITUDE');
LONGITUDE = ncread(ncfname,'LONGITUDE');
DEPH_CORRECTED = ncread(ncfname,'DEPH_CORRECTED'); %%% corrected depth, m
TEMP = ncread(ncfname,'TEMP'); %%% temperature in situ t90 scale, degC
PSAL_CORRECTED = ncread(ncfname,'PSAL_CORRECTED'); %%% corrected practical salinity, unit 1
JULD = ncread(ncfname,'JULD'); %%% days since 1950-01-01 00:00:00 utc
% PI_NAME = ncread(ncfname,'PI_NAME'); %%% primary investigator name

% figure(1)
% scatter(LONGITUDE,LATITUDE)

%%% Find the profiles in the Amundsen Sea
lat_max = -65;
lon_min = -150;
lon_max = -90;

% lat_max = -65;
% lon_min = -110;
% lon_max = -95;

idx_Am = [];
for i=1:length(LATITUDE)
    if(LATITUDE(i)<=lat_max && LONGITUDE(i)>=lon_min && LONGITUDE(i)<=lon_max)
        idx_Am = [idx_Am i];
    end
end

% PI_Am = PI_NAME(:,idx_Am);
% for i=1:length(idx_Am)
%     PI_Am(:,i)'
% end


lat = LATITUDE(idx_Am);
lon = LONGITUDE(idx_Am);
temp = TEMP(:,idx_Am);
depth = DEPH_CORRECTED(:,idx_Am);

figure(4)
pcolor(temp);shading flat;colorbar;clim([-1 1]);colormap(redblue)

figure(5)
pcolor(depth);shading flat;colorbar;colormap(jet);clim([0 1000])


%%
    fontsize = 17;linewidth=2;
    figure(6)
    clf;set(gcf,'Color','w')

    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/etopo1/
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/SouthernOceanSSH/
    %%% Load data
    load AntarcticCoastline.mat
    %%%%%%%%%%% Load the coastline
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});

    latlim = [-78 -65];lonlim = [181 -65];
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',30);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    % aa = pcolorm(LAT,LON,double(DOT_clim)/100);  
    aa = scatterm(lat,lon);  
    shading interp;colormap(cmocean('balance'));
    % clim([-2.15 -1.55])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);
    % title('Dynamic ocean topography','FontSize',fontsize+3,'FontWeight','normal')
    % h1 = colorbar;
    % set(h1,'Position', [0.295 0.673 0.008 0.21]);
    % annotation('textbox',[0.288 0.93 0.15 0.01],'String','(m)','FontSize',fontsize,'LineStyle','None');



