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
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/;
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2022
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2020
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2019
addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2016
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
ncfname = 'EN.4.2.2.f.profiles.g10.202202.nc';

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

figure(3)
scatter(LONGITUDE(idx_Am),LATITUDE(idx_Am));
shading flat;colorbar;

figure(4)
pcolor(TEMP(:,idx_Am));shading flat;


%%% Calculate the CDW depth




