
clear

%%% Latitude to offshore distance in km
dlat = 111.5; % unit: km


addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
ncolor = 40;


%%
% load ss81_winter.mat %%% Southern Hemisphere summer
% ss=ss81_winter;
% load tt81_winter.mat
% tt=tt81_winter;
% load ss81_summer.mat %%% Southern Hemisphere winter
% ss=ss81_summer;
% load tt81_summer.mat
% tt=tt81_summer;
load ss81_autumn.mat %%% Southern Hemisphere spring
ss=ss81_autumn;
load tt81_autumn.mat
tt=tt81_autumn;

% load ss81_annual.mat
% ss=ss81_annual;
% load tt81_annual.mat
% tt=tt81_annual;

%%
LONidx_dense=1410; % or 1413 %%% TODO: change the dashed line on fig1
LONidx_fresh =1027;
% LONidx_dense=565;
% LONidx_fresh =1045;
lon_dense = lon(LONidx_dense)
lon_fresh = lon(LONidx_fresh);
ss_dense = squeeze(ss(LONidx_dense,:,:));
ss_fresh = squeeze(ss(LONidx_fresh,:,:));

tt_dense = squeeze(tt(LONidx_dense,:,:));
tt_fresh = squeeze(tt(LONidx_fresh,:,:));


figure(1);
clf;
subplot(2,2,1)
pcolor(lat,-depth,ss_fresh')
shading interp;
% xlim([-70.3 -61])
xlim([-67.5 -63])
ylim([-4200 0])
colorbar
caxis([34.3 34.95])
title('Fresh shelf salinity')

subplot(2,2,2)
pcolor(lat,-depth,ss_dense')
shading interp;
xlim([-74 -68])
% xlim([-78 -68])
% xlim([-78 -63])

ylim([-4200 0])
colorbar
colormap(cmocean('balance',ncolor))
caxis([34.3 34.95])
title('Dense shelf salinity')


subplot(2,2,3)
pcolor(lat,-depth,tt_fresh')
shading interp;
xlim([-68 -63])
ylim([-4200 0])
colorbar
caxis([-2 2])
title('Fresh shelf temperature')

subplot(2,2,4)
pcolor(lat,-depth,tt_dense')
shading interp;
xlim([-74 -68])
% xlim([-78 -63])
ylim([-4200 0])
colorbar
colormap(cmocean('balance',ncolor))
caxis([-2 2])
title('Dense shelf temperature')


save('section_81autumn','lat','depth','ss_dense','ss_fresh','tt_dense','tt_fresh',...
    'LONidx_fresh','LONidx_dense','lon_dense','lon_fresh');
