


%     tt = rdmds([exppath,'/results/THETA'],nIter);
%     ss = rdmds([exppath,'/results/SALT'],nIter);
%     uu = rdmds([exppath,'/results/UVEL'],nIter);
%     vv = rdmds([exppath,'/results/VVEL'],nIter);
%     vt = rdmds([exppath,'/results/VVELTH'],nIter);
%     eta = rdmds([exppath,'/results/ETAN'],nIter);

    tt = THETA;
    ss = SALT;
    uu = UVEL;
    vv = VVEL;
    vt = VVELTH;
    eta = ETAN;

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
    