 
%%%
%%% Construct eastern boundary restoring T/S/u for MITgcm_UC simulations
%%%

    clear
    addpath /Users/csi/MITgcm_ASF-csi/data_WOA18_etopo;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    
    load ss81_winter.mat  %%% Australian summer!!
    ss=ss81_winter;
    load tt81_winter.mat
    tt=tt81_winter;

    lon_selected = -103;
    [c LONidx_sec] = min(abs(lon - lon_selected)); 
    lon_sec = lon(LONidx_sec);
    latS = -72.125;
    %     dlat = 450/111.5;
    %     latN = latS+dlat;
    latN = -69.875
    lat_sec = (latS+latN)/2;

    %%% Extract temperature and salinity sections
    ss_sec = squeeze(ss(LONidx_sec,:,:)); 
    tt_sec = squeeze(tt(LONidx_sec,:,:));

    %%% Calculat neutral density of that section
    p_grid = repmat(reshape(depth,[1 length(depth)]),[size(ss_sec,1) 1]);
    SA = ss_sec; %%% Double-check: the unit of ss in WOA 18 is 10^{-3}, is this SA (g/kg) or SP (psu)? I assume this is SA.
    [SP, in_ocean] = gsw_SP_from_SA(SA,p_grid,lon_sec,lat_sec);
    T_insitu = gsw_t_from_pt0(SA,tt_sec,p_grid);
    gamma_n = eos80_legacy_gamma_n(SP,T_insitu,p_grid,lon_sec,lat_sec);

    %%% Extract T/S restoring profiles for MITgcm_UC simulations
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


    %     %%% Subtract 0.6 psu from ssouth_woa_smooth, to make the shelf fresher
    %     %%% Calculate the neutral density again






    %%% Make plots
    fontsize = 15;
   
    figure(1);
    clf;
    subplot(2,4,1)
    pcolor(lat,depth,ss_sec')
    hold on;
    [M,c] = contour(lat,depth,gamma_n',[27.5:0.05:28.2],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',300);
    hold off
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
    
    subplot(2,4,2)
    pcolor(lat,depth,tt_sec')
    hold on;
    [M,c] = contour(lat,depth,gamma_n',[27.5:0.05:28.2],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',300);
    hold off
    shading interp;axis ij;
    xlim([latS latN])
    ylim([0 4200])
    colorbar
    caxis([-2 2])
    title('Potential temperature (^oC)',FontSize=fontsize)
    ylabel('Depth (m)')
    xlabel('Latitude')
    set(gca,'FontSize',fontsize)

    subplot(2,4,3)
    pcolor(lat,depth,gamma_n')
    hold on;
    [M,c] = contour(lat,depth,gamma_n',[27.5:0.05:28.2],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',300);
    hold off
    shading interp;axis ij;
    xlim([latS latN])
    ylim([0 4200])
    colorbar
    caxis([27 28.1])
    title('Neutral density (kg/m^3)',FontSize=fontsize)
    ylabel('Depth (m)')
    xlabel('Latitude')
    set(gca,'FontSize',fontsize)


    subplot(2,4,5)
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
    
    subplot(2,4,6)
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
    
    subplot(2,4,7)
    sdiff = snorth_woa_smooth(1:Ndepth_south)-ssouth_woa_smooth;
    plot(sdiff,depth(1:Ndepth_south),'r','LineWidth',1.5)
    axis ij;
    title('Offshore salinity difference (psu)',FontSize=fontsize)
    ylabel('Depth (m)')
    ylim([0 5000])
    set(gca,'FontSize',fontsize)

    subplot(2,4,8)
    rho_diff = gamma_n(latN_idx,:)-gamma_n(latS_idx,:);
    plot(rho_diff,depth,'r','LineWidth',1.5)
    axis ij;
    title('Offshore density difference (kg/m^3)',FontSize=fontsize)
    ylabel('Depth (m)')
    ylim([0 5000])
    set(gca,'FontSize',fontsize)


    dz = diff(depth)';
    for i = 1:(latN_idx-latS_idx)
        rho_diff_i = gamma_n(latS_idx+i,:)-gamma_n(latS_idx,:);
        rho_diff_max(i) = max(rho_diff_i);
        rho_diff_mean(i) = sum(rho_diff_i(1:Ndepth_south).*dz(1:Ndepth_south))/sum(dz(1:Ndepth_south));
    end

    %%% Save plots and data
%         print('-djpeg','-r250','Restoring_TS_summer.jpeg');
        

clear p_grid

ss_woa = ss_sec(latS_idx:latN_idx,:)';
tt_woa = tt_sec(latS_idx:latN_idx,:)';
y_woa = (lat(latS_idx:latN_idx)'-lat(latS_idx))*111.5*1000;

Ly = 450*1000;
y_new = [0 ((lat(latS_idx+1:latN_idx-1)'-lat(latS_idx))*111.5+60)*1000 Ly];
[y_grid,p_grid] = meshgrid(y_new,depth);

ss_new = zeros(size(ss_woa));
tt_new = zeros(size(tt_woa));
for jjj = 1:length(y_woa)
    idx = find(~isnan(ss_woa(:,jjj)),1,'last');
    ss_new(1:idx-1,jjj) = ss_woa(1:idx-1,jjj);
    ss_new(end,jjj) = ss_woa(idx,jjj);
    tt_new(1:idx-1,jjj) = tt_woa(1:idx-1,jjj);
    tt_new(end,jjj) = tt_woa(idx,jjj);

    dN = length(depth)-idx+1;
    diff_s = ss_woa(idx,jjj)-ss_woa(idx-1,jjj);
    ss_new(idx:end-1,jjj) = ss_woa(idx-1,jjj) + diff_s/dN*[1:dN-1]; %%% 1D Linear Interpolation
    diff_t = tt_woa(idx,jjj)-tt_woa(idx-1,jjj);
    tt_new(idx:end-1,jjj) = tt_woa(idx-1,jjj) + diff_t/dN*[1:dN-1]; %%% 1D Linear Interpolation
end

        save('WOA81summer_Lon103W_LatS72.125S_latN69.875S.mat','depth','latS','latN','lon_sec','lat_sec','Ndepth_south',...
            'ss_woa','tt_woa','y_woa','latS_idx','latN_idx',...
            'ss_new','tt_new','y_grid','p_grid','y_new',...
            'tnorth_woa_smooth','tsouth_woa_smooth','snorth_woa_smooth','ssouth_woa_smooth');

    





    

