

    % For only one experiments
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;



    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    expname = EXPNAME{25}

    loadexp;

    load([prodir '/' expname '_tavg_5yrs.mat'],'THETA','SALT','UVEL','VVEL','VVELTH','ETAN',...
        'SHIfwFlx','SHIhtFlx','SHI_TauX','SHI_TauY','SHIForcT','SHIForcS',...
        'SIuice','SIvice','SIheff','SIarea');
    tt = THETA;
    ss = SALT;
    uu = UVEL;
    vv = VVEL;
    vt = VVELTH;
    eta = ETAN;

    year = '3to7';
    plot_KE_EKE_T_S_series
    plot_basics
    plot_shelfIce
    plot_seaice



    