%%%
%%% plot_en4.m
%%%
%%% Plot locations of cast in the Amundsen Sea and CDW T/h
%%% https://www.metoffice.gov.uk/hadobs/en4/

%%% TO DO: plot cast locations with shape indicate years and color indicate months
%%% TO DO: Add bathymetric contours to the plot

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

    fontsize = 17;linewidth=2;

 
    figure(1)
    clf;set(gcf,'Color','w')
    load AntarcticCoastline.mat
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
    latlim = [-76 -65];lonlim = [-130 -90];

    subplot(1,3,1)
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    % geoshow(coastlat,coastlon,'DisplayType','polygon')

    lat10 = lat(1:7,:)';lat10=lat10(:)';lon10 = lon(1:7,:)';lon10=lon10(:)';
    mon10 = month_2010'*ones(1,Nn_max);mon10 = mon10';mon10=mon10(:)';
    aa2010 = scatterm(lat10,lon10,20,mon10,".");  
    aa2013 = scatterm(lat(8,:),lon(8,:),20,month_2013*ones(1,Nn_max),".");  
    lat14 = lat(9:18,:)';lat14=lat14(:)';lon14 = lon(9:18,:)';lon14=lon14(:)';
    mon14 = month_2014'*ones(1,Nn_max);mon14 = mon14';mon14=mon14(:)';
    aa2014 = scatterm(lat14,lon14,20,mon14,".");  
    lat16 = lat(19:20,:)';lat16=lat16(:)';lon16 = lon(19:20,:)';lon16=lon16(:)';
    mon16 = month_2016'*ones(1,Nn_max);mon16 = mon16';mon16=mon16(:)';
    aa2016 = scatterm(lat16,lon16,20,mon16,".");  
    lat19 = lat(21:30,:)';lat19=lat19(:)';lon19 = lon(21:30,:)';lon19=lon19(:)';
    mon19 = month_2019'*ones(1,Nn_max);mon19 = mon19';mon19=mon19(:)';
    aa2019 = scatterm(lat19,lon19,20,mon19,".");  
    lat20 = lat(31:37,:)';lat20=lat20(:)';lon20 = lon(31:37,:)';lon20=lon20(:)';
    mon20 = month_2020'*ones(1,Nn_max);mon20 = mon20';mon20=mon20(:)';
    aa2020 = scatterm(lat20,lon20,20,mon20,".");  
    lat22 = lat(38:45,:)';lat22=lat22(:)';lon22 = lon(38:45,:)';lon22=lon22(:)';
    mon22 = month_2022'*ones(1,Nn_max);mon22 = mon22';mon22=mon22(:)';
    aa2022 = scatterm(lat22,lon22,20,mon22,".");  

    % shading interp;
    colormap(WhiteBlueGreenYellowRed(7));
    colorbar;
    clim([1 12])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);
    % freezeColors;
    
    subplot(1,3,2)
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = scatterm(lat_sort_t,lon_sort_t,50,t_cdw_sort,".");  
    shading flat;
    colormap(WhiteBlueGreenYellowRed(0));
    colorbar;
    clim([0 2])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);

    subplot(1,3,3)
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',15);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = scatterm(lat_sort_h,lon_sort_h,50,h_cdw_sort,".");  
    shading flat;
    colormap(WhiteBlueGreenYellowRed(0));
    colorbar;
    clim([0 1500])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);




