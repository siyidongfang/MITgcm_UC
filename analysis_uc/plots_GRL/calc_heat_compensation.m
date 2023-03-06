


    loadexp;


    rho_o =1000;
    cp_o = 3994; % Unit: J/kg/degC
    m1km = 1000;
    Yicefront = 100*m1km; %%% Latitude of ice shelf face

    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','SHI_TauY','THETA','SHIfwFlx','UVEL','VVEL');
    tt = THETA;
    uu = UVEL;
    vv = VVEL;
    t_freezing = -1.87;
    vt = VVELTH-vv.*t_freezing; %%% Use freezing temperature as a reference temperature of heat transport
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    dx = delX(1);
    [YY,XX] = meshgrid(yy,xx);

    %%% Find ice shelf cavity
    idx_iceshelf_vgrid = SHI_TauY./SHI_TauY; %%% on v-grid
    idx_iceshelf_massgrid = SHIfwFlx./SHIfwFlx; %%% on mass-grid

    %%% Calculate cumulative heat transport Tc(x)
    vt_zint = sum(vt.*DZ.*hFacS,3,'omitnan'); 
    Tc_xy = cp_o*rho_o*flip(cumsum(flip(-vt_zint.*idx_iceshelf_vgrid*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy = Tc_xy.*idx_iceshelf_vgrid;
    idx_Tc = find(~isnan(idx_iceshelf_vgrid(round(Nx/2),:)),1,'last');

    %%% For the simulation with 2 narrow ice shelves: 
    if (ne==19)
        if (min(expname == 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_2narrowIceShelves_Nr100_prod')==1)
            idx_Tc = find(~isnan(idx_iceshelf_vgrid(round(Nx/4),:)),1,'last');
        end
    end
    Tc = Tc_xy(:,idx_Tc);


    %%% Calculate cumulative heat transport Tc_CDW(x) for the CDW layer
    tt_cdw = tt;
    tt_cdw(tt_cdw<0)=NaN; %%% Find the CDW layer: temperature above 0 degC

    tt_cdw_vgrid = zeros(Nx,Ny,Nr);
    tt_cdw_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2;
    tt_cdw_vgrid(tt_cdw_vgrid<0)=NaN; %%% Find the CDW layer: temperature above 0 degC

    idx_cdw = tt_cdw./tt_cdw; %%% Find the CDW layer, mass-grid
    idx_cdw_vgrid = tt_cdw_vgrid./tt_cdw_vgrid; %%% v-grid
    
    vt_zint_cdw = sum(vt.*DZ.*hFacS.*idx_cdw_vgrid,3,'omitnan'); 
    Fheat_cdw = rho_o*cp_o*vt_zint_cdw; % heat flux of the CDW layer, in W/m

    Tc_xy_cdw = cp_o*rho_o*flip(cumsum(flip(-vt_zint_cdw.*idx_iceshelf_vgrid*dx),'omitnan'))/1e12; %%% in TW
    Tc_xy_cdw = Tc_xy_cdw.*idx_iceshelf_vgrid;
    Tc_cdw = Tc_xy_cdw(:,idx_Tc);

    Tc_cdw_mean = mean(Tc_xy_cdw,2,'omitnan');
    Tc_mean = mean(Tc_xy,2,'omitnan');

    %%% Find the upper bound and lower bound of the CDW layer
    HH_cdw = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH_cdw(HH_cdw==0)=NaN;

    idx_upper = zeros(Nx,Ny);
    idx_lower = zeros(Nx,Ny);
    Zupper = zeros(Nx,Ny);
    Zlower = zeros(Nx,Ny);
    for i=1:Nx
        for j=1:Ny
            aa = find(~isnan(idx_cdw(i,j,:)),1,'first');
            bb = find(~isnan(idx_cdw(i,j,:)),1,'last');
            if (isempty(aa)||isempty(bb))
                idx_upper(i,j) = NaN;
                Zupper(i,j) = NaN;
                idx_lower(i,j) = NaN;
                Zlower(i,j) = NaN;
            else
                idx_upper(i,j) = aa;
                Zupper(i,j) = zz(aa);
                idx_lower(i,j) = bb;
                Zlower(i,j) = zz(bb);
            end
        end
    end


    %%% Find u,v,t of the CDW layer
    uu_tgrid = (uu+uu([2:Nx 1],:,:))/2;                       % mass-grid
    vv_tgrid = zeros(Nx,Ny,Nr);
    vv_tgrid(:,1:Ny-1,:) = (vv(:,1:Ny-1,:)+vv(:,2:Ny,:))/2;   % mass-grid
    vt_tgrid = zeros(Nx,Ny,Nr);
    vt_tgrid(:,1:Ny-1,:) = (vt(:,1:Ny-1,:)+vt(:,2:Ny,:))/2;   % mass-grid

    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    
    idx_cdw = tt_cdw./tt_cdw;
    uu_cdw = uu_tgrid.*idx_cdw; %%% zonal velocity of the CDW layer
    vv_cdw = vv_tgrid.*idx_cdw; %%% meridional velocity of the CDW layer
    vt_cdw = vt_tgrid.*idx_cdw;

    %%% Vertically integrate uu_cdw and vv_cdw to get the volume flux
    UU_cdw = sum(uu_cdw.*DZ.*hFacC,3,'omitnan');
    VV_cdw = sum(vv_cdw.*DZ.*hFacC,3,'omitnan');
