%%%
%%% calcFig2_woa23_cdw.m
%%%
%%% Extract Amundsen Sea CDW thickness and CDW potential temperature from
%%% WOA2023

clear;

load tt91_annual.mat
tt_woa=tt91_annual; clear tt91_annual;

Nx_woa = length(lon);
Ny_woa = length(lat);
Nr_woa = length(depth);

tt_woa(tt_woa==0)=NaN;
mask_cdw_woa = ones(Nx_woa,Ny_woa,Nr_woa);
mask_cdw_woa(tt_woa<0)=NaN;
mask_cdw_woa(isnan(tt_woa))=NaN;

lat_woa = double(lat);
lon_woa = double(lon);

[LAT_woa,LON_woa] = meshgrid(lat_woa,lon_woa);

dz1 = [0;diff(depth)];
dz2 = [diff(depth);100];
dz_woa = 0.5*(dz1+dz2);
DZ_woa = repmat(reshape(dz_woa,[1 1 Nr_woa]),[Nx_woa Ny_woa 1]);

%%% Find CDW layer
hh_cdw_woa = sum(DZ_woa.*mask_cdw_woa,3,'omitnan');
hh_cdw_woa(hh_cdw_woa==0)=NaN;

tt_cdw_woa = sum(tt_woa.*DZ_woa.*mask_cdw_woa,3,'omitnan')./hh_cdw_woa;
tt_cdw_woa(tt_cdw_woa==0)=NaN;


save('tt91_winter_cdw.mat','LAT_woa','LON_woa','hh_cdw_woa','tt_cdw_woa','lat_woa','lon_woa');


%%% Plotting options
fontsize = 14;
scrsz = get(0,'ScreenSize');
framepos = [scrsz(3)/8 200 800 750];
cbpos = [0.85 0.109999983800782 0.0160416565421553 0.156666682865885];
linewidth = 2;
boxcolor = 'k';

figure(1)
clf;
set(gcf,'Color','w')
set(gcf,'Position',framepos);
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -50],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel',[-30]) 
pcolorm(LAT_woa,LON_woa,hh_cdw_woa/1000);
colormap(cmocean('dense'));
% colormap(jet);
% clim([33.9 35]);
title('CDW thickness (km), annual-mean climatology')
handle = colorbar;
set(handle,'Position',cbpos);
set(gca,'FontSize',fontsize);

figure(2)
clf;
set(gcf,'Color','w')
set(gcf,'Position',framepos);
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -50],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel',[-30]) 
pcolorm(LAT_woa,LON_woa,tt_cdw_woa);
colormap(cmocean('dense'));
% colormap(jet);
clim([0 2]);
title('CDW temperature (^oC), annual-mean climatology')
set(gca,'FontSize',fontsize);
mainpos = get(gca,'Position');
mainpos(1) = mainpos(1) - 0.02;
set(gca,'Position',mainpos);
handle = colorbar;
set(handle,'Position',cbpos);

% print('-djpeg','-r250','ss81_annual_bottomT.jpeg');



