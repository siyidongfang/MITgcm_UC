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

for ngroup=1:4
    exp_group = EXP_GROUP{ngroup}
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
    


    calc_matrix_transport;
    calc_matrix_melt_rate;
    calc_matrix_surface_stress;
    calc_matrix_SSHgradient;
    calc_matrix_buoyancy_gradient;
    calc_matrix_cdw;


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



end