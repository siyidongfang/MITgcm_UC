%%%
%%% plot_cast_location.m
%%%
%%% Plot locations of cast with CDW in the Amundsen Sea
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
    
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2022
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2020
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2019
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2016
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2014
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2013


    %%% Load the data
    month_2010 = 3:9;
    month_2013 = 12;
    month_2014 = 1:10;
    month_2016 = 1:2; % months with observations over the Amundsen Sea continental shelf
    month_2019 = 2:11;
    month_2020 = 3:9;
    month_2022 = 2:9;

    FNAME = [];
    for m = 3:9
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20100' num2str(m) '.nc']];
    end
    for m = 12
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.2013' num2str(m) '.nc']];
    end
    for m = 1:9
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20140' num2str(m) '.nc']];
    end
    for m = 10
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.2014' num2str(m) '.nc']];
    end
    for m = 1:2
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20160' num2str(m) '.nc']];
    end
    for m = 2:9
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20190' num2str(m) '.nc']];
    end
    for m =10:11
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.2019' num2str(m) '.nc']];
    end
    for m =3:9
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20200' num2str(m) '.nc']];
    end
    for m =2:9
        %%% Load the data
        FNAME = [FNAME;['EN.4.2.2.f.profiles.g10.20220' num2str(m) '.nc']];
    end

    %%% Amundsen Sea
    lat_max = -65;
    lon_min = -150;
    lon_max = -90;
    

    Nt = size(FNAME,1);
    Nn_max = 866; %%% Max number of profiles with CDW in the Amundsen Sea
    Nz = 400;
    
    lat = NaN.*zeros(Nt,Nn_max);
    lon = NaN.*zeros(Nt,Nn_max);
    time = NaN.*zeros(Nt,Nn_max);
    depth = NaN.*zeros(Nt,Nz,Nn_max);
    temp = NaN.*zeros(Nt,Nz,Nn_max);
    salt = NaN.*zeros(Nt,Nz,Nn_max);
    
    for m = 1:Nt
        %%% Load the data
        m
        ncfname = FNAME(m,:);
        clear LATITUDE LONGITUDE DEPH_CORRECTED TEMP PSAL_CORRECTED JULD
        %%% Load file data
        LATITUDE = ncread(ncfname,'LATITUDE')';
        LONGITUDE = ncread(ncfname,'LONGITUDE')';
        DEPH_CORRECTED = ncread(ncfname,'DEPH_CORRECTED'); %%% corrected depth, m
        TEMP = ncread(ncfname,'TEMP'); %%% temperature in situ t90 scale, degC
        PSAL_CORRECTED = ncread(ncfname,'PSAL_CORRECTED'); %%% corrected practical salinity, unit 1
        JULD = ncread(ncfname,'JULD')'; %%% days since 1950-01-01 00:00:00 utc
        
        %%% Find the profiles in the Amundsen Sea
        idx_Am = [];
        for i=1:length(LATITUDE)
            if(LATITUDE(i)<=lat_max && LONGITUDE(i)>=lon_min && LONGITUDE(i)<=lon_max)
                idx_Am = [idx_Am i];
            end
        end
        lat_Am = LATITUDE(idx_Am);
        lon_Am = LONGITUDE(idx_Am);
        time_Am = JULD(:,idx_Am);
        depth_Am = DEPH_CORRECTED(:,idx_Am);
        temp_Am = TEMP(:,idx_Am);
        salt_Am = PSAL_CORRECTED(:,idx_Am);
    
        %%% Exclude profiles that does not contain CDW (temp >=0 degC)
        idx = [];
        for i=1:length(idx_Am)
            if(sum(temp_Am(:,i)>=0)~=0)
                idx=[idx i];
            end
        end
        N = length(idx);
        if(N>Nn_max)
            error('N > Nprofile_max!!');
        end
        lat(m,1:N) = lat_Am(idx);
        lon(m,1:N) = lon_Am(idx);
        time(m,1:N) = time_Am(:,idx);
        depth(m,:,1:N) = depth_Am(:,idx);
        temp(m,:,1:N) = temp_Am(:,idx);
        salt(m,:,1:N) = salt_Am(:,idx);

    end
    clear LATITUDE LONGITUDE DEPH_CORRECTED TEMP PSAL_CORRECTED JULD
    clear lat_Am lon_Am time_Am depth_Am temp_Am salt_Am idx_Am 

    %%

    %%% Calculate the thickness and mean temperature of the CDW layer
    t_cdw = zeros(Nt,Nn_max); 
    h_cdw = zeros(Nt,Nn_max);

    for m=1:Nt
        m
        for n=1:Nn_max
            clear zidx_warm zidx_cold jump_zidx_warm zidx_cdw Zcdw temp_cdw
            zidx_warm = find(temp(m,:,n)>=0);
            zidx_cold = find(temp(m,:,n)<0);

            if(~isempty(zidx_warm))
                if(sum(diff(zidx_warm)>1)>0)
                    jump_zidx_warm = find(diff(zidx_warm)>1); %%% exclude surface warm water layer
                    zidx_cdw = zidx_warm(jump_zidx_warm(end)+1):zidx_warm(end);
                else
                    zidx_cdw = zidx_warm;
                end
                Zcdw = depth(m,zidx_cdw,n);
                if (Zcdw(end)>150)  %%% exclude surface warm water layer
                    temp_cdw = temp(m,zidx_cdw,n);
                    h_cdw(m,n) = Zcdw(end)-Zcdw(1);
                    t_cdw(m,n) = mean(temp_cdw);
                end
                if(t_cdw(m,n)>35) %%% in some profiles of 2013 and 2014, the temperature is a constant value of larger than 35, which seems to be an error and should be excluded
                    t_cdw(m,n)=0;
                    h_cdw(m,n)=0;
                end
                if(h_cdw(m,n)==0) %%% in some profiles of 2013 and 2014, the temperature is a constant value of larger than 35, which seems to be an error and should be excluded
                    t_cdw(m,n)=0;
                end
                if(h_cdw(m,n)<20) %%% in some profiles of 2013 and 2014, the temperature is a constant value of larger than 35, which seems to be an error and should be excluded
                    t_cdw(m,n)=0;
                    h_cdw(m,n)=0;
                end
                if(zidx_cdw(1)==1)
                    t_cdw(m,n)=0;
                    h_cdw(m,n)=0;
                end
            end
        end
    end

    lat(h_cdw==0)=NaN;
    lon(h_cdw==0)=NaN;
    time(h_cdw==0)=NaN;
    h_cdw(h_cdw==0)=NaN;
    t_cdw(t_cdw==0)=NaN;

    %%

    fontsize = 17;linewidth=2;

    lat_all = lat';
    lat_all = lat_all(:)';
    lon_all = lon';
    lon_all = lon_all(:)';
    t_cdw_all = t_cdw';
    t_cdw_all = t_cdw_all(:)';
    h_cdw_all = h_cdw';
    h_cdw_all = h_cdw_all(:)';

    [t_cdw_sort,I] = sort(t_cdw_all);
    lat_sort_t = lat_all(I);
    lon_sort_t = lon_all(I);

    [h_cdw_sort,J] = sort(h_cdw_all);
    lat_sort_h = lat_all(J);
    lon_sort_h = lon_all(J);


    %%% Save the data
    save('CDWproducts_en4.mat','lat','lon','time','depth','temp','salt', ...
       'h_cdw','h_cdw','t_cdw_sort','lat_sort_t','lon_sort_t','h_cdw_sort','lat_sort_h','lon_sort_h', ...
       'FNAME','month_2010','month_2013','month_2014','month_2016','month_2019','month_2020','month_2022',...
       'lat_max','lon_min','lon_max','Nn_max','Nt','Nz')

%%
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
    freezeColors;
 %%   
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




