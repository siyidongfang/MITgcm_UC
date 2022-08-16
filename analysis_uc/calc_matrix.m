%%%
%%% calc_matrix.m
%%%
%%% Calculate the following quantities:
%%%
%%% Tot_east: total eastward transport over the slope region
%%% Vol_east: total ocean volume with eastward velocity over the slope region
%%% U_east_avg = Tot_east/Vol_east: mean undercurrent strength over the slope region
%%% Ub_east_max: maximum eastward seafloor velocity
%%% Ub_east_avg: mean eastward seafloor velocity
%%% U_east_max: maximum eastward velocity
%%% U_west_max: strongest westward velocity (negative) 
%%% Tot_west_Sv: total westward transport (negative), in Sv
%%% Tot_Sv = Tot_west_Sv + Tot_east_Sv: total zonal ocean transport (negative) 
%%% MeltRate: ice shelf melting rate

%%% Correlation coefficient between (1) total eastward transport, (2) mean
%%% undercurrent strength, (3) maximum undercurrent strength, (4) eastward
%%% heat transport associated with the undercurrent along the shelf break,
%%% (5) maximum eastward seafloor velocity 
%%% with (1) ice shelf melt rate, (2) shoreward CDW transport, (3) total
%%% westward ocean transport
%%%

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{4}
    list_exps_new;

    m1km = 1000;
    Ws =30*m1km; %%% Reference value 30km, continental slope half-width
    Wshelf = 100*m1km; %%% Width of continental shelf
    Yicefront = 100*m1km; %%% Latitude of ice shelf face
    Ycoast = 120*m1km; %%% Latitude of coastline
    Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
    Ydeep = Ycoast+Wshelf+3*Ws; %%% Latitude of deep ocean
    Xeast = 400*m1km; %%% Longitude of eastern trough wall
    Xwest = 200*m1km; %%% Longitude of western trough wall
    Wsponge = 20*m1km;
    Wtrough = 30*m1km;
    Lx = 600*m1km;

    Ymin = Yshelfbreak-50*m1km;
    Ymax = Ydeep;
    Xmin = Wsponge+20*m1km;
    Xmax = Lx-(Wsponge+20*m1km);

    rho_i = 920;
    t1day = 86400;
    t1year = 365*t1day;
    rho_o = 1027; % rho_o = 1000;
    Cio = 5.54e-3;
    cp_o = 3994; % Unit: J/kg/degC


for n=1:nEXP
% for n=1
    expname = EXPNAME{n}
    loadexp;
    
    DX = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DY = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    dy = delY(1);
    dx = delX(1);
    
    load_data;
   
    yidx = round(Ymin/dy):round(Ymax/dy);
    xidx = round(Xmin/dx):round(Xmax/dx); %%% exclude the eastern and western sponge layers
    
    %%% Find bottom velocity
    uu_bottom = zeros(Nx,Ny);   % bottom velocity
    uu(uu==0) = NaN;            % make the topography (where tt==0) NaN values
    idx_topog = isnan(uu);      % The dry grids (topography): 1, wet grids: 0
    idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
    for i = 1:Nx
        for j = 2:Ny-1
            if(idxb(i,j)~=0)
               uu_bottom(i,j) = uu(i,j,idxb(i,j));
            end
        end
    end
    uu_bottom(uu_bottom==0) = NaN;
    
    uu_slope = uu(xidx,yidx,:);
    vt_slope = vt(xidx,yidx,:);
    tt_slope = tt(xidx,yidx,:);
    ub_slope = uu_bottom(xidx,yidx);
    
    uu_east = uu_slope;
    uu_east(uu_slope<=0)=NaN;
    hFacW_east = hFacW(xidx,yidx,:);
    hFacW_east(uu_slope<=0)=NaN;
    ub_east = ub_slope;
    ub_east(ub_slope<=0)=NaN;
    
    uu_west = uu_slope;
    uu_west(uu_slope>=0)=NaN;
    hFacW_west = hFacW(xidx,yidx,:);
    hFacW_west(uu_slope>=0)=NaN;
    ub_west = ub_slope;
    ub_west(ub_slope>=0)=NaN;
  
    %%% Calculate velocities
    Ub_east_max(n) = max(ub_east,[],'all','omitnan');
    Ub_east_avg(n) = mean(ub_east,'all','omitnan');
    Ub_west_min(n) = min(ub_west,[],'all','omitnan');
    Ub_west_avg(n) = mean(ub_west,'all','omitnan');
    Ub_avg(n) = mean(ub_slope,'all','omitnan');

    %%% Calculate transports
    Tot_east = sum(uu_east.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Vol_east = sum(hFacW_east.*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    U_east_avg(n) = Tot_east/Vol_east;
    
    Tot_west = sum(uu_west.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Vol_west = sum(hFacW_west.*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    U_west_avg(n) = Tot_west/Vol_west;
    
    Tot_east_Sv(n) = Tot_east/Lx/1e6;
    Tot_west_Sv(n) = Tot_west/Lx/1e6;
    Tot_Sv(n) = Tot_east_Sv(n)+Tot_west_Sv(n);
    
    %%% Calculate ice-shelf melt rate
    RAC = rdmds([exppath,'/results/RAC']);
    RAC (SHIfwFlx==0)=NaN;
    SHIfwFlx (SHIfwFlx==0)=NaN;
    MeltRate_Gt(n) = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/1e12; %%% Gt/yr
    MeltRate_m(n) = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr


    %%% Calculate the ocean surface stress (is almost ice-ocean stress)
    uo_surf = uu(xidx,yidx,1);
    vo_surf = vv(xidx,yidx,1);
    if(is_prod_run(n))
        TAUx(n) = mean(oceTAUX(xidx,yidx),'all');
        TAUy(n) = mean(oceTAUY(xidx,yidx),'all');
    end
    if(useSEAICE)
        TAUx_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(ui(xidx,yidx)-uo_surf),'all');
        TAUy_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(vi(xidx,yidx)-vo_surf),'all');
    else
        TAUx_estimate(n)=NaN;TAUy_estimate(n)=NaN;
    end

    %%% Calculate sea level gradient cross the slope
    Ymin_eta = Yshelfbreak-30*m1km;
    Ymax_eta = Yshelfbreak+30*m1km;
    yidx_shelf = round(Ymin_eta/dy):round((Ymin_eta+10*m1km)/dy);
    yidx_deep = round((Ymax_eta-10*m1km)/dy):round(Ymax_eta/dy);
    eta_shelf = mean(eta(xidx,yidx_shelf),'all');
    eta_deep  = mean(eta(xidx,yidx_deep),'all');
    deltaY = (Ymax_eta-10*m1km/2) - (Ymin_eta+10*m1km/2);
    detady(n) = (eta_shelf-eta_deep)/deltaY*100*m1km; %%% Unit: m/(100km)

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


end



    save([prodir 'matrix_' exp_group '.mat'],'exp_group','EXPNAME','Ymin','Ymax','Xmin','Xmax',...
        'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'MeltRate_m','MeltRate_Gt',...
        'detady','TAUx','TAUy','TAUx_estimate','TAUy_estimate',...
        'min_slope_2805','max_slope_2800','avg_slope_2805','avg_slope_2800',...
        'db_463','db_490','db_520','db_547','db_575','db_603',...
        'Hcdw','Scdw','Tcdw','Vcdw',...
        'Fheatcdw_icefront_trough','Fheattot_icefront_trough','Fheatcdw_icefront_all','Fheattot_icefront_all',...
        'Vcdw_east','Fheatcdw_east','Fheattot_east','Ucdw_west','Ucdw_west_max')



    