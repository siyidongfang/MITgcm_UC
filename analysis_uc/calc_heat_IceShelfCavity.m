
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

    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','SHI_TauY','THETA','SHIfwFlx');
    vt = VVELTH;
    tt = THETA;
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    dx = delX(1);
    [YY,XX] = meshgrid(yy,xx);

    %%% Find ice shelf cavity
    idx_iceshelf_vgrid = SHI_TauY./SHI_TauY; %%% on v-grid
    idx_iceshelf_massgrid = SHIfwFlx./SHIfwFlx; %%% on mass-grid

    %%% Calculate cumulative heat transport Tc(x)
    vt_zint = sum(vt.*DZ.*hFacS,3,'omitnan'); 
    Tc_xy = cp_o*rho_o*flip(cumsum(flip(-vt_zint.*idx_iceshelf_vgrid*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy = Tc_xy.*idx_iceshelf_vgrid;
    idx_Tc = find(~isnan(idx_iceshelf_vgrid(round(Nx/2),:)),1,'last');
    Tc = Tc_xy(:,idx_Tc);


    %%% Calculate cumulative heat transport Tc_CDW(x) for the CDW layer
    tt_cdw = tt;
    tt_cdw(tt_cdw<0)=NaN; %%% Find the CDW layer: temperature above 0 degC

    tt_cdw_vgrid = zeros(Nx,Ny,Nr);
    tt_cdw_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2;
    tt_cdw_vgrid(tt_cdw_vgrid<0)=NaN; %%% Find the CDW layer: temperature above 0 degC

    idx_cdw = tt_cdw./tt_cdw; %%% Find the CDW layer, mass-grid
    idx_cdw_vgrid = tt_cdw_vgrid./tt_cdw_vgrid; %%% v-grid
    
    vt_zint_cdw = sum(vt.*DZ.*hFacS.*idx_cdw_vgrid,3,'omitnan'); 
    Tc_xy_cdw = cp_o*rho_o*flip(cumsum(flip(-vt_zint_cdw.*idx_iceshelf_vgrid*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy_cdw = Tc_xy_cdw.*idx_iceshelf_vgrid;
    idx_Tc = find(~isnan(idx_iceshelf_vgrid(round(Nx/2),:)),1,'last');
    Tc_cdw = Tc_xy_cdw(:,idx_Tc);


    %%% Find the upper bound and lower bound of the CDW layer
    HH_cdw = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH_cdw(HH_cdw==0)=NaN;

    idx_upper = zeros(Nx,Ny);
    idx_lower = zeros(Nx,Ny);
    Zupper = zeros(Nx,Ny);
    Zlower = zeros(Nx,Ny);
    for i=1:Nx
        for j=1:Ny
            aa = find(~isnan(idx_cdw(i,j,:)),1,'first');
            bb = find(~isnan(idx_cdw(i,j,:)),1,'last');
            if (isempty(aa)||isempty(bb))
                idx_upper(i,j) = NaN;
                Zupper(i,j) = NaN;
                idx_lower(i,j) = NaN;
                Zlower(i,j) = NaN;
            else
                idx_upper(i,j) = aa;
                Zupper(i,j) = zz(aa);
                idx_lower(i,j) = bb;
                Zlower(i,j) = zz(bb);
            end
        end
    end

    %%% Make and save the figure
    fontsize = 17; 

    figure(1)
    set(gcf,'Position',[294 476 1326 754])
    clf;
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint.*idx_iceshelf_vgrid)');colorbar;colormap(redblue);shading flat;xlim([-110 110]);ylim([0 110])
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
    
   

    figure(2)
    set(gcf,'Position',[294 476 1326 754])
    clf;
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw.*idx_iceshelf_vgrid)');colorbar;colormap(redblue);shading flat;xlim([-110 110]);ylim([0 110])
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
    





%     figure(3)
%     set(gcf,'Position',[294 476 1326 754])
%     subplot(2,2,1)
%     pcolor(xx/1000,yy/1000,-Zupper');
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
%     shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
%     xlabel('Longitude (km)');ylabel('Latitude (km)');
%     title('Depth of the upper bound of the CDW layer (m)')
%     set(gca,'FontSize',fontsize);
%     ylim([0 200])
%     caxis([0 1000])
% 
%     subplot(2,2,2)
%     pcolor(xx/1000,yy/1000,-Zlower');
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
%     shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
%     xlabel('Longitude (km)');ylabel('Latitude (km)');
%     title('Depth of the lower bound of the CDW layer (m)')
%     set(gca,'FontSize',fontsize);
%     ylim([0 200])
%     caxis([0 1000])
%    
% 
%     subplot(2,2,3)
%     pcolor(xx/1000,yy/1000,HH_cdw');
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
%     shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
%     xlabel('Longitude (km)');ylabel('Latitude (km)');
%     title('CDW thickness (m)')
%     set(gca,'FontSize',fontsize);
%     ylim([0 200])
%     caxis([0 1000])
% 
%     subplot(2,2,4)
%     pcolor(xx/1000,yy/1000,-bathy');
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
%     shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
%     xlabel('Longitude (km)');ylabel('Latitude (km)');
%     title('Depth of the seafloor (m)')
%     set(gca,'FontSize',fontsize);
%     ylim([0 200])
%     caxis([0 1000])

