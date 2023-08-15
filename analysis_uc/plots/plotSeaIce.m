%%%
%%% plotSeaIce.m
%%%
%%% Plot sea ice properties of the reference simulation

    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;


    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne}
    loadexp;

    load([prodir expname '_tavg_5yrs.mat'],...
             'SIarea','SIheff','SIuice','SIvice',...
             'SItices','SIqnet','SIempmr','SIatmQnt',...
             'oceFWflx');

    ui = SIuice;
    vi = SIvice;
    hi = SIheff;
    ai = SIarea;

    SIempmr(SIempmr==0)=NaN;
    oceFWflx(oceFWflx==0)=NaN;
    
    % SIempmr |SM      U1|kg/m^2/s        |Ocean surface freshwater flux, > 0 increases salt
    % oceFWflx|SM      U1|kg/m^2/s        |net surface Fresh-Water flux into the ocean (+=down), >0 decreases salinity
    
    t1year = 86400*365;
    fw_seaice = SIempmr*t1year/rho_i;

    figure(1)
    subplot(1,3,1)
    pcolor(xx,yy,fw_seaice');shading flat;colorbar;colormap(redblue);
    clim([-1 1]);set(gca,'color',gray);
    title('Freshwater flux from sea ice melting')
    % subplot(1,3,2)
    % pcolor(xx,yy,SIempmr');shading flat;colorbar;colormap(redblue);clim([-1 1]/1e4);set(gca,'color',gray);

 

