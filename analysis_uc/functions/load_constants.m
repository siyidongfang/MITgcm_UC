

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

    Ymin = Yshelfbreak;
    Ymax = Yshelfbreak+Ws;
    Xmin = Wsponge+20*m1km;
    Xmax = Lx-(Wsponge+20*m1km);

    rho_i = 920;
    t1day = 86400;
    t1year = 365*t1day;
    Cio = 5.54e-3;
    cp_o = 3994; % Unit: J/kg/degC

    gravity = 9.81;
    f0 = -1.3e-4; %%% Coriolis parameter
    beta = 1e-11; %%% Beta parameter      
    rhoConst = 1027; %%% Reference density
    rho_o = rhoConst; % rho_o = 1027; % rho_o = 1000;

    



