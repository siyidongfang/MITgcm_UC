%%%
%%% fig2.m
%%%
%%% Model evaluation -- CDW and SSH
%%%

   clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;


    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1};
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne};
    loadexp;
    load_data;
    load_spacing;

    load([prodir expname '_vorticity_cdw.mat'])

    fontsize = 17;
    YLIM = [0 400];

    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;

    %%

    panelsize2 = [0.24 0.45];
    panelsize1 = [0.24 0.3];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 500]);

    %%% Plotting options
    ax4 = subplot('position',[0.045 0.1 panelsize2]);
    eta(eta==0)=NaN;
    eta (SHIfwFlx~=0)=NaN;
    pcolor(xx/1000,yy/1000,eta');
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([-0.08 0.08]);
    h4 = colorbar(ax4);
    set(h4,'Position',[0.295 0.12 0.008 0.38]);
    text(ax4,315,390,{'(m)'},'FontSize',fontsize)
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    title('Sea surface height','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax4,-294,25,{'(d)'},'FontSize',fontsize+2)
    annotation('textbox',[0.005 0.605 0.15 0.01],'String','d','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;

    
    ax5 = subplot('position',[0.38 0.1 panelsize2]);
    pcolor(xxf/1000,yyf/1000,Hcdw_tgridf'/1000);
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;
    svx = 8; svy = 6;
    UU_cdwf(YY/1000>250)=NaN;
    VV_cdwf(YY/1000>250)=NaN;
    curr = quiver(xxf(1:svx:end)'/1000,yyf(1:svy:end)'/1000, ...
    UU_cdwf(1:svx:end,1:svy:end)',VV_cdwf(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1;
    set(curr,'AutoScale','on', 'AutoScaleFactor', 2.5,'Color',[0.4 0.4 0.4])
    hold off;
    % clim([0 3]); 
    clim([0.2 0.6]);
    colormap(WhiteBlueGreenYellowRed(0));
    h5 = colorbar(ax5);
    set(h5,'Position',[0.63 0.12 0.008 0.38]);
    text(ax5,315,390,{'(km)'},'FontSize',fontsize)
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    title('CDW thickness','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax5,-294,25,{'(e)'},'FontSize',fontsize+2)
    annotation('textbox',[0.34 0.605 0.15 0.01],'String','e','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;


    ax6 = subplot('position',[0.72 0.1 panelsize2]);
    pcolor(xxf/1000,yyf/1000,tt_cdwf')
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],':','LineWidth',1,'ShowText','on','Color',black);% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'--','LineWidth',0.5,'ShowText','on','Color',black);% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],':','LineWidth',1,'ShowText','on','Color',black);% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;
    svx = 8; svy = 6;
    UU_cdwf(YY/1000>250)=NaN;
    VV_cdwf(YY/1000>250)=NaN;
    curr = quiver(xxf(1:svx:end)'/1000,yyf(1:svy:end)'/1000, ...
    UU_cdwf(1:svx:end,1:svy:end)',VV_cdwf(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1;
    set(curr,'AutoScale','on', 'AutoScaleFactor', 2.5,'Color',[0.4 0.4 0.4])
    hold off;
    clim([0 2]);
    h6 = colorbar(ax6);
    set(h6,'Position',[0.97 0.12 0.008 0.38]);
    text(ax6,315,394,{'(^oC)'},'FontSize',fontsize)
    title('CDW potential temperature','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    % text(ax6,-294,25,{'(f)'},'FontSize',fontsize+2)
    annotation('textbox',[0.68 0.605 0.15 0.01],'String','f','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;

%%

    ax1 = subplot('position',[0.045 0.65 panelsize1]);

    linewidth = 1.5;

    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/etopo1/
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/SouthernOceanSSH/
    %%% Load data
    load AntarcticCoastline.mat
    load DOT_climatology_2011-2013.mat
    %%%%%%%%%%% Load the coastline
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});

    %%% Find the Amundsen Sea region
    LAT = double(Latitude);
    LON = double(Longitude);

    latlim = [-78 -65];
    lonlim = [181 -65];
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; 
    framem on; 
    gridm on; 
    mlabel on; 
    plabel on;
    setm(gca,'MLabelLocation',30)
    setm(gca,'PLabelLocation',3)
    setm(gca,'MLabelParallel',-77.2)
    setm(gca,'FontSize',fontsize-1)
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = pcolorm(LAT,LON,double(DOT_clim)/100);  
    shading interp;
    colormap(cmocean('balance'));
    clim([-2.15 -1.55])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    box on;
    axis tight
    set(gca,'FontSize',fontsize);
    title('Dynamic ocean topography','FontSize',fontsize+3,'FontWeight','normal')
    h1 = colorbar;
    set(h1,'Position', [0.295 0.673 0.008 0.21]);
    annotation('textbox',[0.288 0.93 0.15 0.01],'String','(m)','FontSize',fontsize,'LineStyle','None');
    % textm(-77,-178,{'(a)'},'FontSize',fontsize+2)
    annotation('textbox',[0.005 0.98 0.15 0.01],'String','a','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;


    %%
    ax2 = subplot('position',[0.38 0.65 panelsize1]);

    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/WOA/
    load('tt91_annual_cdw.mat')

    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; 
    framem on; 
    gridm on; 
    mlabel on; 
    plabel on;
    setm(gca,'MLabelLocation',30)
    setm(gca,'PLabelLocation',3)
    setm(gca,'MLabelParallel',-77.2)
    setm(gca,'FontSize',fontsize-1)
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = pcolorm(LAT_woa,LON_woa,hh_cdw_woa/1000);  
    shading interp;
    colormap(WhiteBlueGreenYellowRed(0));
    clim([0 5])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    box on;
    axis tight
    set(gca,'FontSize',fontsize);
    title('CDW thickness','FontSize',fontsize+3,'FontWeight','normal')
    h2 = colorbar;
    set(h2,'Position', [0.63 0.673 0.008 0.21]);
    annotation('textbox',[0.625 0.93 0.15 0.01],'String','(km)','FontSize',fontsize,'LineStyle','None');
    % textm(-77,-178,{'(b)'},'FontSize',fontsize+2)
    annotation('textbox',[0.34 0.98 0.15 0.01],'String','b','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;



    ax3 = subplot('position',[0.72 0.65 panelsize1]);
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; 
    framem on; 
    gridm on; 
    mlabel on; 
    plabel on;
    setm(gca,'MLabelLocation',30)
    setm(gca,'PLabelLocation',3)
    setm(gca,'MLabelParallel',-77.2)
    setm(gca,'FontSize',fontsize-1)
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = pcolorm(LAT_woa,LON_woa,tt_cdw_woa);  
    shading interp;
    clim([0 2])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    box on;
    axis tight
    set(gca,'FontSize',fontsize);
    title('CDW potential temperature','FontSize',fontsize+3,'FontWeight','normal')
    h3 = colorbar;
    set(h3,'Position', [0.97 0.673 0.008 0.21]);
    annotation('textbox',[0.965 0.935 0.15 0.01],'String','(^oC)','FontSize',fontsize,'LineStyle','None');
    % textm(-77,-178,{'(c)'},'FontSize',fontsize+2)
    annotation('textbox',[0.68 0.98 0.15 0.01],'String','c','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    freezeColors;





    %%
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig2/';
    print('-dpng','-r300',[figdir 'fig2_matlab.png']);
%     print('-dpng','-r300',[figdir 'fig2_colorbar.png']);





