

    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
    

    fontsize = 17;
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

    clear Ymin Ymax Xmin Xmax
    Ymin = Yshelfbreak-Ws/2;
    Ymax = Yshelfbreak+Ws/2;
    Xmin = Wsponge;
    Xmax = Lx-Wsponge;
%     Xmin = Wsponge+10*m1km;
% %     Xmax = Lx/2;
%     Xmax = Lx-(Wsponge+10*m1km);

    rho_i = 920;
    t1day = 86400;
    t1year = 365*t1day;
    Cio = 5.54e-3;
    cp_o = 3994; % Unit: J/kg/degC

    gravity = 9.81;
    f0 = -1.3e-4; %%% Coriolis parameter
    beta = 1e-11; %%% Beta parameter      
    rhoConst = 1027; %%% Reference density (MITgcm default is 999.8, but you have changed rhoConst to 1027 in setParams!)
    rho_o = rhoConst; % rho_o = 1027; % rho_o = 1000;

    



