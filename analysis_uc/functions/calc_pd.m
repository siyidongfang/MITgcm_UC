%%%
%%% calc_pd.m
%%%
%%% Calculate the potential density


    lon_sec = -115;
    lat_sec = -71;

    ss_nan = ss;
    tt_nan = tt;
    ss_nan(ss==0)=NaN;
    tt_nan(tt==0)=NaN;

    pd = zeros(Nx,Ny,Nr);
    SA = zeros(Nx,Ny,Nr);
    CT = zeros(Nx,Ny,Nr);

    [ZZ_yz,YY_yz] = meshgrid(zz,yy);
    for ii = 1:Nx
        [SA(ii,:,:), in_ocean] = gsw_SA_from_SP(squeeze(ss_nan(ii,:,:)),-ZZ_yz,lon_sec,lat_sec);
        CT(ii,:,:) = gsw_CT_from_pt(squeeze(SA(ii,:,:)),squeeze(tt_nan(ii,:,:)));
        pd(ii,:,:) = gsw_rho(squeeze(SA(ii,:,:)),squeeze(CT(ii,:,:)),0);
    end