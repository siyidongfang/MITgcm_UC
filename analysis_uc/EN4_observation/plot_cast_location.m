%%%
%%% plot_cast_location.m
%%%
%%% Plot locations of cast with CDW in the Amundsen Sea

    clear;
    
    addpath /Users/csi/MITgcm_UC/analysis_uc;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/etopo1/
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/SouthernOceanSSH/
    
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2022
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2020
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2019
    addpath /Users/csi/MITgcm_UC/analysis_uc/EN4_observation/EN.4.2.2.profiles.g10.2016
    

    %%% Load the data
    month_2016 = 1:2; % months with observations over the Amundsen Sea continental shelf
    month_2019 = 2:11;
    month_2020 = 3:9;
    month_2022 = 2:9;

    FNAME = [];
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
    Nn_max = 411; %%% Max number of profiles with CDW in the Amundsen Sea
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
                    zidx_cdw = jump_zidx_warm(end)+1:zidx_warm(end);
                else
                    zidx_cdw = zidx_warm;
                end
                Zcdw = depth(m,zidx_cdw,n);
                if (Zcdw(end)>150)  %%% exclude surface warm water layer
                    temp_cdw = temp(m,zidx_cdw,n);
                    h_cdw(m,n) = Zcdw(end)-Zcdw(1);
                    t_cdw(m,n) = mean(temp_cdw);
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

    figure(1)
    clf;set(gcf,'Color','w')
    load AntarcticCoastline.mat
    load coastlines
    antarctica = shaperead('landareas', 'UseGeoCoords', true,...
      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
    latlim = [-78 -65];lonlim = [181 -65];
    subplot(2,1,1)
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',30);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = scatterm(lat_all,lon_all,30,t_cdw_all,".");  
    shading interp;
    colormap(WhiteBlueGreenYellowRed(0));
    colorbar;
    clim([0 2])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);

    subplot(2,1,2)
    axesm('mercator','MapLatLimit',latlim,'MapLonLimit',lonlim)
    axis on; framem on; gridm on; mlabel on; plabel on;
    setm(gca,'MLabelLocation',30);setm(gca,'PLabelLocation',3);
    setm(gca,'MLabelParallel',-77.2);setm(gca,'FontSize',fontsize-1);
    geoshow(coastlat,coastlon,'DisplayType','polygon')
    aa = scatterm(lat_all,lon_all,30,h_cdw_all,".");  
    shading interp;
    colormap(WhiteBlueGreenYellowRed(0));
    colorbar;
    clim([0 500])
    hold on;
    bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',linewidth,'LineStyle','--');
    coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',linewidth-1,'LineStyle','-');
    patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
    hold off;box on;axis tight;set(gca,'FontSize',fontsize);




