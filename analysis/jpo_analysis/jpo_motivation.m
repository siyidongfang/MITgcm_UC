    %%%
    %%% plotAtmIceOcean.m
    %%%
    %%% Creates plots of winds, ice drift and SSH for a presentation at AGU
    %%% 2018.
    %%%

    clear all;close all;

    addpath /home/csi/research/code;
    addpath /home/csi/research/CATS2008/TMD;
    addpath /home/csi/research/CATS2008/TMD/DATA;
    addpath /data/MITgcm_ASF-csi/analysis/colormaps;
    addpath /data/MITgcm_ASF-csi/analysis/colormaps/customcolormap

    %%% Initialize figure
    figure(1);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 1000 1000]);
    set(gcf,'Color','w');
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});


    %%% Plotting options
    fontsize = 12;
    framepos = [45           1        700         600];
    cbpos = [0.85 0.06 0.01 0.16];
    legpos = [0.4 0.01 0.2 0.03];
    linewidth = 1.5;
    latMin = -90;
    latMax = -55;
    lonMin = 0;
    lonMax = 360;
    boxcolor = [225 225 225]/255;


    topog = ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','HGT');
    lat_topog = double(ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','g5_lat_0'));
    lon_topog = double(ncread('/home/csi/research/PolarWRF/MonthlyData/AMPS_WRF_d2_HGT_sfc.nc','g5_lon_1'));
    topog(topog==0)=NaN;
    topog(~isnan(topog))=0;
    %%
    %%%%%%%%%%%%%%%%%%%%%%%
    %%%%% WIND FIGURE %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%

    %%% Load data
    load /home/csi/research/PolarWRF/AMPS_winds.mat
%%%%%%%%%%% Load the data for 1000m depth contour
    load /home/csi/research/etopo1/AntarcticCoastline.mat
    % months = [1 2 3 4 5 6 7 8 9 10 11 12];
    months = [6 7 8];
    % months=[7];
    zonal_winds_AMPS = nanmean(zonal_winds_AMPS(:,:,months,2:end-1),4);
    merid_winds_AMPS = nanmean(merid_winds_AMPS(:,:,months,2:end-1),4);
    zonal_winds_AMPS = squeeze(nanmean(zonal_winds_AMPS,3));
    merid_winds_AMPS = squeeze(nanmean(merid_winds_AMPS,3));
    [LA,LO] = meshgrid(ERA_lat,ERA_lon);

%%%%%%%%%%% Load the coastline: start here
    load coastlines
    % worldmap('antarctica')
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
%%%%%%%%%%% Load the coastline: end here

    %% Make the plot
    clf;
    ax1 = subplot('position',[0.01 0.5 0.45 0.45]);
    annotation('textbox',[0.01 0.915 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    set(gca,'Color','w')
    axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
            worldmap('antarctica')
%     worldmap([-90 -55],[0 360])
    axis off;
    framem on;
    gridm on;
    mlabel on;
    plabel on;
    set(gca,'FontSize',fontsize);
    setm(gca,'MLabelParallel','north') 
    setm(gca,'PLabelLocation',[-80:10:-60]);
    setm(gca,'PLineLocation',[-80:10:-60]);
    setm(gca,'MLineLocation',[-180:30:180]);
    setm(gca,'MLabelLocation',[-180:30:180]);
    pcolorm(double(LA),double(LO),double(zonal_winds_AMPS'));        
    shading interp;
    % colormap(ax1,cmocean('balance',100));
    % colormap(ax1,cmocean('tarn',100));
    % colormap(ax1,cmocean('tarn'));
    % colormap(ax1,whitejet)
    colormap(ax1,mycolormap);
    caxis([-10 10])
    hold on

%%%%%%%%%%% Plot the 1000m depth contour
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--'); 

%%%%%%%%%%% Plot the coastline
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
%%%%%%%%%%% Fill in area of continents with light gray
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;

    handle = title({'Winter zonal wind speed (m/s)'},'FontSize',fontsize+3,'interpreter','latex'); % '2007-2014' 'Antarctic Mesoscale Prediction System'
    set(handle,'Position',[0 0.75 0]);

    %%% Add colorbar
    handle = colorbar;
    set(handle,'Position',[0.45 0.67 0.01 0.16]);


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% Tidal Current Amplitude  %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    load /home/csi/research/etopo1/AntarcticCoastline.mat
    load('/home/csi/research/CATS2008/TidalAmplitude_365days_lores.mat','lon','lat','meanspeed_tide')

    % scatter_lat_tide = lat(isnan(meanspeed_tide));
    % scatter_lon_tide = lon(isnan(meanspeed_tide));

    latlim = -90:0.5:-55.5;
    lonlim = 0:0.5:360;

    [lon_tide lat_tide] =  meshgrid(lonlim,latlim);

    scatter_lon_tide = lon_tide(:);
    scatter_lat_tide = lat_tide(:);

    meanspeed_tide = log10(meanspeed_tide);


    ax2 = subplot('position',[0.5 0.5 0.45 0.45]);
    annotation('textbox',[0.5 0.915 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    set(gca,'Color','w')
    axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
    axis off;
    framem on;
    gridm on;
    mlabel on;
    plabel on;
    setm(gca,'MLabelParallel','north') 
    setm(gca,'PLabelLocation',[-80:10:-60]);
    setm(gca,'PLineLocation',[-80:10:-60]);
    setm(gca,'MLineLocation',[-180:30:180]);
    setm(gca,'MLabelLocation',[-180:30:180]);
    scatterm(scatter_lat_tide,scatter_lon_tide,40,'filled','MarkerFaceColor',[0.95 0.95 0.95]);   

    hold on;
    pcolorm(lat,lon,meanspeed_tide);        
    shading interp;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    colormap(ax2,WhiteBlueGreenYellowRed(0));
    % colormap(ax2,cmocean('rain',100));
    % colormap(ax2,whitejet)


    caxis([-1 2])
    % caxis([0 100])
    set(gca,'ColorScale','linear')
    set(gca,'FontSize',fontsize);
    handle = title({'Mean tidal current speed (cm/s)'},'FontSize',fontsize+3,'interpreter','latex');
    set(handle,'Position',[0 0.75 0]);

    %%% Add colorbar
    handle = colorbar('XTickLabel',{'0.1','0.3','1.0','3.2','10','32','100'}, ...
                   'XTick', -1:0.5:2);
    set(handle,'Position',[0.94 0.67 0.01 0.16]);


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% ICE DRIFT FIGURE %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load data
    load /home/csi/research/etopo1/AntarcticCoastline.mat
    load /home/csi/research/NSIDC_icemotion/IceDriftClim_JJA.mat
    dlon_dchi = 0*LO;
    dlon_dchi(2:end-1,:) = (LO(3:end,:)-LO(1:end-2,:)) / d;
    dlon_dchi([1 end],:) = dlon_dchi([2 end-1],:);
    dlon_dxi = 0*LO;
    dlon_dxi(:,2:end-1) = (LO(:,3:end)-LO(:,1:end-2)) / d;
    dlon_dxi(:,[1 end]) = dlon_dchi(:,[2 end-1]);
    grad_lon = sqrt(dlon_dchi.^2 + dlon_dxi.^2);
    cosalpha = dlon_dchi ./ grad_lon;
    sinalpha = dlon_dxi ./ grad_lon;
    u_zonal = u_avg .* cosalpha + v_avg .* sinalpha;

    %%% Plotting options
    lonMin = -180;
    lonMax = 180;


    LAT_ice = double(LA);
    LON_ice = double(LO);
    scatter_lat_ice = LAT_ice(isnan(u_zonal));
    scatter_lon_ice = LON_ice(isnan(u_zonal));


    %%% Make the plot

    ax3 = subplot('position',[0.01 0.03 0.45 0.45]);
    annotation('textbox',[0.01 0.445 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    set(gca,'Color','w')
    axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
    axis off;
    framem on;
    gridm on;
    mlabel on;
    plabel on;
    setm(gca,'MLabelParallel','north') 
    setm(gca,'PLabelLocation',[-80:10:-60]);
    setm(gca,'PLineLocation',[-80:10:-60]);
    setm(gca,'MLineLocation',[-180:30:180]);
    setm(gca,'MLabelLocation',[-180:30:180]);
    pcolorm(double(LA),double(LO),double(u_zonal/10));        
    shading interp;
    hold on;
    GRAY_NAN = scatterm(scatter_lat_ice,scatter_lon_ice,15,'filled','MarkerFaceColor',[0.95 0.95 0.95]);       
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)

    hold off;
    colormap(ax3,cmocean('balance',100));
    % colormap(ax3,cmocean('tarn',100));

    caxis([-5 5])
    set(gca,'FontSize',fontsize);
    handle = title({'Winter zonal ice drift speed (cm/s)'},'FontSize',fontsize+3,'interpreter','latex');
    % 1979-2015 ,'NASA Pathfinder'
    set(handle,'Position',[0 0.75 0]);

    %%% Add colorbar
    handle = colorbar;
    set(handle,'Position',[0.45 0.17 0.01 0.16]);


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% SEA SURFACE HEIGHT FIGURE %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Load data
    load /home/csi/research/etopo1/AntarcticCoastline.mat
    load /home/csi/research/SouthernOceanSSH/DOT_climatology_JJA.mat


    %%% Make the plot
    ax4 = subplot('position',[0.5 0.03 0.45 0.45]);
    annotation('textbox',[0.5 0.445 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    % [im, map, alpha] = imread('arrows.png');
    % f = imshow(im);
    % set(f, 'AlphaData', alpha);

    LAT = double(Latitude);
    LON = double(Longitude);
    scatter_lat = LAT(isnan(DOT_clim));
    scatter_lon = LON(isnan(DOT_clim));

    hold on;
    % set(gca,'Color','w')
    set(gca,'Color',[225 225 225]/255);

    axis off;
    axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -55],'FontSize',fontsize)
    framem on;
    gridm on;
    mlabel on;
    plabel on;

    setm(gca,'MLabelParallel','north') 
    setm(gca,'PLabelLocation',[-80:10:-60]);
    setm(gca,'PLineLocation',[-80:10:-60]);
    setm(gca,'MLineLocation',[-180:30:180]);
    setm(gca,'MLabelLocation',[-180:30:180]);
    % DOT_clim(isnan(DOT_clim))=0;
    aa = pcolorm(LAT,LON,double(DOT_clim));        
    shading interp;
    GRAY_NAN = scatterm(scatter_lat,scatter_lon,15,'filled','MarkerFaceColor',[0.93 0.93 0.93]);       
    % hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    % col4 = colormap(ax4,'haxby');
    % col4=flipud(cmocean('tarn',256));
    % colormap(ax4,col4(1:end,:));
    colormap(ax4,flipud(WhiteBlueGreenYellowRed(1)));
    % colormap(ax4,flipud(cmocean('rain',100)));


    % caxis([-200 -165])
    caxis([-215 -165])
    set(gca,'FontSize',fontsize);
    handle = title({'Winter sea surface elevation (cm)'},'FontSize',fontsize+3,'interpreter','latex');
    % 2011-2016 ,'Armitage et al. (2018)' ,'and geostrophic currents (cm/s)
    set(handle,'Position',[0 0.75 0]);

    %%% Add colorbar
    handle = colorbar;
    set(handle,'Position',[0.94 0.17 0.01 0.16]);

    %%% Add legend
    % leghandle = legend([coasthandle,bathyhandle],{'Coastline','1000m depth contour'},...
    %     'interpreter','latex','orientation','horizontal');
    % set(leghandle,'FontSize',fontsize+2);
    % set(leghandle,'Position',legpos);
    % legend boxon;

    leghandle = legend([bathyhandle],{'1000m depth contour'},...
        'interpreter','latex','orientation','horizontal');
    set(leghandle,'FontSize',fontsize+2);
    set(leghandle,'Position',legpos);
    legend boxon;



    %% Write to file
%     print('-dpng','-r150','jpo_motivation_new3.png');
    % print('-dpng','-r150','test.png');

    % saveas(gcf,'jpo_motivation','epsc');