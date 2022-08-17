


    %%% Calculate CDW heat transport
    %%% H_cdw: shoreward CDW heat transport
    %%% H_tot: shoreward total heat transport
    %%% Huc_east: eastward heat transport associated with the undercurrent

    %%% Find u,v,t of the CDW layer
    vv_tgrid = zeros(Nx,Ny,Nr);
    vv_tgrid(:,1:Ny-1,:) = (vv(:,1:Ny-1,:)+vv(:,2:Ny,:))/2;   % mass-grid
    vt_tgrid = zeros(Nx,Ny,Nr);
    vt_tgrid(:,1:Ny-1,:) = (vt(:,1:Ny-1,:)+vt(:,2:Ny,:))/2;   % mass-grid
    uu_tgrid = (uu+uu([2:Nx 1],:,:))/2;                       % mass-grid
    ut_tgrid = (ut+ut([2:Nx 1],:,:))/2;                       % mass-grid
 
    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    ss_cdw = ss;
    ss_cdw(tt<0)=NaN;

    idx_cdw = tt_cdw./tt_cdw;
    uu_cdw = uu_tgrid.*idx_cdw; %%% zonal velocity of the CDW layer
    vv_cdw = vv_tgrid.*idx_cdw; %%% meridional velocity of the CDW layer
    vt_cdw = vt_tgrid.*idx_cdw; %%% zonal heat transport of the CDW layer
    ut_cdw = ut_tgrid.*idx_cdw; %%% meridional heat transport of the CDW layer

    HH_cdw = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH_cdw(HH_cdw==0)=NaN;
    TT_cdw = sum(tt_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged temperature of the CDW layer
    SS_cdw = sum(ss_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged salinity of the CDW layer
    
    %%% Depth-integrated volume flux of the CDW layer
    UU_cdw = sum(uu_cdw.*DZ.*hFacC,3,'omitnan');
    VV_cdw = sum(vv_cdw.*DZ.*hFacC,3,'omitnan');

    %%% Total depth-integrated volume flux
    UU = sum(uu.*DZ.*hFacW,3); 
    VV = sum(vv.*DZ.*hFacS,3);
    
    %%% Calculate the heat fluxes
    Fheat_xy = rho_o*cp_o*sum(vt.*DZ.*hFacS,3); % Total depth-integrated heat flux, in W/m
    Fheat_cdw = rho_o*cp_o*sum(vt_cdw.*DZ.*hFacC,3,'omitnan'); % Depth-integrated heat flux of the CDW layer, in W/m
    %     Fheat_xz = rho_o*cp_o*squeeze(sum(sum(vt.*dx.*DZ.*hFacS,3)))/1e12;%%% Zonally and depth-integrated, in TW
   
    Ymincdw = Yicefront;
    Ymaxcdw = Yshelfbreak;
    Xmincdw = Lx/2-2*Wtrough;
    Xmaxcdw = Lx/2+2*Wtrough;
    yidxcdw = round(Ymincdw/dy):round(Ymaxcdw/dy);
    xidxcdw = round(Xmincdw/dx):round(Xmaxcdw/dx);
    xidx_east = round(Lx/2/dx):round(Xmaxcdw/dx);

    xidx_uuwest = round(Lx/2/dx)-5:round(Lx/2/dx);
    yidx_uuwest = round(Ymaxcdw/dy):round(Ymaxcdw/dy)+5;

    HH_cdw(isnan(HH_cdw))=0;
    Hcdw(n) = mean(HH_cdw(xidxcdw,yidxcdw),'all');
    Scdw(n) = mean(SS_cdw(xidxcdw,yidxcdw),'all','omitnan');
    Tcdw(n) = mean(TT_cdw(xidxcdw,yidxcdw),'all','omitnan');
    Vcdw(n) = mean(VV_cdw(xidxcdw,yidxcdw),'all','omitnan'); 
    
    Fheatcdw_icefront_trough(n) = sum(Fheat_cdw(xidxcdw,yidxcdw(1))*dx)/1e12; 
    Fheattot_icefront_trough(n) = sum(Fheat_xy(xidxcdw,yidxcdw(1))*dx)/1e12; 

    Fheatcdw_icefront_all(n) = sum(Fheat_cdw(round(Xwest/dx):round(Xeast/dx),yidxcdw(1))*dx)/1e12; 
    Fheattot_icefront_all(n) = sum(Fheat_xy(round(Xwest/dx):round(Xeast/dx),yidxcdw(1))*dx)/1e12; 

    Vcdw_east(n) = mean(VV_cdw(xidx_east,yidxcdw),'all','omitnan'); 

    Fheatcdw_east(n) = mean(Fheat_cdw(xidx_east,yidxcdw),'all','omitnan'); 
    Fheattot_east(n) = mean(Fheat_xy(xidx_east,yidxcdw),'all','omitnan'); 
    Ucdw_west(n) = mean(UU_cdw(xidx_uuwest,yidx_uuwest),'all','omitnan'); 
    Ucdw_west_max(n) = max(max(UU_cdw(xidx_uuwest,yidx_uuwest))); 

    %%% Calculate detrainment of CDW (diapycnal transport)
