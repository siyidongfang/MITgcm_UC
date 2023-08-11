%%%
%%% plot_en4.m
%%%
%%% Plot locations of cast in the Amundsen Sea and CDW T/h
%%% https://www.metoffice.gov.uk/hadobs/en4/


    clear;
    
    addpath /Users/csi/MITgcm_UC/analysis_uc;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;

    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/etopo1/
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/SouthernOceanSSH/
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/

    load('CDWproducts_en4.mat')
    load_colors;

    fontsize = 17;linewidth=2;
    markersize = 5;

    lat10 = lat(1:7,:)';lat10=lat10(:)';lon10 = lon(1:7,:)';lon10=lon10(:)';
    % mon10 = month_2010'*ones(1,Nn_max);
    mon10 = 1*ones(1,length(month_2010))'*ones(1,Nn_max);
    mon10 = mon10';mon10=mon10(:)';

    % mon13 = month_2013*ones(1,Nn_max);
    mon13 = 2*ones(1,Nn_max);

    lat14 = lat(9:18,:)';lat14=lat14(:)';lon14 = lon(9:18,:)';lon14=lon14(:)';
    % mon14 = month_2014'*ones(1,Nn_max);
    mon14 = 3*ones(1,length(month_2014))'*ones(1,Nn_max);
    mon14 = mon14';mon14=mon14(:)';

    lat16 = lat(19:20,:)';lat16=lat16(:)';lon16 = lon(19:20,:)';lon16=lon16(:)';
    % mon16 = month_2016'*ones(1,Nn_max);
    mon16 = 4*ones(1,length(month_2016))'*ones(1,Nn_max);
    mon16 = mon16';mon16=mon16(:)';

    lat19 = lat(21:30,:)';lat19=lat19(:)';lon19 = lon(21:30,:)';lon19=lon19(:)';
    % mon19 = month_2019'*ones(1,Nn_max);
    mon19 = 5*ones(1,length(month_2019))'*ones(1,Nn_max);
    mon19 = mon19';mon19=mon19(:)';

    lat20 = lat(31:37,:)';lat20=lat20(:)';lon20 = lon(31:37,:)';lon20=lon20(:)';
    % mon20 = month_2020'*ones(1,Nn_max);
    mon20 = 6*ones(1,length(month_2020))'*ones(1,Nn_max);
    mon20 = mon20';mon20=mon20(:)';

    lat22 = lat(38:45,:)';lat22=lat22(:)';lon22 = lon(38:45,:)';lon22=lon22(:)';
    % mon22 = month_2022'*ones(1,Nn_max);
    mon22 = 7*ones(1,length(month_2022))'*ones(1,Nn_max);
    mon22 = mon22';mon22=mon22(:)';

    %%% Load bathymetry data
    ncfile = 'ETOPO1_Bed_g_gmt4.grd';
    x = ncread(ncfile,'x');
    y = ncread(ncfile,'y');
    b = ncread(ncfile,'z');
    x = x(3301:5401);
    y = y(871:1501);
    b = b(3301:5401,871:1501);


    %%
    panelsize = [0.24 0.6];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 500]);

    load AntarcticCoastline.mat
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
    latlim = [-76 -65];lonlim = [-125 -90];
    
    %%% Plotting options
    ax2 = subplot('position',[0.38 0.325 panelsize]);
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm off; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    % geoshow(coastlat,coastlon,'DisplayType','polygon')
    levels = [-7000:1000:-1000];
    contourm(y',x,b',levels,'ShowText', 'off','Color',darkgray)
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    aa = scatterm(lat_sort_h,lon_sort_h,50,h_cdw_sort/1000,".");  
    shading interp;
    colormap(WhiteBlueGreenYellowRed(0));
    clim([0 1.2])
    box on;axis tight;set(gca,'FontSize',fontsize);
    title('CDW thickness (EN4)','FontSize',fontsize+3,'FontWeight','normal')
    h2 = colorbar(ax2);
    set(h2,'Position', [0.63 0.35 0.008 0.5]);
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    annotation('textbox',[0.62 0.935 0.15 0.01],'String','(km)','FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.34 0.98 0.15 0.01],'String','h','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

    ax3 = subplot('position',[0.72 0.325 panelsize]);
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm off; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    levels = [-7000:1000:-1000];
    contourm(y',x,b',levels,'ShowText', 'off','Color',darkgray)
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    aa = scatterm(lat_sort_t,lon_sort_t,50,t_cdw_sort,".");  
    shading interp;
    colormap(WhiteBlueGreenYellowRed(0));
    clim([0 2])
    box on;axis tight;set(gca,'FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    title('CDW potential temperature (EN4)','FontSize',fontsize+3,'FontWeight','normal')
    h3 = colorbar;
    set(h3,'Position', [0.97 0.35 0.008 0.5]);
    annotation('textbox',[0.965 0.935 0.15 0.01],'String','(^oC)','FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.68 0.98 0.15 0.01],'String','i','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;

    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig2/';
    print('-dpng','-r300',[figdir 'fig2_en4_cdw.png']);

%%
    figure(2)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 500]);

    ax1 = subplot('position',[0.045 0.325 panelsize]);

    
    load AntarcticCoastline.mat
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
    latlim = [-75.5 -65];lonlim = [-125 -90];
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm off; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    % geoshow(coastlat,coastlon,'DisplayType','polygon')
    colormap(WhiteBlueGreenYellowRed(8));
    clim([0.5 7.5])
    levels = [-7000:1000:-1000];
    contourm(y',x,b',levels,'ShowText', 'off','Color',darkgray)
    hold on;
    % clim([0.5 12.5])
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    aa2010 = scatterm(lat10,lon10,markersize,mon10,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);  
    aa2013 = scatterm(lat(8,:),lon(8,:),markersize,mon13);  
    aa2014 = scatterm(lat14,lon14,markersize,mon14,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);  
    aa2016 = scatterm(lat16,lon16,markersize,mon16,"pentagram",'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);    
    aa2019 = scatterm(lat19,lon19,markersize,mon19,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);    
    aa2020 = scatterm(lat20,lon20,markersize,mon20,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);    
    aa2022 = scatterm(lat22,lon22,markersize,mon22,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);    
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)

    % shading interp;
    h3=colorbar('XTickLabel',{'2010','2013','2014','2016','2019','2020','2022'});
  
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);
    title('Time and location of EN4 profiles','FontSize',fontsize+3,'FontWeight','normal')
    set(h3,'Position', [0.295 0.35 0.008 0.5]);
    annotation('textbox',[0.29 0.935 0.15 0.01],'String','(Year)','FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.005 0.98 0.15 0.01],'String','g','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig2/';
    print('-dpng','-r300',[figdir 'fig2_en4.png']);
   




