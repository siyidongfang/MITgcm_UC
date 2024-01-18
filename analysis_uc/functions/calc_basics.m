
    addpath /Users/ysi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/ysi/Software/eos80_legacy_gamma_n/;
    addpath /Users/ysi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/ysi/Software/gsw_matlab_v3_06_11/library/;


    load_constants;
    load_spacing;

    rho_o = 1000;
    cp_o = 3994; % Unit: J/kg/degC

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    [YY,XX] = meshgrid(yy,xx);

    %%% Find u,v,t of the CDW layer
    uu_tgrid = (uu+uu([2:Nx 1],:,:))/2;                       % mass-grid
    vv_tgrid = zeros(Nx,Ny,Nr);
    vv_tgrid(:,1:Ny-1,:) = (vv(:,1:Ny-1,:)+vv(:,2:Ny,:))/2;   % mass-grid
    vt_tgrid = zeros(Nx,Ny,Nr);
    vt_tgrid(:,1:Ny-1,:) = (vt(:,1:Ny-1,:)+vt(:,2:Ny,:))/2;   % mass-grid

    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    ss_cdw = ss;
    ss_cdw(tt<0)=NaN;
    
    idx_cdw = tt_cdw./tt_cdw;
    uu_cdw = uu_tgrid.*idx_cdw; %%% zonal velocity of the CDW layer
    vv_cdw = vv_tgrid.*idx_cdw; %%% meridional velocity of the CDW layer
    vt_cdw = vt_tgrid.*idx_cdw;

    HH_cdw = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH_cdw(HH_cdw==0)=NaN;
    TT_cdw = sum(tt_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged temperature of the CDW layer
    SS_cdw = sum(ss_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged salinity of the CDW layer
    
    %%% Vertically integrate uu_cdw and vv_cdw to get the volume flux
    UU_cdw = sum(uu_cdw.*DZ.*hFacC,3,'omitnan');
    VV_cdw = sum(vv_cdw.*DZ.*hFacC,3,'omitnan');

    UU = sum(uu.*DZ.*hFacW,3); %%% Depth-integrated volume flux
    VV = sum(vv.*DZ.*hFacS,3);
    
    %%% Calculate the heat fluxes
    Fheat_xy = rho_o*cp_o*sum(vt.*DZ.*hFacS,3); % Depth-integrated heat flux, in W/m
    Fheat_cdw = rho_o*cp_o*sum(vt_cdw.*DZ.*hFacC,3,'omitnan'); % heat flux of the CDW layer, in W/m
    Fheat_xz = rho_o*cp_o*squeeze(sum(sum(vt.*delX(1).*DZ.*hFacS,3)))/1e12;%%% Zonally and depth-integrated, in TW
    
    %%% Calculate zonal mean T, S, and neutral density
    tt(tt==0)=NaN;
    tt_xmean= squeeze(mean(tt(xidx,:,:),'omitnan'));
    ss(ss==0)=NaN;
    ss_xmean= squeeze(mean(ss(xidx,:,:),'omitnan'));
    uu(uu==0)=NaN;
    uu_xmean= squeeze(mean(uu(xidx,:,:),'omitnan'));

    lon_sec = -115;
    lat_sec = -71;
    [ZZ_yz,YY_yz] = meshgrid(zz,yy);
    [SA_xmean, in_ocean] = gsw_SA_from_SP(ss_xmean,-ZZ_yz,lon_sec,lat_sec);
    T_insitu_xmean = gsw_t_from_pt0(SA_xmean,tt_xmean,-ZZ_yz);
    for jj = 1:Ny
        [gamma_n_xmean(jj,:)] = eos80_legacy_gamma_n(ss_xmean(jj,:),T_insitu_xmean(jj,:),-zz,lon_sec,lat_sec);
    end





    %%% Calculate mean T, S, u west of the trough (x=-200km to x=0), and
    %%% neutral density
    m1km=1000;
    Lx_start = 100*m1km;
    Lx_end = 300*m1km;
    xidx_w = round(Lx_start/delX(1)):round(Lx_end/delX(1));
    tt_w = squeeze(mean(tt(xidx_w,:,:),'omitnan'));
    ss_w = squeeze(mean(ss(xidx_w,:,:),'omitnan'));
    uu_w = squeeze(mean(uu(xidx_w,:,:),'omitnan'));

    [SA_w, in_ocean] = gsw_SA_from_SP(ss_w,-ZZ_yz,lon_sec,lat_sec);
    T_insitu_w = gsw_t_from_pt0(SA_w,tt_w,-ZZ_yz);
    for jj = 1:Ny
        [gamma_n_w(jj,:)] = eos80_legacy_gamma_n(ss_w(jj,:),T_insitu_w(jj,:),-zz,lon_sec,lat_sec);
    end



    figdir = [exppath '/img/'];
    ncolor=40;
    fontsize = 16;
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'},ncolor);

