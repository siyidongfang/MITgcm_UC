%%%
%%% plot_SSH.m
%%%
%%% Plot Antarctic sea level anomaly. Data from https://www.seanoe.org/data/00698/81032/
%%% Daily Southern Ocean Sea Level Anomaly And Geostrophic Currents from multimission altimetry, 2013-2019

clear;close all;
addpath ../colormaps/

%%% Read in .nc data
dataname = '85045.nc'
sla = ncread(dataname,'sla'); %%% Sea Level Anomaly, sea_surface_height_above_sea_level
time = ncread(dataname,'time'); %%% calendar = "gregorian", unit = days since 1950-01-01 00:00:00
latitude = ncread(dataname,'latitude');
longitude = ncread(dataname,'longitude');

%%% convert time to dates
DateTime = datetime(1950,1,1,'Format','dd-MMM-yyyy HH:mm:ss') + days(time);
sla(sla>1000)=NaN;

%%

meanSSH = mean(sla(:,:,1:end),3,'omitnan');

%%% Make a figure
figure(1)
set(gcf,'Color','w');
pcolor(meanSSH);
shading flat;colorbar;
colormap(redblue)
% clim([-0.1 0.1])
clim([-0.1 0.1]/1e7)
set(gca,'FontSize',17)
title('Sea Level Anomaly (m), 2013-2019 mean')


%%% Make an animation of daily SSH
% nT = length(time);
% for n =1:nT
%     SSH = sla(:,:,n);
%     figure(2)
%     set(gcf,'Color','w');
%     pcolor(SSH);
%     shading flat;colorbar;
%     colormap(redblue)
%     clim([-0.1 0.1])
%     title(datestr(DateTime(n)))
%     set(gca,'FontSize',17)
% end

% figure(2)
% pcolor(longitude)
% shading flat;colorbar;
% 
% figure(3)
% pcolor(latitude)
% shading flat;colorbar;


