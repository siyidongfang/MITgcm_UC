

    %%% Calculate potential density with a surface reference pressure 0
    lon_sec = -115;
    lat_sec = -71;
    SA = zeros(length(xidx),length(yidx),Nr);
    CT = zeros(length(xidx),length(yidx),Nr);
    pd_slope = zeros(length(xidx),length(yidx),Nr);
    pd_xmean = zeros(length(yidx),Nr);

    dudz = zeros(length(xidx),length(yidx)-1,Nr);
    ug   = zeros(length(xidx),length(yidx)-1,Nr);
    hFAC = zeros(length(xidx),length(yidx)-1,Nr);

    ss_nan = ss;
    tt_nan = tt;
    ss_nan(ss==0)=NaN;
    tt_nan(tt==0)=NaN;

    [ZZ_slope,YY_slope] = meshgrid(zz,yy(yidx));
    for ii = 1:length(xidx)
        [SA(ii,:,:), in_ocean] = gsw_SA_from_SP(squeeze(ss_nan(xidx(1)+ii-1,yidx,:)),-ZZ_slope,lon_sec,lat_sec);
        CT(ii,:,:) = gsw_CT_from_pt(squeeze(SA(ii,:,:)),squeeze(tt_nan(xidx(1)+ii-1,yidx,:)));
        pd_slope(ii,:,:) = gsw_rho(squeeze(SA(ii,:,:)),squeeze(CT(ii,:,:)),0);
    end
    
    %%% Calculate zonal mean potential density
    pd_slope(pd_slope==0)=NaN;
    pd_xmean= squeeze(mean(pd_slope,'omitnan'));

%     if(savefigure)
%     figure(1)
%     pcolor(yy(yidx)/1000,-zz/1000,pd_xmean');shading flat;colorbar;colormap;colormap(jet);caxis([1027 1027.9]);axis ij;ylim([0 2.5])
%     hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
%     title('Potential density (kg/m^3)');ylabel('Depth (km)');xlabel('y (km)')
%     set(gca,'FontSize',fontsize);
%     set(gcf,'color','w');
%     end


    dudz = gravity/rhoConst/f0*diff(pd_slope,1,2)/dy; %%% on v-grid
    dudz_xmean = squeeze(mean(dudz,'omitnan'));

    DZ_slope = repmat(reshape(delR,[1 1 Nr]),[length(xidx) length(yidx)-1 1]);
    hFAC = hFacS(xidx,yidx(2:end),:);
    ug = cumsum(dudz.*DZ_slope.*hFAC,3,'reverse','omitnan');  %%% on v-grid

    
    ug(ug==0)=NaN;
    ug_xmean = squeeze(mean(ug,'omitnan'));
    
%     if(savefigure)
%     figure(2)
%     pcolor(yy(yidx(2:end))/1000,-zz/1000,dudz_xmean');shading flat;colorbar;colormap;colormap(redblue);caxis([-1 1]/1e4);axis ij;ylim([0 2.5])
%     hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
%     title('Thermal-wind shear (s^{-1})');ylabel('Depth (km)');xlabel('y (km)')
%     set(gca,'FontSize',fontsize);
%     set(gcf,'color','w');
% 
%     figure(3)
%     pcolor(yy(yidx(2:end))/1000,-zz/1000,ug_xmean');shading flat;colorbar;colormap;colormap(redblue);caxis([-0.05 0.05]);axis ij;ylim([0 2.5])
%     hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
%     title('Geostrophic velocity u_g (m/s)');ylabel('Depth (km)');xlabel('y (km)')
%     set(gca,'FontSize',fontsize);
%     set(gcf,'color','w');
%     end


    ug_east = ug;
    ug_east(ug_east<=0)=NaN;  %%% on v-grid
    hFAC(ug<=0)=NaN;

    %%% Calculate transports
    Totg_east = sum(ug_east.*hFAC.*DX(xidx,yidx(2:end),:).*DY(xidx,yidx(2:end),:).*DZ_slope,'all','omitnan');
    Volg_east = sum(hFAC.*DX(xidx,yidx(2:end),:).*DY(xidx,yidx(2:end),:).*DZ_slope,'all','omitnan');
    Ug_east_avg(n) = Totg_east/Volg_east;

    %%% Maximum eastward velocity
    ug_xmean_max(n) = max(ug_xmean,[],'all','omitnan');

    %%% Total eastward transport
    Lx_xidx = xx(xidx(end))-xx(xidx(1))+dx;
    Totg_east_Sv(n) = Totg_east/Lx_xidx/1e6;
    

