%%%
%%% calc_heat_along_BTStreamfunc.m
%%%
%%% Calculate heat flux along the the time-mean barotropic streamfunction.
%%%

    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    loadexp;

    load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVELTH');
    uu = UVEL;
    vt = VVELTH;

    calc_BTStreamfunc
    % plot_BTStreamfunc

    %%% Calculate depth-averaged onshore heat flux
    VT_vgrid = sum(vt.*DZ.*hFacS,3); %%% v-grid
    VT = zeros(Nx+1,Ny+1); %%% u-grid
%     VT(:,1:Ny-1) = (VT(:,1:Ny-1)+VT(:,2:Ny))/2;   







