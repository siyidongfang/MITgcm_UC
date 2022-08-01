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
%%% H_cdw: shoreward CDW heat transport
%%% H_tot: shoreward total heat transport
%%% Huc_east: eastward heat transport associated with the undercurrent
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

    prodir = '/Users/csi/MITgcm_UC/products_uc/';

    list_exps_seaiceboundary;

    m1km = 1000;
    Ws =30*m1km; %%% Reference value 30km, continental slope half-width
    Wshelf = 100*m1km; %%% Width of continental shelf
    Ycoast = 120*m1km; %%% Latitude of coastline
    Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
    Wsponge = 20*m1km;
    Lx = 600*m1km;

    Ymin = Yshelfbreak - Ws;
    Ymax = Yshelfbreak + 2*Ws;
    Xmin = Wsponge+20*m1km;
    Xmax = Lx-(Wsponge+20*m1km);

    rho_i = 920;
    t1day = 86400;
    t1year = 365*t1day;
    rho_o = 1027;
    Cio = 5.54e-3;


for n=1:nEXP
% for n=1
    expname = EXPNAME{n}
    expdir = EXPDIR{n};

    loadexp;
    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    
    if(is_prod_run(n))
        load([expdir expname '/' expname '_tavg_5yrs.mat'],'THETA','SALT','UVEL','VVEL','VVELTH','UVELTH','ETAN',...
                'SHIfwFlx','oceTAUX','oceTAUY','SIuice','SIvice');
        tt = THETA;
        ss = SALT;
        uu = UVEL;
        vv = VVEL;
        vt = VVELTH;
        ut = UVELTH;
        eta = ETAN;
        ui = SIuice;
        vi = SIvice;
    else
        tt = rdmds([exppath,'/results/THETA'],nIter(n));
        ss = rdmds([exppath,'/results/SALT'],nIter(n));
        uu = rdmds([exppath,'/results/UVEL'],nIter(n));
        vv = rdmds([exppath,'/results/VVEL'],nIter(n));
        vt = rdmds([exppath,'/results/VVELTH'],nIter(n));
        ut = rdmds([exppath,'/results/UVELTH'],nIter(n));
        eta = rdmds([exppath,'/results/ETAN'],nIter(n));
        SHIfwFlx = rdmds([exppath,'/results/SHIfwFlx'],nIter(n));
        ui = rdmds([exppath,'/results/SIuice'],nIter(n));
        vi = rdmds([exppath,'/results/SIvice'],nIter(n));
    end
    

    yidx = round(Ymin/delY(1)):round(Ymax/delY(1));
    xidx = round(Xmin/delX(1)):round(Xmax/delX(1)); %%% exclude the eastern and western sponge layers
    
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
    Tot_east = sum(uu_east.*hFacW(xidx,yidx,:).*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    Vol_east = sum(hFacW_east.*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    U_east_avg(n) = Tot_east/Vol_east;
    
    Tot_west = sum(uu_west.*hFacW(xidx,yidx,:).*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    Vol_west = sum(hFacW_west.*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
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


    %%% Calculate CDW heat transport
    %%% H_cdw: shoreward CDW heat transport
    %%% H_tot: shoreward total heat transport
    %%% Huc_east: eastward heat transport associated with the undercurrent


    %%% Find u,v,t of the CDW layer
    vt_tgrid = zeros(Nx,Ny,Nr);
    vt_tgrid(:,1:Ny-1,:) = (vt(:,1:Ny-1,:)+vt(:,2:Ny,:))/2;   % mass-grid
    ut_tgrid = (ut+ut([2:Nx 1],:,:))/2;                       % mass-grid
 
    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    idx_cdw = tt_cdw./tt_cdw;
    vt_cdw = vt_tgrid.*idx_cdw;
    ut_cdw = ut_tgrid.*idx_cdw;

%     H_cdw =  'H_cdw','H_tot','Huc_east',


    %%% Calculate detrainment of CDW (diapycnal transport)


    %%% Calculate the ocean surface stress (is almost ice-ocean stress)
    uo_surf = uu(xidx,yidx,1);
    vo_surf = vv(xidx,yidx,1);
    if(is_prod_run(n))
        TAUiox(n) = mean(oceTAUX(xidx,yidx),'all');
        TAUioy(n) = mean(oceTAUY(xidx,yidx),'all');
        TAUiox_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(ui(xidx,yidx)-uo_surf),'all');
        TAUioy_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(vi(xidx,yidx)-vo_surf),'all');
    else
        TAUiox_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(ui(xidx,yidx)-uo_surf),'all');
        TAUioy_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(vi(xidx,yidx)-vo_surf),'all');
    end

    %%% Calculate sea level gradient
    yidx_shelf = round((Ymin-50*m1km)/delY(1)):round(Ymin/delY(1));
    yidx_deep = round(Ymax/delY(1)):round((Ymax+50*m1km)/delY(1));
    eta_shelf = mean(eta(xidx,yidx_shelf),'all');
    eta_deep  = mean(eta(xidx,yidx_deep),'all');
    deltaY = (Ymax+50*m1km/2) - (Ymin-50*m1km/2);
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
    slope_2800 = diff(z_2800)/delY(1);
    slope_2805 = diff(z_2805)/delY(1);
    max_slope_2800(n) = max(slope_2800);
    min_slope_2805(n) = min(slope_2805);


    %%% Calculate the cross-slope buoyancy gradients of z=-490m
    [c z490idx] = min(abs(-490-zz));
    [c z520idx] = min(abs(-520-zz));
    dy = delY(1);
    db_490(n) = (gamma_n_xmean(end-15,z490idx)-gamma_n_xmean(15,z490idx)); %%% unit: kg/m^3
%         ./(Ymax-15*dy-(Ymin+15*dy))*100*m1km %%% unit: kg/m^3/100km
    db_520(n) = (gamma_n_xmean(end-15,z520idx)-gamma_n_xmean(15,z520idx));

end




    save([prodir 'matrix.mat'],'EXPNAME',...
        'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'MeltRate_m','MeltRate_Gt',...
        'detady','TAUiox','TAUioy','TAUiox_estimate','TAUioy_estimate',...
        'min_slope_2805','max_slope_2800','db_520','db_490')



    