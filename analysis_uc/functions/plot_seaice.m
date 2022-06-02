%%% 
%%% plot_seaice.m
%%%
%%% Plot sea ice properties



    clear;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;

    expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_obcs/';
    expname = 'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_seaice_flatIsopyc_stempede2';
    loadexp;

    nIter = 1191767;
    year = num2str(6.5);

    SIuice = rdmds([exppath,'/results/SIuice'],nIter);
    SIvice = rdmds([exppath,'/results/SIvice'],nIter);
    SIheff = rdmds([exppath,'/results/SIheff'],nIter);
    SIarea = rdmds([exppath,'/results/SIheff'],nIter);


        THETA = rdmds([exppath,'/results/THETA'],nIter);
        aaa = squeeze(THETA(1,:,:));
        pcolor(aaa);shading flat;colorbar;