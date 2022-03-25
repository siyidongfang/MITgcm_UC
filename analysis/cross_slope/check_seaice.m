

clear;

addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/data/MITgcm_ASF-csi/products-hires'
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
outdir = '/data/MITgcm_ASF-csi/cross_slope_exchange/figures_HeatSaltFlux/'

EXPNAME = {
    'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis'

    'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new100s'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws100_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
};

Ny = 448;
Nexp = length(EXPNAME);

SIarea_bunch = zeros(Ny,Nexp);
SIheff_bunch = zeros(Ny,Nexp);
SItices_bunch = zeros(Ny,Nexp);
oceQnet_bunch = zeros(Ny,Nexp);
oceSflux_bunch = zeros(Ny,Nexp);
oceFWflx_bunch = zeros(Ny,Nexp);
SIvice_bunch = zeros(Ny,Nexp);
SIuice_bunch = zeros(Ny,Nexp);

for ne = 1:Nexp  
    
expname = EXPNAME{ne}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIheff','SIarea','SItices',...
    'oceQnet','oceSflux','oceFWflx','SIvice','SIuice');

SIarea_bunch(:,ne) = squeeze(mean(SIarea(:,:,1),1));
SIheff_bunch(:,ne) = squeeze(mean(SIheff(:,:,1),1));
SItices_bunch(:,ne) = squeeze(mean(SItices(:,:,1),1));
oceQnet_bunch(:,ne) = squeeze(mean(oceQnet(:,:,1),1));
oceSflux_bunch(:,ne) = squeeze(mean(oceSflux(:,:,1),1));
oceFWflx_bunch(:,ne) = squeeze(mean(oceFWflx(:,:,1),1));
SIvice_bunch(:,ne) = squeeze(mean(SIvice(:,:,1),1));
SIuice_bunch(:,ne) = squeeze(mean(SIuice(:,:,1),1));

end

save(fullfile(prodir,'ice_properties.mat'),'EXPNAME',...
    'SIarea_bunch','SIheff_bunch','SItices_bunch','oceQnet_bunch',...
    'oceSflux_bunch','oceFWflx_bunch','SIvice_bunch','SIuice_bunch'); 






%%
loadexp;



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


fontsize=12;


