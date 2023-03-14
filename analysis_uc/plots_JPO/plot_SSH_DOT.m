

    clear;close all;


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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% SEA SURFACE HEIGHT FIGURE %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/etopo1/
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/SouthernOceanSSH/
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/
    %%% Load data
    load AntarcticCoastline.mat
    load DOT_climatology_2014-2016.mat

    %%%%%%%%%%% Load the coastline
    load coastlines
    % worldmap('antarctica')
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});





    %%

    LAT = double(Latitude);
    LON = double(Longitude);



    %%% Find the Amundsen Sea region
    LON(LON>-60)=NaN;
    LAT(isnan(LON))=NaN;
    DOT_clim(isnan(LON))=NaN;

    scatter_lat = LAT(isnan(DOT_clim));
    scatter_lon = LON(isnan(DOT_clim));

    %%

   
    figure(1)
    clf
    set(gca,'Color','w')
    
    %%% Make the plot
    % [im, map, alpha] = imread('arrows.png');
    % f = imshow(im);
    % set(f, 'AlphaData', alpha);
    hold on;


    axis off;
%     axesm('eqdconic','FLonLimit',[-180 -60],'FLatLimit',[-90 -65],'FontSize',fontsize)
    axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -65],'FontSize',fontsize)
%     framem on;
%     gridm on;
    mlabel on;
    plabel on;

    setm(gca,'MLabelParallel','north') 
    setm(gca,'PLabelLocation',[-80:10:-60]);
    setm(gca,'PLineLocation',[-80:10:-60]);
    setm(gca,'MLineLocation',[-180:30:180]);
    setm(gca,'MLabelLocation',[-180:30:180]);
    % DOT_clim(isnan(DOT_clim))=0;
    aa = pcolorm(LAT,LON,double(DOT_clim)/100);  
    shading interp;
    setm(gca,'MapProjection','eqdconic')
%     GRAY_NAN = scatterm(scatter_lat,scatter_lon,15,'filled','MarkerFaceColor',[0.93 0.93 0.93]);       
    % hold on;
%     bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
%     coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
%     patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;
    % col4 = colormap(ax4,'haxby');
    % col4=flipud(cmocean('tarn',256));
    % colormap(ax4,col4(1:end,:));
%     colormap(flipud(WhiteBlueGreenYellowRed(1)));
    % colormap(ax4,flipud(cmocean('rain',100)));
    colormap(redblue)


    clim([-1.95 -1.75])
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

%     leghandle = legend([bathyhandle],{'1000m depth contour'},...
%         'interpreter','latex','orientation','horizontal');
%     set(leghandle,'FontSize',fontsize+2);
%     set(leghandle,'Position',legpos);
%     legend boxon;

