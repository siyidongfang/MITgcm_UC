

    clear pd_xmean pd

    %%% Calculate potential density with a surface reference pressure 0
    lon_sec = -115;
    lat_sec = -71;
    SA = zeros(Nx,Ny,Nr);
    CT = zeros(Nx,Ny,Nr);
    pd = zeros(Nx,Ny,Nr);

    [ZZ_yz,YY_yz] = meshgrid(zz,yy);
    for ii = 1:Nx
        [SA(ii,:,:), in_ocean] = gsw_SA_from_SP(squeeze(ss(ii,:,:)),-ZZ_yz,lon_sec,lat_sec);
        CT(ii,:,:) = gsw_CT_from_pt(squeeze(SA(ii,:,:)),squeeze(tt(ii,:,:)));
        pd(ii,:,:) = gsw_rho(squeeze(SA(ii,:,:)),squeeze(CT(ii,:,:)),0);
    end
    
    %%% Calculate zonal mean potential density
    pd(pd==0)=NaN;
    pd_xmean= squeeze(mean(pd(xidx,yidx,:),'omitnan'));

    %%% Create a finer vertical grid
    ffac = 10;
    Nrf = ffac*Nr;
    delRf = zeros(1,Nrf); 
    for nz=1:Nr
        for m=1:ffac
          delRf((nz-1)*ffac+m) = delR(nz)/ffac;
        end
    end
    zz = - cumsum((delR + [0 delR(1:Nr-1)])/2);
    zz_f = - cumsum((delRf + [0 delRf(1:Nrf-1)])/2);

    pd_xmean_f = zeros(length(yidx),Nrf);

    %%% Find the depth of two isopycnals pd=1028.05kg/m^3 and pd=1028.00kg/m^3, for
    %%% each latitude
    for jj = 1:length(yidx)
        pd_xmean_f(jj,:)=interp1(zz,pd_xmean(jj,:),zz_f);
        [c zidx_2800(jj)] = min(abs(28-pd_xmean_f(jj,:)));
        [c zidx_2805(jj)] = min(abs(28.05-pd_xmean_f(jj,:)));
        z_2800(jj) =  zz_f(zidx_2800(jj));
        z_2805(jj) =  zz_f(zidx_2805(jj));
    end

    %%% Calculate the cross-slope depth change of the two isopycnals
    slope_2800 = diff(z_2800)/dy;
    slope_2805 = diff(z_2805)/dy;
    max_slope_2800(n) = max(slope_2800);
    min_slope_2805(n) = min(slope_2805);

    avg_slope_2800(n) = mean(slope_2800);
    avg_slope_2805(n) = mean(slope_2805);

    %%% Calculate the cross-slope buoyancy gradients of z=-490m
    [c z463idx] = min(abs(-463-zz));
    [c z490idx] = min(abs(-490-zz));
    [c z520idx] = min(abs(-520-zz));
    [c z547idx] = min(abs(-547-zz));
    [c z575idx] = min(abs(-575-zz));
    [c z603idx] = min(abs(-603-zz));
%     ymax_db = round((Yshelfbreak-Ymin+30*m1km)/dy)+1;
%     ymin_db = round((Yshelfbreak-Ymin-30*m1km)/dy)+1;
% 
%     db_463(n) = (pd_xmean(ymax_db,z463idx)-pd_xmean(ymin_db,z463idx)); %%% unit: kg/m^3
%     db_490(n) = (pd_xmean(ymax_db,z490idx)-pd_xmean(ymin_db,z490idx)); %%% unit: kg/m^3
%     db_520(n) = (pd_xmean(ymax_db,z520idx)-pd_xmean(ymin_db,z520idx));
%     db_547(n) = (pd_xmean(ymax_db,z547idx)-pd_xmean(ymin_db,z547idx));
%     db_575(n) = (pd_xmean(ymax_db,z575idx)-pd_xmean(ymin_db,z575idx));
%     db_603(n) = (pd_xmean(ymax_db,z603idx)-pd_xmean(ymin_db,z603idx));




    
