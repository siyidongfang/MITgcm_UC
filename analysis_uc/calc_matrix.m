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
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    expdir = '/Users/csi/MITgcm_UC/exps_aofd/seaice_boundary/';
    expname = 'res2km_Ua-2Va2_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    prodir = [expdir expname '/'];
    loadexp;
    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    
    load([prodir '/' expname '_tavg_5yrs.mat'],'THETA','SALT','UVEL','VVEL','VVELTH','UVELTH','ETAN',...
            'SHIfwFlx','SHIhtFlx','SHI_TauX','SHI_TauY','SHIForcT','SHIForcS',...
            'SIuice','SIvice','SIheff','SIarea');
    
    tt = THETA;
    ss = SALT;
    uu = UVEL;
    vv = VVEL;
    vt = VVELTH;
    ut = UVELTH;
    eta = ETAN;
    
    m1km = 1000;
    Ws =30*m1km; %%% Reference value 30km, continental slope half-width
    Wshelf = 100*m1km; %%% Width of continental shelf
    Ycoast = 120*m1km; %%% Latitude of coastline
    Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
    Wsponge = 20*m1km;
    
    Ymin = Yshelfbreak - Ws;
    Ymax = Yshelfbreak + 2*Ws;
    Xmin = Wsponge+20*m1km;
    Xmax = Lx-(Wsponge+20*m1km);
    
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
    Ub_east_max=max(ub_east,[],'all','omitnan');
    Ub_east_avg=mean(ub_east,'all','omitnan');
    Ub_west_min=min(ub_west,[],'all','omitnan');
    Ub_west_avg=mean(ub_west,'all','omitnan');
    Ub_avg = mean(ub_slope,'all','omitnan');

    %%% Calculate transports
    Tot_east = sum(uu_east.*hFacW(xidx,yidx,:).*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    Vol_east = sum(hFacW_east.*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    U_east_avg = Tot_east/Vol_east;
    
    Tot_west = sum(uu_west.*hFacW(xidx,yidx,:).*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    Vol_west = sum(hFacW_west.*DX_xyz(xidx,yidx,:).*DY_xyz(xidx,yidx,:).*DZ_xyz(xidx,yidx,:),'all','omitnan');
    U_west_avg = Tot_west/Vol_west;
    
    Tot_east_Sv = Tot_east/Lx/1e6;
    Tot_west_Sv = Tot_west/Lx/1e6;
    Tot_Sv = Tot_east_Sv+Tot_west_Sv;
    
    %%% Calculate ice-shelf melt rate
    RAC = rdmds([exppath,'/results/RAC']);
    rho_i = 920;
    t1day = 86400;
    t1year = 365*t1day;
    SHIfwFlx (SHIfwFlx==0)=NaN;
    MeltRate_Gt = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/1e12; %%% Gt/yr
    MeltRate_m = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr

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

    H_cdw = 


    %%% Calculate sea ice-ocean stress
    
    
%     save([prodir 'matrix.mat'],'EXPNAME',...
%         'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
%         'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
%         'H_cdw','H_tot','Huc_east','MeltRate_m','MeltRate_Gt')
%     