figure(1)
clf;
subplot(4,2,1)
plot(yy/1000,SIarea_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,SIarea_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,SIarea_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,SIarea_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,SIarea_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,SIarea_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title('Fractional ice-covered area')

subplot(4,2,2)
plot(yy/1000,SIheff_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,SIheff_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,SIheff_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,SIheff_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,SIheff_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,SIheff_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title('Sea ice thickness (m)')



subplot(4,2,3)
plot(yy/1000,SIuice_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,SIuice_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,SIuice_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,SIuice_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,SIuice_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,SIuice_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title('Zonal ice velocity (m/s)')

subplot(4,2,4)
plot(yy/1000,SIvice_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,SIvice_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,SIvice_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,SIvice_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,SIvice_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,SIvice_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title('Meridional ice velocity (m/s)')


subplot(4,2,5)
plot(yy/1000,SItices_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,SItices_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,SItices_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,SItices_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,SItices_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,SItices_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title('Surface temperature over sea ice (degC)')



subplot(4,2,6)
plot(yy/1000,oceQnet_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,oceQnet_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,oceQnet_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,oceQnet_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,oceQnet_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,oceQnet_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title({'Net surface heat flux into the ocean','(W/m^2), <0 decreases theta'})


subplot(4,2,7)
plot(yy/1000,oceSflux_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,oceSflux_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,oceSflux_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,oceSflux_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,oceSflux_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,oceSflux_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title({'Net surface Salt flux into the ocean','(g/m^2/s), <0 decreases salinity'})
xlabel('y (km)')


subplot(4,2,8)
plot(yy/1000,oceFWflx_bunch(:,25),'LineWidth',1.5,'color',blue)
hold on;
plot(yy/1000,oceFWflx_bunch(:,26),'LineWidth',1.5,'color',lightblue)
plot(yy/1000,oceFWflx_bunch(:,27),'LineWidth',1.5,'color','k')
plot(yy/1000,oceFWflx_bunch(:,28),'LineWidth',1.5,'color',purple)
plot(yy/1000,oceFWflx_bunch(:,29),'LineWidth',1.5,'color',yellow)
plot(yy/1000,oceFWflx_bunch(:,30),'LineWidth',1.5,'color',orange)
xlim([25 425])
title({'Net surface Fresh-Water flux into the ocean','(kg/m^2/s), >0 decreases salinity'})
xlabel('y (km)')

legend(...
    'Very fresh, $\mathrm{\Delta \sigma_4}=-1.076\mathrm{kg\ m}^{-3}$',...
    '$\mathrm{\Delta \sigma_4}=-0.620\mathrm{kg\ m}^{-3}$',...
    'Ref., $\mathrm{\Delta \sigma_4}=-0.207\mathrm{kg\ m}^{-3}$',...
    '$\mathrm{\Delta \sigma_4}=0.000\mathrm{kg\ m}^{-3}$',...
    '$\mathrm{\Delta \sigma_4}=0.204\mathrm{kg\ m}^{-3}$',...
    'Very dense, $\mathrm{\Delta \sigma_4}=0.409\mathrm{kg\ m}^{-3}$',...
    'FontSize', fontsize,'interpreter','latex',...
    'Position',[0.1437 0.1267 0.3 0.12]);


print('-dpng','-r150',[outdir 'seaice_buoyancy-hires.png']);



%%




figure(1)
clf;
subplot(4,2,1)
plot(yy/1000,SIarea_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,SIarea_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title('Fractional ice-covered area')

subplot(4,2,2)
plot(yy/1000,SIheff_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,SIheff_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title('Sea ice thickness (m)')



subplot(4,2,3)
plot(yy/1000,SIuice_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,SIuice_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title('Zonal ice velocity (m/s)')

subplot(4,2,4)
plot(yy/1000,SIvice_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,SIvice_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title('Meridional ice velocity (m/s)')


subplot(4,2,5)
plot(yy/1000,SItices_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,SItices_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title('Surface temperature over sea ice (degC)')



subplot(4,2,6)
plot(yy/1000,oceQnet_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,oceQnet_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title({'Net surface heat flux into the ocean','(W/m^2), <0 decreases theta'})


subplot(4,2,7)
plot(yy/1000,oceSflux_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,oceSflux_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Salt flux into the ocean','(g/m^2/s), <0 decreases salinity'})
xlabel('y (km)')


subplot(4,2,8)
plot(yy/1000,oceFWflx_bunch(:,1),'LineWidth',1.5)
hold on;
plot(yy/1000,oceFWflx_bunch(:,2),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,3),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,4),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,5),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Fresh-Water flux into the ocean','(kg/m^2/s), >0 decreases salinity'})
xlabel('y (km)')

legend('A$_\mathrm{tide}$ = 0 m/s','A$_\mathrm{tide}$ = 0.025 m/s','A$_\mathrm{tide}$ = 0.05 m/s',...
    'A$_\mathrm{tide}$ = 0.075 m/s','A$_\mathrm{tide}$ = 0.1 m/s',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.2035 0.12])


print('-dpng','-r150',[outdir 'seaice_tides-hires.png']);




%%
figure(1)
clf;
subplot(4,2,1)
plot(yy/1000,SIarea_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,SIarea_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title('Fractional ice-covered area')

subplot(4,2,2)
plot(yy/1000,SIheff_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,SIheff_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title('Sea ice thickness (m)')



subplot(4,2,3)
plot(yy/1000,SIuice_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,SIuice_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title('Zonal ice velocity (m/s)')

subplot(4,2,4)
plot(yy/1000,SIvice_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,SIvice_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title('Meridional ice velocity (m/s)')


subplot(4,2,5)
plot(yy/1000,SItices_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,SItices_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title('Surface temperature over sea ice (degC)')



subplot(4,2,6)
plot(yy/1000,oceQnet_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,oceQnet_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title({'Net surface heat flux into the ocean','(W/m^2), <0 decreases theta'})


subplot(4,2,7)
plot(yy/1000,oceSflux_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,oceSflux_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Salt flux into the ocean','(g/m^2/s), <0 decreases salinity'})
xlabel('y (km)')


subplot(4,2,8)
plot(yy/1000,oceFWflx_bunch(:,20),'LineWidth',1.5)
hold on;
plot(yy/1000,oceFWflx_bunch(:,21),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,22),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,23),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,24),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Fresh-Water flux into the ocean','(kg/m^2/s), >0 decreases salinity'})
xlabel('y (km)')

legend('Ws = 50 km','Ws = 100 km','Ws = 150 km','Ws = 200 km','Ws = 250 km',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.2035 0.12])


print('-dpng','-r150',[outdir 'seaice_Ws-hires.png']);





%%
figure(1)
clf;
subplot(4,2,1)
plot(yy/1000,SIarea_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,SIarea_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,13),'LineWidth',1.5)

xlim([25 425])
title('Fractional ice-covered area')

subplot(4,2,2)
plot(yy/1000,SIheff_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,SIheff_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title('Sea ice thickness (m)')



subplot(4,2,3)
plot(yy/1000,SIuice_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,SIuice_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title('Zonal ice velocity (m/s)')

subplot(4,2,4)
plot(yy/1000,SIvice_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,SIvice_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title('Meridional ice velocity (m/s)')


subplot(4,2,5)
plot(yy/1000,SItices_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,SItices_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title('Surface temperature over sea ice (degC)')



subplot(4,2,6)
plot(yy/1000,oceQnet_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,oceQnet_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title({'Net surface heat flux into the ocean','(W/m^2), <0 decreases theta'})


subplot(4,2,7)
plot(yy/1000,oceSflux_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,oceSflux_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Salt flux into the ocean','(g/m^2/s), <0 decreases salinity'})
xlabel('y (km)')


subplot(4,2,8)
plot(yy/1000,oceFWflx_bunch(:,6),'LineWidth',1.5)
hold on;
plot(yy/1000,oceFWflx_bunch(:,7),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,8),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,9),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,10),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,12),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,13),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Fresh-Water flux into the ocean','(kg/m^2/s), >0 decreases salinity'})
xlabel('y (km)')

legend('Ua=0,Va=6 (unit:m/s)','Ua=-4,Va=6','Ua=-6,Va=6','Ua=-8,Va=6',...
    'Ua=-6,Va=4','Ua=-6,Va=8','Ua=-6,Va=12',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.1388 0.5839 0.1 0.15])

print('-dpng','-r150',[outdir 'seaice_wind-hires.png']);





%%
figure(1)
clf;
subplot(4,2,1)
plot(yy/1000,SIarea_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,SIarea_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,SIarea_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title('Fractional ice-covered area')

subplot(4,2,2)
plot(yy/1000,SIheff_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,SIheff_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,SIheff_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title('Sea ice thickness (m)')



subplot(4,2,3)
plot(yy/1000,SIuice_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,SIuice_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,SIuice_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title('Zonal ice velocity (m/s)')

subplot(4,2,4)
plot(yy/1000,SIvice_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,SIvice_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,SIvice_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title('Meridional ice velocity (m/s)')


subplot(4,2,5)
plot(yy/1000,SItices_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,SItices_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,SItices_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title('Surface temperature over sea ice (degC)')



subplot(4,2,6)
plot(yy/1000,oceQnet_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,oceQnet_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,oceQnet_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title({'Net surface heat flux into the ocean','(W/m^2), <0 decreases theta'})


subplot(4,2,7)
plot(yy/1000,oceSflux_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,oceSflux_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,oceSflux_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Salt flux into the ocean','(g/m^2/s), <0 decreases salinity'})
xlabel('y (km)')


subplot(4,2,8)
plot(yy/1000,oceFWflx_bunch(:,14),'LineWidth',1.5)
hold on;
plot(yy/1000,oceFWflx_bunch(:,15),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,16),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,17),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,18),'LineWidth',1.5)
plot(yy/1000,oceFWflx_bunch(:,19),'LineWidth',1.5)
xlim([25 425])
title({'Net surface Fresh-Water flux into the ocean','(kg/m^2/s), >0 decreases salinity'})
xlabel('y (km)')

legend('h$_{i0}$ = 0.2 m','h$_{i0}$ = 0.6 m','h$_{i0}$ = 1 m',...
    'h$_{i0}$ = 1.4 m','h$_{i0}$ = 1.8 m','h$_{i0}$ = 2.2 m',...
    'interpreter','latex','FontSize', fontsize+1, 'Position',[0.5344 0.1560 0.1 0.15])

print('-dpng','-r150',[outdir 'seaice_icethickness-hires.png']);

