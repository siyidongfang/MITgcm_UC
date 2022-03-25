%%% Plot the zonal mean meridional heat transport

clear;close all;
fontsize = 12;

addpath /data/MITgcm_ASF-csi/analysis/colormaps
addpath /data/MITgcm_ASF-csi/analysis/colormaps/customcolormap
addpath /data/MITgcm_ASF-csi/analysis/jpo_analysis-hires
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
prodir = '/data/MITgcm_ASF-csi/products-hires/';
boxcolor = [0.85 0.85 0.85];
blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;
darkgray = [150 150 150]/255;

EXPNAME = {...
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
  };
TEXT = {...
    {'$\mathrm{\Delta \sigma_4}=$','  $-1.076$','  $\mathrm{kg\ m}^{-3}$'}
    {'$\mathrm{\Delta \sigma_4}=$','  $-0.620$','  $\mathrm{kg\ m}^{-3}$'}
    {'$\mathrm{\Delta \sigma_4}=$','  $-0.207$','  $\mathrm{kg\ m}^{-3}$'}
    {'$\mathrm{\Delta \sigma_4}=$','  $0.000$','  $\mathrm{kg\ m}^{-3}$'}
    {'$\mathrm{\Delta \sigma_4}=$','  $0.204$','  $\mathrm{kg\ m}^{-3}$'}
    {'$\mathrm{\Delta \sigma_4}=$','  $0.409$','  $\mathrm{kg\ m}^{-3}$'}
    };
IMGNAME = {...
    'Very_fresh' 'Fresh' 'Ref' 'Neutral' 'Dense' 'Very_dense'};

Nexp = length(EXPNAME);
expname = EXPNAME{3};
loadexp;
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

vtheta_total = zeros(Nexp,Ny);
vtheta_mean = zeros(Nexp,Ny);
vtheta_eddy = zeros(Nexp,Ny);


for ne = 1:Nexp
    expname = EXPNAME{ne}
    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','VVEL','THETA');
    VVELTH(THETA==0) = NaN;
    VVEL(THETA==0) = NaN;
    THETA(THETA==0) = NaN;
    T_
    vtheta_total(ne,:) = squeeze(nanmean(sum(VVELTH.*DZ.*hFacS,3)));%%% Zonally averaged, depth-integrated 
    vtheta_mean(ne,:) = squeeze(nanmean(sum(VVELTH.*DZ.*hFacS,3)));
    vtheta_eddy(ne,:) = 
    
    %     vvelth_xavg=squeeze(nanmean(VVELTH,1));

end






