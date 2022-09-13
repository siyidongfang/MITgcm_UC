


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};

    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    savefigure = true;
    showfigure = true;

% for n=1:nEXP
for n=1
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;
    
    calc_BTvorticity;
    plot_BTvorticity;
   
end




