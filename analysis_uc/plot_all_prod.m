

    % For only one experiments
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;


    expdir = '/Users/csi/MITgcm_UC/exps_uc/pseudo_shelfice_seaice/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_melt0_prod'
    prodir = '/Users/csi/MITgcm_UC/products_uc/pseudo_shelfice_seaice/';
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

    year = '1to5';
    plot_KE_EKE_T_S_series
    plot_basics
%     plot_shelfIce
    plot_seaice



    