%     figure(1)
%     pcolor(yy/1000,-zz/1000,vvelth_xavg');shading interp;colorbar;colormap(redblue);axis ij;
%     caxis([-0.01 0.01])
%     set(gca,'color',boxcolor);
%     hold on;
%     plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
%     plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     hold off;
%     xlabel('y (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
%     title('Meridional ocean heat transport ($^\circ$C m/s)','FontSize', fontsize+2,'interpreter','latex');
%     text(50,3,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/VVELTH_' IMGNAME{ne} '.png']);
%  
%     figure(5)
%     pcolor(yy/1000,-zz/1000,vvel_xavg');shading interp;colorbar;colormap(redblue);axis ij;
%     caxis([-0.01 0.01])
%     set(gca,'color',boxcolor);
%     hold on;
%     plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
%     plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     hold off;
%     xlabel('y (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
%     title('Meridional velocity (m/s)','FontSize', fontsize+2,'interpreter','latex');
%     text(50,3,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/V_' IMGNAME{ne} '.png']);
    
%     figure(6)
%     pcolor(yy/1000,-zz/1000,theta_xavg');shading interp;colorbar;colormap(redblue);axis ij;
%     caxis([-1.7 1.7])
%     set(gca,'color',boxcolor);
%     hold on;
%     plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
%     plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     hold off;
%     xlabel('y (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
%     title('T ($^\circ$C)','FontSize', fontsize+2,'interpreter','latex');
%     text(50,3,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/T_' IMGNAME{ne} '.png']);

    
%     figure(7)
%     pcolor(yy/1000,-zz/1000,theta_xavg'.*vvel_xavg');shading interp;colorbar;colormap(redblue);axis ij;
%     caxis([-0.01 0.01])
%     set(gca,'color',boxcolor);
%     hold on;
%     plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);
%     plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     hold off;
%     xlabel('y (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('Depth (km)','FontSize', fontsize,'interpreter','latex');
%     title('Mean heat transport ($^\circ$C m/s)','FontSize', fontsize+2,'interpreter','latex');
%     text(50,3,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/meanOHT_' IMGNAME{ne} '.png']);



%     figure(2)
%     pcolor(xx/1000,yy/1000,VVEL(:,:,1)');shading interp;colorbar;colormap(redblue);
%     caxis([-0.035 0.035])
%     xlabel('x (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('y (km)','FontSize', fontsize,'interpreter','latex');
%     title('Surface meridional velocity (m/s)','FontSize', fontsize+2,'interpreter','latex');
%     text(-150,350,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/Vsurf_' IMGNAME{ne} '.png']);
% 
%     figure(3)
%     pcolor(xx/1000,yy/1000,THETA(:,:,1)');shading interp;colorbar;colormap(jet);
%     caxis([-1.87 -1.81])
%     xlabel('x (km)', 'FontSize', fontsize,'interpreter','latex');
%     ylabel('y (km)','FontSize', fontsize,'interpreter','latex');
%     title('Ocean surface temperature ($^\circ$C)','FontSize', fontsize+2,'interpreter','latex');
%     text(-150,350,TEXT{ne},'FontSize', fontsize+2,'interpreter','latex')
%     print('-dpng','-r150',['/data/MITgcm_ASF-csi/cross_slope_exchange/Tsurf_' IMGNAME{ne} '.png']);


% figure(4)
% lw = 1.5;
% subplot(3,1,1)
% plot(yy/1000,Vsurf_xavg(1,:),'color',blue,'LineWidth',lw)
% hold on;
% plot(yy/1000,Vsurf_xavg(2,:),'color',orange,'LineWidth',lw)
% plot(yy/1000,Vsurf_xavg(3,:),'color','k','LineWidth',lw+0.5)
% plot(yy/1000,Vsurf_xavg(4,:),'color',yellow,'LineWidth',lw)
% plot(yy/1000,Vsurf_xavg(5,:),'color',purple,'LineWidth',lw)
% plot(yy/1000,Vsurf_xavg(6,:),'color',green,'LineWidth',lw)
% hold off;
% xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
% 
% subplot(3,1,2)
% plot(yy/1000,Tsurf_xavg(1,:),'color',blue,'LineWidth',lw)
% hold on;
% plot(yy/1000,Tsurf_xavg(2,:),'color',orange,'LineWidth',lw)
% plot(yy/1000,Tsurf_xavg(3,:),'color','k','LineWidth',lw+0.5)
% plot(yy/1000,Tsurf_xavg(4,:),'color',yellow,'LineWidth',lw)
% plot(yy/1000,Tsurf_xavg(5,:),'color',purple,'LineWidth',lw)
% plot(yy/1000,Tsurf_xavg(6,:),'color',green,'LineWidth',lw)
% hold off;
% xlabel('y (km)','FontSize', fontsize,'interpreter','latex');
% 
% subplot(3,1,3)
% plot(yy/1000,VVELTHsurf_xavg(1,:),'color',blue,'LineWidth',lw)
% hold on;
% plot(yy/1000,VVELTHsurf_xavg(2,:),'color',orange,'LineWidth',lw)
% plot(yy/1000,VVELTHsurf_xavg(3,:),'color','k','LineWidth',lw+0.5)
% plot(yy/1000,VVELTHsurf_xavg(4,:),'color',yellow,'LineWidth',lw)
% plot(yy/1000,VVELTHsurf_xavg(5,:),'color',purple,'LineWidth',lw)
% plot(yy/1000,VVELTHsurf_xavg(6,:),'color',green,'LineWidth',lw)
% hold off;
% xlabel('y (km)','FontSize', fontsize,'interpreter','latex');

