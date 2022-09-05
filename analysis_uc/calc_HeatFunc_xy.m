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
    fontsize = 17;

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
    divF_vgrid = zeros(Nx,Ny);
    divF_vgrid(:,2:Ny) = (divF(:,1:Ny-1)+divF(:,2:Ny))/2;
    p = abs(divF_vgrid)*dy./VT;

    %%% Check horizontal divergence by creating a box near the trough, and
    %%% calculate F_in and F_out.
    Xboxmin = -100*m1km+Lx/2;
    Xboxmax = 100*m1km+Lx/2;
    Yboxmin = 100*m1km;
    Yboxmax = 200*m1km;
    xboxidx = round(Xboxmin/dx):round(Xboxmax/dx);
    yboxidx = round(Yboxmin/dy):round(Yboxmax/dy);
    x1 = xboxidx(1); x2 = xboxidx(end);
    y1 = yboxidx(1); y2 = yboxidx(end);
    Tin = sum(-VT(xboxidx,y2)*dx) + sum(UT(x1,yboxidx)*dy);
    Tout = sum(-VT(xboxidx,y1)*dx) + sum(UT(x2,yboxidx)*dy);

    (Tout-Tin)/(0.5*(Tin+Tout))


    %%% Calculate the horizontal heatfunction using VT
    VT_exclude=VT; %%% Exclude the zonal boundary
    VT_exclude(1:11,:)=0;
    phi_H = cp_o*rho_o*cumsum(VT_exclude*dx);
    phi_H(VT==0)=NaN;

    %%% Calculate the horizontal heatfunction using UT
    UT_exclude=UT; %%% Exclude the northern boundary
%     UT_exclude(:,end-75:end)=0;
%     UT_exclude(UT_exclude==0)=NaN;
    phi_Hu = cp_o*rho_o*flip(cumsum(flip(UT_exclude*dy,2),2,'omitnan'),2);
    phi_Hu(VT==0)=NaN;



    figure(1)
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,VT')
    shading flat;colorbar;colormap(redblue);caxis([-80 80])
    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,UT')
    shading flat;colorbar;colormap(redblue);caxis([-80 80])

    figure(2)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    hold on;
    svx = 8; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    UT(1:svx:end,1:svy:end)',VT(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1.5;
    hold off;
    ylim([0 280])
    set(curr,'AutoScale','on', 'AutoScaleFactor', 5)
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Shoreward heat flux (vector, GW/m)')
    set(gca,'FontSize',fontsize);


    figure(3)
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,dy*divF')
    shading flat;caxis([-0.001 0.001]*dy);colorbar;colormap(redblue);
    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,p');caxis([-1 1]);
    shading flat;colorbar;colormap(redblue);

    figure(4)
    subplot(1,2,1)
    %     pcolor(xx/1000,yy/1000,phi_H')
    %     shading flat;
    set(gcf,'color','w');
    contourf(XX/1000,YY/1000,phi_H/1e12,[min(min(phi_H/1e12)):0.1:max(max(phi_H/1e12))],'EdgeColor','k');  
    caxis([-4 0]);colorbar;colormap(flip(WhiteBlueGreenYellowRed(0)));
%     ylim([0 250])

    subplot(1,2,2)
    set(gcf,'color','w');
    contourf(XX/1000,YY/1000,-phi_Hu/1e12,[min(min(phi_H/1e12)):0.1:max(max(phi_H/1e12))],'EdgeColor','k');  
%     caxis([-4 0]);
    colorbar;colormap(flip(WhiteBlueGreenYellowRed(0)));
%     ylim([0 250])


    


    



    