    
    clear
    
    addpath /Users/csi/MITgcm_ASF-csi/data_WOA18_etopo;

%     load ss81_winter.mat
%     ss=ss81_winter;
%     load tt81_winter.mat
%     tt=tt81_winter;
% 
%     load ss81_summer.mat
%     ss=ss81_summer;
%     load tt81_summer.mat
%     tt=tt81_summer;

    load ss81_annual.mat
    ss=ss81_annual;
    load tt81_annual.mat
    tt=tt81_annual;
    %% Plot temperature and salinity sections
    
    lon_selected = -103;
    [c LONidx_sec] = min(abs(lon - lon_selected)); 
    lon_sec = lon(LONidx_sec)
    ss_sec = squeeze(ss(LONidx_sec,:,:));
    tt_sec = squeeze(tt(LONidx_sec,:,:));
    
    latS = -71.875;
    % latS = -72.125;
    dlat = 450/111.5;
    latN = latS+dlat;
    
    
    fontsize = 15;
    
    figure(1);
    clf;
    subplot(1,2,1)
    pcolor(lat,depth,ss_sec')
    shading interp;axis ij;
    xlim([latS latN])
    ylim([0 4200])
    colormap(jet)
    colorbar
    caxis([33.6 34.8])
    title('Salinity (psu)',FontSize=fontsize)
    ylabel('Depth (m)')
    xlabel('Latitude')
    set(gca,'FontSize',fontsize)
    
    subplot(1,2,2)
    pcolor(lat,depth,tt_sec')
    shading interp;axis ij;
    xlim([latS latN])
    ylim([0 4200])
    colorbar
    caxis([-2 2])
    title('Potential temperature (^oC)',FontSize=fontsize)
    ylabel('Depth (m)')
    xlabel('Latitude')
    set(gca,'FontSize',fontsize)
    
%     print('-djpeg','-r250','Section_TS_summer.jpeg');
    
    
    
    %% Extract T/S restoring profiles for MITgcm_UC simulations
    
    
    [c latS_idx] = min(abs(lat - latS));
    [c latN_idx] = min(abs(lat - latN));
    
    tsouth_woa = tt_sec(latS_idx,:);
    ssouth_woa = ss_sec(latS_idx,:);
    
    Ndepth_south = find(isnan(tsouth_woa),1)-1;
    
    tnorth_woa = tt_sec(latN_idx,:);
    snorth_woa = ss_sec(latN_idx,:);
    
    tsouth_woa_smooth = smoothdata([tsouth_woa(1:Ndepth_south)],'movmedian');
    ssouth_woa_smooth = smoothdata(ssouth_woa(1:Ndepth_south),'movmedian');
    
    tnorth_woa_smooth = smoothdata(tnorth_woa,'movmedian');
    snorth_woa_smooth = smoothdata(snorth_woa,'movmedian');
    
    
    figure(3)
    clf
    subplot(1,2,1)
    plot(tnorth_woa,depth)
    hold on;
    plot(tnorth_woa_smooth,depth,'b','LineWidth',1.5)
    plot(tsouth_woa,depth)
    plot(tsouth_woa_smooth,depth(1:Ndepth_south),'r','LineWidth',1.5)
    axis ij;
    title('Restoring temperature (^oC)',FontSize=fontsize)
    legend('Northern T','Northern T (smoothed)','Southern T','Southern T (smoothed)')
    ylabel('Depth (m)')
    ylim([0 5000])
    set(gca,'FontSize',fontsize)
    
    subplot(1,2,2)
    plot(snorth_woa,depth)
    hold on;
    plot(snorth_woa_smooth,depth,'b','LineWidth',1.5)
    plot(ssouth_woa,depth)
    plot(ssouth_woa_smooth,depth(1:Ndepth_south),'r','LineWidth',1.5)
    axis ij;
    title('Restoring salinity (psu)',FontSize=fontsize)
    legend('Northern S','Northern S (smoothed)','Southern S','Southern S (smoothed)')
    ylabel('Depth (m)')
    ylim([0 5000])
    set(gca,'FontSize',fontsize)
    
%     print('-djpeg','-r250','Restoring_TS_summer.jpeg');
    
    
%     save('WOA81summer_Lon103W_LatS71.875S.mat','depth','latS','latN','lon_sec','Ndepth_south',...
%         'tnorth_woa_smooth','tsouth_woa_smooth','snorth_woa_smooth','ssouth_woa_smooth');
  
    
    

