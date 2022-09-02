%%%
%%% calc_HeatFunc_xy.m
%%%
%%% Calculate the horizontal heatfunction

    clear; 
%     close all;

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

    load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','VVEL','THETA','UVELTH','WVELTH');
    vt = VVELTH;
    ut = UVELTH;
    wt = WVELTH;
    vv = VVEL;
    tt = THETA;
    dx = delX(1);
    dy = delY(1);
    [YY,XX] = meshgrid(yy,xx);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

    %%% Vertically integrate the horizontal heat flux
    VT = sum(vt.*DZ.*hFacS,3); %%% v-grid
    UT = sum(ut.*DZ.*hFacW,3); %%% v-grid

    %%% Check horizontal divergence of the heat flux
    dFdx = zeros(Nx,Ny);
    dFdy = zeros(Nx,Ny);
    dFdx(2:Nx,:) = (UT(2:Nx,:)-UT(1:Nx-1,:))/dx; %%% on mass-grid
    dFdy(:,1:Ny-1) = (VT(:,2:Ny)-VT(:,1:Ny-1))/dy; %%% on mass-grid

    divF = dFdx + dFdy;
    figure(1)
    pcolor(xx/1000,yy/1000,dy*divF')
    shading flat;caxis([-0.001 0.001]*dy);colorbar;colormap(redblue);

    divF_vgrid = zeros(Nx,Ny);
    divF_vgrid(:,2:Ny) = (divF(:,1:Ny-1)+divF(:,2:Ny))/2;
    p = abs(divF_vgrid)*dy./VT;

%     figure(2)
%     pcolor(xx/1000,yy/1000,p');caxis([-1 1]);
%     shading flat;colorbar;colormap(redblue);





%     %%% Calculate the horizontal heatfunction using VT
%     phi_H = cp_o*rho_o*cumsum(VT*dx);
%     phi_H(VT==0)=NaN;
% 
    figure(5)
    pcolor(xx/1000,yy/1000,VT')
    shading flat;colorbar;colormap(redblue);caxis([-80 80])
% 
%     figure(3)
%     %     pcolor(xx/1000,yy/1000,phi_H')
%     %     shading flat;
%     set(gcf,'color','w');
%     contourf(XX/1000,YY/1000,phi_H/1e12,[min(min(phi_H/1e12)):0.1:max(max(phi_H/1e12))],'EdgeColor','k');  
%     caxis([-4 0]);colorbar;colormap(flip(WhiteBlueGreenYellowRed(0)));
%     ylim([0 250])


    


    



    