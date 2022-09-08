%%%
%%% calc_HeatFunc_xy.m
%%%
%%% Calculate the horizontal heatfunction

    clear; 
    close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/HeatFunc_xy/' exp_group '/'];

    list_exps_new;
    load_constants;
    load_colors;
    savefigure = false;

% for n=1:nEXP
for n=1
    expname = EXPNAME{n}
    loadexp;
    load_spacing;
    load_data;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Calculate horizontal heatfunction on mass-grid %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Vertically integrate the horizontal heat flux
    UT = sum(ut.*DZ.*hFacW,3); %%% u-grid
    UT(UT==0)=NaN;
    UT_tgrid = zeros(Nx,Ny);
    UT_tgrid(1:Nx-1,:) = (UT(1:Nx-1,:)+UT(2:Nx,:))/2; %%% mass-grid 

    VT = sum(vt.*DZ.*hFacS,3); %%% v-grid
    VT(VT==0)=NaN;
    VT_tgrid = zeros(Nx,Ny); 
    VT_tgrid(:,1:Ny-1) = (VT(:,1:Ny-1,:)+VT(:,2:Ny,:))/2; %%% mass-grid


    phih = zeros(Nx,Ny);%%% horizontal heat function

    theta_ref = -1.87;
    Xstart = 110*m1km + Lx/2;
    Xidx = round(Xstart/dx);
    phih(Xidx:Nx,:) = cp_o*rho_o*cumsum(-UT_tgrid(Xidx:Nx,:)*dy,2,'omitnan');

    Yidx = find(abs((phih(Xidx,:)))>0,1);
    Ystart = yy(Yidx); 
    phih(1:Xidx-1,Yidx:Ny) = repmat(phih(Xidx,Yidx:Ny),[Xidx-1 1]) ...
              + cp_o*rho_o*flip(cumsum(flip(VT_tgrid(1:Xidx-1,Yidx:Ny))*dx,'omitnan'));
    
    phih(phih==0)=NaN;
    %%% TO DO: SUBTRACT FREEZING TEMPERATURE FROM THE HEAT FUNCTION

    %%% TO DO: CALCULATE HEAT FUNCTION FOR THE CDW LAYER


    figure(1)
    set(gcf,'color','w');
    contourf(XX/1000,YY/1000,phih/1e12,[min(min(phih/1e12)):0.2:max(max(phih/1e12))],'EdgeColor','k');  
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-12 0]);colorbar;colormap(flip(WhiteBlueGreenYellowRed(0)));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Horizontal heat function','FontSize',fontsize+3)
    set(gcf,'Position',[204 248 874 601])
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])


    if(savefigure)
    print('-dpng','-r150',[figdir expname '_heatfunc_xy.png']);
    end


    % %%% Calculate the horizontal heatfunction using VT
    % VT_exclude=VT; %%% Exclude the zonal boundary
    % VT_exclude(1:11,:)=0;
    % phi_H = cp_o*rho_o*cumsum(VT_exclude*dx);
    % phi_H(VT==0)=NaN;
    % 
    % %%% Calculate the horizontal heatfunction using UT
    % UT_exclude=UT; %%% Exclude the northern boundary
    % phi_Hu = cp_o*rho_o*flip(cumsum(flip(UT_exclude*dy,2),2,'omitnan'),2);
    % phi_Hu(VT==0)=NaN;


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%% Check horizontal divergence %%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     dFdx = zeros(Nx,Ny);
%     dFdy = zeros(Nx,Ny);
%     dFdx(2:Nx,:) = (UT(2:Nx,:)-UT(1:Nx-1,:))/dx; %%% on mass-grid
%     dFdy(:,1:Ny-1) = (VT(:,2:Ny)-VT(:,1:Ny-1))/dy; %%% on mass-grid
% 
%     divF = dFdx + dFdy;
%     divF_vgrid = zeros(Nx,Ny);
%     divF_vgrid(:,2:Ny) = (divF(:,1:Ny-1)+divF(:,2:Ny))/2;
%     p = abs(divF_vgrid)*dy./VT;
% 
%     %%% Check horizontal divergence by creating a box near the trough, and
%     %%% calculate F_in and F_out.
%     Xboxmin = -200*m1km+Lx/2;
%     Xboxmax = -140*m1km+Lx/2;
%     Yboxmin = 120*m1km;
%     Yboxmax = 190*m1km;e
%     xboxidx = round(Xboxmin/dx):round(Xboxmax/dx);
%     yboxidx = round(Yboxmin/dy):round(Yboxmax/dy);
%     x1 = xboxidx(1); x2 = xboxidx(end);
%     y1 = yboxidx(1); y2 = yboxidx(end);
%     Tin = sum(-VT(xboxidx,y2)*dx) + sum(UT(x1,yboxidx)*dy);
%     Tout = sum(-VT(xboxidx,y1)*dx) + sum(UT(x2,yboxidx)*dy);
% 
%     (Tout-Tin)/(0.5*(Tin+Tout))

end
       