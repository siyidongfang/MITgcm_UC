

    %%% Calculate zonal mean T, S, and neutral density
    tt(tt==0)=NaN;
    tt_xmean= squeeze(mean(tt(xidx,yidx,:),'omitnan'));
    ss(ss==0)=NaN;
    ss_xmean= squeeze(mean(ss(xidx,yidx,:),'omitnan'));
    
    lon_sec = -115;
    lat_sec = -71;
    [ZZ_yz,YY_yz] = meshgrid(zz,yy(yidx));
    [SA_xmean, in_ocean] = gsw_SA_from_SP(ss_xmean,-ZZ_yz,lon_sec,lat_sec);
    T_insitu_xmean = gsw_t_from_pt0(SA_xmean,tt_xmean,-ZZ_yz);
    for jj = 1:length(yidx)
        [gamma_n_xmean(jj,:)] = eos80_legacy_gamma_n(ss_xmean(jj,:),T_insitu_xmean(jj,:),-zz,lon_sec,lat_sec);
    end
    %%%%% Note that this neutral density is calculated from time- and
    %%%%% zonal-mean T and S. It's better to use 3D T, S to calculate gamma_n,
    %%%%% and then calculate the zonal-mean gamma_n.


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

    gamma_n_xmean_f = zeros(length(yidx),Nrf);

    %%% Find the depth of two isopycnals gamma=1028.05kg/m^3 and gamma=1028.00kg/m^3, for
    %%% each latitude
    for jj = 1:length(yidx)
        gamma_n_xmean_f(jj,:)=interp1(zz,gamma_n_xmean(jj,:),zz_f);
        [c zidx_2800(jj)] = min(abs(28-gamma_n_xmean_f(jj,:)));
        [c zidx_2805(jj)] = min(abs(28.05-gamma_n_xmean_f(jj,:)));
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
    ymax_db = round((Yshelfbreak-Ymin+30*m1km)/dy)+1;
    ymin_db = round((Yshelfbreak-Ymin-30*m1km)/dy)+1;

    db_463(n) = (gamma_n_xmean(ymax_db,z463idx)-gamma_n_xmean(ymin_db,z463idx)); %%% unit: kg/m^3
    db_490(n) = (gamma_n_xmean(ymax_db,z490idx)-gamma_n_xmean(ymin_db,z490idx)); %%% unit: kg/m^3
    db_520(n) = (gamma_n_xmean(ymax_db,z520idx)-gamma_n_xmean(ymin_db,z520idx));
    db_547(n) = (gamma_n_xmean(ymax_db,z547idx)-gamma_n_xmean(ymin_db,z547idx));
    db_575(n) = (gamma_n_xmean(ymax_db,z575idx)-gamma_n_xmean(ymin_db,z575idx));
    db_603(n) = (gamma_n_xmean(ymax_db,z603idx)-gamma_n_xmean(ymin_db,z603idx));
