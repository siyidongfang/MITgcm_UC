%%%
%%% calc_HeatFunc_xy.m
%%%
%%% Calculate the horizontal heatfunction

    clear; 
    close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    figdir = '/Users/csi/MITgcm_UC/figures_uc/HeatFunc_xy/seaice_boundary/';

    loadexp;

    rho_o =1000;
    cp_o = 3994; % Unit: J/kg/degC
    m1km = 1000;


    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','VVEL','THETA');
    vt = VVELTH;
    vv = VVEL;
    tt = THETA;
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    dx = delX(1);
    [YY,XX] = meshgrid(yy,xx);
    

    %%% Calculate the horizontal heatfunction using VT
    VT = sum(vt.*DZ.*hFacS,3); %%% v-grid
    phi_H = cp_o*rho_o*cumsum(VT*dx);
    phi_H(VT==0)=NaN;

    figure(1)
    pcolor(xx/1000,yy/1000,VT')
    shading flat;colorbar;colormap(redblue);caxis([-80 80])


    figure(2)
%     pcolor(xx/1000,yy/1000,phi_H')
%     shading flat;
    set(gcf,'color','w');
    contourf(XX/1000,YY/1000,phi_H/1e12,[min(min(phi_H/1e12)):0.1:max(max(phi_H/1e12))],'EdgeColor','k');  
    caxis([-4 0]);colorbar;colormap(flip(WhiteBlueGreenYellowRed(0)));
    ylim([0 250])


    
    