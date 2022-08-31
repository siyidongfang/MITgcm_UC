
%%%
%%% calc_heat_IceShelfCavity.m
%%%
%%% Calculate the cumulative heat transport within the ice shelf cavity

    clear; 
    close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    figdir = '/Users/csi/MITgcm_UC/figures_uc/heat_IceShelfCavity/seaice_boundary/';

    loadexp;

    rho_o =1000;
    cp_o = 3994; % Unit: J/kg/degC
    m1km = 1000;
    Yicefront = 100*m1km; %%% Latitude of ice shelf face

    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','SHI_TauY','THETA');
    vt = VVELTH;
    tt = THETA;
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    dx = delX(1);
    [YY,XX] = meshgrid(yy,xx);

    %%% Find ice shelf cavity
    idx_iceshelf = SHI_TauY./SHI_TauY; %%% on v-grid

    %%% Calculate cumulative heat transport Tc(x)
    vt_zint = sum(vt.*DZ.*hFacS,3,'omitnan'); 
    Tc_xy = cp_o*rho_o*flip(cumsum(flip(-vt_zint.*idx_iceshelf*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy = Tc_xy.*idx_iceshelf;
    idx_Tc = find(~isnan(idx_iceshelf(round(Nx/2),:)),1,'last');
    Tc = Tc_xy(:,idx_Tc);


    %%% Make and save the figure
    fontsize = 17; 

    figure(1)
    set(gcf,'Position',[294 476 1326 754])
    clf;
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint.*idx_iceshelf)');colorbar;colormap(redblue);shading flat;xlim([-110 110]);ylim([0 110])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:30:-680],'k:','LineWidth',1,'ShowText','on');clabel(C,h,'LabelSpacing',2000);hold off;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('Latitude, y (km)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    caxis([-0.1 0.1])
    title('Onshore heat flux in the cavity ($10^9\,$W/m)','interpreter','latex');
    freezeColors;

    subplot(2,2,2)
    pcolor(xx/1000,yy/1000,Tc_xy');colorbar;colormap(WhiteBlueGreenYellowRed(0));shading flat;xlim([-110 110]);ylim([0 110])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:30:-680],'k:','LineWidth',1,'ShowText','on');clabel(C,h,'LabelSpacing',2000);hold off;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('Latitude, y (km)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    caxis([0 2.5])
    title('Cumulative heat transport in the cavity ($10^{12}\,$W)','interpreter','latex');

    subplot(2,2,3)
    plot(xx/1000,Tc,'LineWidth',2);xlim([-110 110]);
    ylim([-0.5 2.5]);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('($10^{12}\,$W)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    title('Cumulative heat transport at ice front (y = 100 km)','interpreter','latex');
    

    subplot(2,2,4)
    plot(xx/1000,mean(Tc_xy,2,'omitnan'),'LineWidth',2);xlim([-110 110]);
    ylim([-0.5 2.5]);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('($10^{12}\,$W)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    title('Meridional-mean heat transport in the cavity','interpreter','latex');
    
    %%
    

    %%% Calculate cumulative heat transport Tc_CDW(x) for the CDW layer
    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
     
    idx_cdw = tt_cdw./tt_cdw; %%% Find the CDW layer
    vt_zint_cdw = sum(vt.*DZ.*hFacS.*idx_cdw,3,'omitnan'); 
    Tc_xy_cdw = cp_o*rho_o*flip(cumsum(flip(-vt_zint_cdw.*idx_iceshelf*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy_cdw = Tc_xy_cdw.*idx_iceshelf;
    idx_Tc = find(~isnan(idx_iceshelf(round(Nx/2),:)),1,'last');
    Tc_cdw = Tc_xy_cdw(:,idx_Tc);


    figure(2)
    set(gcf,'Position',[294 476 1326 754])
    clf;
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw.*idx_iceshelf)');colorbar;colormap(redblue);shading flat;xlim([-110 110]);ylim([0 110])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:30:-680],'k:','LineWidth',1,'ShowText','on');clabel(C,h,'LabelSpacing',2000);hold off;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('Latitude, y (km)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    caxis([-0.1 0.1])
    title('Onshore $\bf{CDW}$ heat flux in the cavity ($10^9\,$W/m)','interpreter','latex');
    freezeColors;

    subplot(2,2,2)
    pcolor(xx/1000,yy/1000,Tc_xy_cdw');colorbar;colormap(WhiteBlueGreenYellowRed(0));shading flat;xlim([-110 110]);ylim([0 110])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:30:-680],'k:','LineWidth',1,'ShowText','on');clabel(C,h,'LabelSpacing',2000);hold off;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('Latitude, y (km)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    caxis([0 2.5])
    title('Cumulative $\bf{CDW}$ heat transport in the cavity ($10^{12}\,$W)','interpreter','latex');

    subplot(2,2,3)
    plot(xx/1000,Tc_cdw,'LineWidth',2);xlim([-110 110]);
    ylim([-0.5 2.5]);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('($10^{12}\,$W)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    title('Cumulative $\bf{CDW}$ heat transport at ice front (y = 100 km)','interpreter','latex');
    
    
    subplot(2,2,4)
    plot(xx/1000,mean(Tc_xy_cdw,2,'omitnan'),'LineWidth',2);xlim([-110 110]);
    ylim([-0.5 2.5]);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;
    xlabel('Longitude, x (km)','interpreter','latex');
    ylabel('($10^{12}\,$W)','interpreter','latex');
    set(gca,'FontSize',fontsize);
    title('Meridional-mean $\bf{CDW}$ heat transport in the cavity','interpreter','latex');
    
    
    
    
    
    %%
    %%% Plot the vertical location of the upper and lower bounds of the CDW layer
    
    
    

