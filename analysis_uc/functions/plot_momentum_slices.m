%%%
%%% plot_momentum.m
%%% Plot the zonal momentum budget for the ocean
%%%


    clear;close all;

    %%% Add path
    addpath functions/
    addpath colormaps;
    
    expdir = '/Users/csi/MITgcm_UC/experiments/exps_strongwinds/shelfice_obcsE_orlanskiW_surfaceT/';
    expname = 'res2km_Ua-4.4Va4.4_Atide0_Hi0Ai0_Ws30_ardbeg_prod'
    loadexp;
    prodir = [exppath '/'];
    figdir = [exppath '/img/'];

    useSEAICE = false;
    blue = [0 0.4470 0.7410];
    yellow = [0.9290 0.6940 0.1250];
    purple = [0.4940 0.1840 0.5560];
    green = [0.4660 0.6740 0.1880];
    fontsize = 17;

    yup = 1;
    ydown = -1;   
    Ycoast = 122;
    Yshelfbreak = 250;
    Ydeep = 340;

    %%% Zonal integal for the entire domain, excluding the zonal sponge layers 
    spongeThickness = 10;
    zonal_idx = (spongeThickness+1):(Nx-spongeThickness);
    calcMomBudgetFromTendency_xint

    figure()
    subplot(2,2,1)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l3 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l4 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l5 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,yup-0.1,'Ice shelf/continent','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(132,yup-0.1,'Continental shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(280,yup-0.1,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(342,yup-0.1,'Deep','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 Ly/1000+8])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 370])
    title('Ocean zonal force balance (entire domain)','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l5 l3 l4 l0],...
        'Surface stress (wind or ice shelf)',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-2,'interpreter','latex');
    set(leg1,'position',[0.1457    0.1405    0.4811    0.2429])
    legend boxon;
%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum.png']);




    %%% Vertical structure of Um_dPhiX_xint and Um_Advec_xint
    figure()
    set(gcf,'Position',[1 227 1311 390])
    clf;
    subplot(1,2,1)
    pcolor(yy/1000,-zz/1000,Um_dPhiX_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Pressure gradient force (entire domain), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])
    

    subplot(1,2,2)
    pcolor(yy/1000,-zz/1000,Um_Advec_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);
    plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2)
    hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Zonal advection (entire domain), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])

%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum_vert.png']);

%%


    %%% Zonal integal for the trough region (-Wtrough <= x <=Wtrough)
    m1km = 1000;
    Wtrough = 30*m1km;
    zonal_idx = find(xx<-Wtrough,1,'last'):find(xx>Wtrough,1,'first');
    calcMomBudgetFromTendency_xint

    figure()
    clf;
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l3 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l4 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l5 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,yup-0.1,'Ice shelf/continent','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(132,yup-0.1,'Continental shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(280,yup-0.1,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(342,yup-0.1,'Deep','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 Ly/1000+8])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 370])
    title('Ocean zonal force balance (trough)','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l5 l3 l4 l0],...
        'Surface stress (wind or ice shelf)',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1457    0.1405    0.4811    0.2429])
    legend boxon;
    print('-dpng','-r180',[figdir 'tavg_5yr_momentum_trough.png']);

    %%% Vertical structure of Um_dPhiX_xint and Um_Advec_xint
    figure()
    set(gcf,'Position',[1 227 1311 390])
    clf;
    subplot(1,2,1)
    pcolor(yy/1000,-zz/1000,Um_dPhiX_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Pressure gradient force (trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])
    

    subplot(1,2,2)
    pcolor(yy/1000,-zz/1000,Um_Advec_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);
    plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2)
    hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Zonal advection (trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])

    print('-dpng','-r180',[figdir 'tavg_5yr_momentum_trough_vert.png']);




    %%% Zonal integal for east of the trough (100km~200km)
    m1km = 1000;
    zonal_idx = find(xx>100*m1km,1,'first'):find(xx<200*m1km,1,'last');
    calcMomBudgetFromTendency_xint

    figure()
    clf;
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l3 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l4 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l5 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,yup-0.1,'Ice shelf/continent','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(132,yup-0.1,'Continental shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(280,yup-0.1,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(342,yup-0.1,'Deep','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 Ly/1000+8])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 370])
    title('Ocean zonal force balance (east of the trough)','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l5 l3 l4 l0],...
        'Surface stress (wind or ice shelf)',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1457    0.1405    0.4811    0.2429])
    legend boxon;
%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum_east.png']);


    %%% Vertical structure of Um_dPhiX_xint and Um_Advec_xint
    figure()
    set(gcf,'Position',[1 227 1311 390])
    clf;
    subplot(1,2,1)
    pcolor(yy/1000,-zz/1000,Um_dPhiX_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Pressure gradient force (east of the trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])
    

    subplot(1,2,2)
    pcolor(yy/1000,-zz/1000,Um_Advec_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);
    plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2)
    hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Zonal advection (east of the trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])

%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum_east_vert.png']);





    %%% Zonal integal for west of the trough (-100km ~ -200km)
    m1km = 1000;
    zonal_idx = find(xx>-200*m1km,1,'first'):find(xx<-100*m1km,1,'last');
    calcMomBudgetFromTendency_xint

    figure()
    clf;
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l3 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l4 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l5 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,yup-0.1,'Ice shelf/continent','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(132,yup-0.1,'Continental shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(280,yup-0.1,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(342,yup-0.1,'Deep','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 Ly/1000+8])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 370])
    title('Ocean zonal force balance (west of the trough)','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l5 l3 l4 l0],...
        'Surface stress (wind or ice shelf)',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1457    0.1405    0.4811    0.2429])
    legend boxon;
%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum_west.png']);



    %%% Vertical structure of Um_dPhiX_xint and Um_Advec_xint
    figure()
    set(gcf,'Position',[1 227 1311 390])
    clf;
    subplot(1,2,1)
    pcolor(yy/1000,-zz/1000,Um_dPhiX_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Pressure gradient force (west of the trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])
    

    subplot(1,2,2)
    pcolor(yy/1000,-zz/1000,Um_Advec_xint'/length_int);shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);
    plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2)
    hold off;
    colorbar;colormap('redblue');
    caxis([-1 1]/1e3)
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    ylabel('Depth (km)', 'FontSize', fontsize,'interpreter','latex');
    title('Zonal advection (west of the trough), N/m$^3$','FontSize',fontsize+2,'interpreter','latex');
    set(gca,'fontsize',fontsize);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    xlim([0 Ly/1000])

%     print('-dpng','-r180',[figdir 'tavg_5yr_momentum_west_vert.png']);







