
    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_new/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigrue = true;
    savefigure = false;

    n=1;
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;

    DXG = rdmds(fullfile(resultspath,'DXG'));
    DYF = rdmds(fullfile(resultspath,'DYF'));
    RAZ = rdmds(fullfile(resultspath,'RAZ'));  

    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Vm_dPhiY');


    %%
    %%% momentum tendency from hydrostatic pressure gradient
    
    %%% Find bottom indices

    for i=1:Nx
        for j=1:Ny   
            vertical_cdwidx = find(hFacC(i,j,:)==1);
            if(~isnan(vertical_cdwidx))
                bot_idx(i,j) = vertical_cdwidx(end);%%% vertical index of the bottom layer
                surf_idx(i,j) = vertical_cdwidx(1); %%% vertical index of the surface
            else
                bot_idx(i,j) = NaN;
                surf_idx(i,j) = NaN;
            end
        end
    end

% figure(1)
% pcolor(bot_idx(:,1:51));shading flat;colorbar;clim([15 38])
% figure(2)
% pcolor(surf_idx(:,1:51));shading flat;colorbar;clim([15 38])


kbot = max(max(bot_idx(:,1:51)));
ksurf = max(max(surf_idx(:,1:51)));

    Um_dPhiX_zint = zeros(Nx,Ny);
    Vm_dPhiY_zint = zeros(Nx,Ny);

    kz_surf = zeros(Nx,Ny);
    kz_bot = zeros(Nx,Ny);

    kz = kz_surf;
       
    for i=1:Nx
        for j=1:Ny
            kz = 1:ksurf;
%             kz = kbot:Nr;
            Um_dPhiX_zint(i,j) = rho0.*sum(Um_dPhiX(i,j,kz).*hFacW(i,j,kz).*DZ(i,j,kz),3,'omitnan');
            Vm_dPhiY_zint(i,j) = rho0.*sum(Vm_dPhiY(i,j,kz).*hFacS(i,j,kz).*DZ(i,j,kz),3,'omitnan');
        end
    end



    %%% Pressure torque
    zeta_dPhi = zeros(Nx,Ny);   
    
    for i = 2:Nx
        for j = 2:Ny
            zeta_dPhi(i,j) = ( Um_dPhiX_zint(i,j-1)*DXG(i,j-1) + Vm_dPhiY_zint(i,j)*DYF(i,j) ...
                             - Um_dPhiX_zint(i,j)*DXG(i,j)     - Vm_dPhiY_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);  
        end
    end

    fontsize = 18;
    load_colors;
    YLIM = [0 400];
    CLIM = [-1 1]/1e5;

    figure(1)
    clf;set(gcf,'color','w');
    pcolor(XX/1000,YY/1000,zeta_dPhi)
    shading flat;colorbar;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    caxis(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:100:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    title('pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)



