%%%
%%% calc_BTvorticity_int_curl.m
%%%
%%% Calculate the barotropic vorticity budget using model diagnostics
%%% First vertically integrate the momentum budget terms, then take the
%%% curl


load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
    'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

DXG = rdmds(fullfile(resultspath,'DXG'));
DYF = rdmds(fullfile(resultspath,'DYF'));
RAZ = rdmds(fullfile(resultspath,'RAZ'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated momentum equation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% momentum tendency from hydrostatic pressure gradient
Um_dPhiX_zint = rho0.*sum(Um_dPhiX.*hFacW.*DZ,3);
Vm_dPhiY_zint = rho0.*sum(Vm_dPhiY.*hFacS.*DZ,3);

%%% momentum tendency from advection terms
Um_Advec_zint = rho0.*sum(Um_Advec.*hFacW.*DZ,3);
Vm_Advec_zint = rho0.*sum(Vm_Advec.*hFacS.*DZ,3);

%%% momentum tendency from dissipation
Um_Diss_zint = rho0.*sum(Um_Diss.*hFacW.*DZ,3);
Vm_Diss_zint = rho0.*sum(Vm_Diss.*hFacS.*DZ,3);

%%% momentum tendency from external forcing (ice-ocean stress)
Um_Ext_zint = rho0.*sum(Um_Ext.*hFacW.*DZ,3);
Vm_Ext_zint = rho0.*sum(Vm_Ext.*hFacS.*DZ,3);

%%% Residual term
residualU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
residualV = Vm_dPhiY_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;

%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3);
Vm_Cori_zint = rho0.*sum(Vm_Cori.*hFacS.*DZ,3);
 
%%% momentum tendency from Vorticity Advection
Um_AdvZ3_zint = rho0.*sum(Um_AdvZ3.*hFacW.*DZ,3);
Vm_AdvZ3_zint = rho0.*sum(Vm_AdvZ3.*hFacS.*DZ,3);

%%% momentum tendency from Vertical Advection (Explicit part)
Um_AdvRe_zint = rho0.*sum(Um_AdvRe.*hFacW.*DZ,3);
Vm_AdvRe_zint = rho0.*sum(Vm_AdvRe.*hFacS.*DZ,3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_dPhi = zeros(Nx,Ny);
zeta_Advec = zeros(Nx,Ny);
zeta_Diss = zeros(Nx,Ny);
zeta_Ext = zeros(Nx,Ny);

for i = 2:Nx
    for j = 2:Ny
        %%% Pressure torque
        zeta_dPhi(i,j) = ( Um_dPhiX_zint(i,j-1)*DXG(i,j-1) + Vm_dPhiY_zint(i,j)*DYF(i,j) ...
                         - Um_dPhiX_zint(i,j)*DXG(i,j)     - Vm_dPhiY_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
        
        %%% Advection term
        zeta_Advec(i,j) = ( Um_Advec_zint(i,j-1)*DXG(i,j-1) + Vm_Advec_zint(i,j)*DYF(i,j) ...
                          - Um_Advec_zint(i,j)*DXG(i,j)     - Vm_Advec_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
        
        %%% Dissipation term
        zeta_Diss(i,j) = ( Um_Diss_zint(i,j-1)*DXG(i,j-1) + Vm_Diss_zint(i,j)*DYF(i,j) ...
                         - Um_Diss_zint(i,j)*DXG(i,j)     - Vm_Diss_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
       
        %%% Surface stress term
        zeta_Ext(i,j) = ( Um_Ext_zint(i,j-1)*DXG(i,j-1) + Vm_Ext_zint(i,j)*DYF(i,j) ...
                        - Um_Ext_zint(i,j)*DXG(i,j)     - Vm_Ext_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);   
    end
end
      
%%% Residual term
zeta_residual = zeta_dPhi + zeta_Advec + zeta_Diss + zeta_Ext;

zeta_dPhi(zeta_dPhi==0)=NaN;
zeta_Advec(zeta_Advec==0)=NaN;
zeta_Diss(zeta_Diss==0)=NaN;
zeta_Ext(zeta_Ext==0)=NaN;
zeta_residual(zeta_residual==0)=NaN;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VV = sum(vv.*hFacS.*DZ,3);
zeta_Cori_betaV = -rho0*beta.*VV;
zeta_Cori_betaV(zeta_Cori_betaV==0)=NaN;

zeta_Cori = zeros(Nx,Ny);
zeta_AdvZ3 = zeros(Nx,Ny);
zeta_AdvRe = zeros(Nx,Ny);

for i = 2:Nx
    for j = 2:Ny
        %%% Coriolis term (planetary vorticity advection)
        zeta_Cori(i,j) = ( Um_Cori_zint(i,j-1)*DXG(i,j-1) + Vm_Cori_zint(i,j)*DYF(i,j) ...
                         - Um_Cori_zint(i,j)*DXG(i,j)     - Vm_Cori_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 

        %%% Vorticity Advection
        zeta_AdvZ3(i,j) = ( Um_AdvZ3_zint(i,j-1)*DXG(i,j-1) + Vm_AdvZ3_zint(i,j)*DYF(i,j) ...
                          - Um_AdvZ3_zint(i,j)*DXG(i,j)     - Vm_AdvZ3_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);

        %%% Vertical Advection (Explicit part)
        zeta_AdvRe(i,j) = ( Um_AdvRe_zint(i,j-1)*DXG(i,j-1) + Vm_AdvRe_zint(i,j)*DYF(i,j) ...
                          - Um_AdvRe_zint(i,j)*DXG(i,j)     - Vm_AdvRe_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);
    end
end

zeta_Cori(zeta_Cori==0)=NaN;
zeta_AdvZ3(zeta_AdvZ3==0)=NaN;
zeta_AdvRe(zeta_AdvRe==0)=NaN;

%%% Nonlinear advection term
zeta_nonLin = zeta_Advec - zeta_Cori; 

%%% Ageostrophic term
zeta_ageo = zeta_Advec + zeta_dPhi;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 18;
load_colors;
figure(1)
set(gcf,'Position',[234 88 1361 1110])
clf;set(gcf,'color','w');
subplot(3,2,1)
pcolor(XX/1000,YY/1000,zeta_dPhi)
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('Pressure torque (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,2)
pcolor(XX/1000,YY/1000,zeta_Advec)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,3)
pcolor(XX/1000,YY/1000,zeta_Diss)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Dissipation term (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,4)
pcolor(XX/1000,YY/1000,zeta_Ext)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Surface stress term (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,5)
pcolor(XX/1000,YY/1000,zeta_residual)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Residual term  (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_vort.png']);
end

% figure(2)
% set(gcf,'Position',[90 232 2201 776])
% clf;set(gcf,'color','w');
% subplot(2,3,1)
% colormap(cmocean('balance'));
% pcolor(XX/1000,YY/1000,zeta_Cori)
% shading flat;colorbar;
% caxis([-1 1]/1e5);
% title('Coriolis term (model diagnosed) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,2)
% pcolor(XX/1000,YY/1000,zeta_AdvZ3)
% shading flat;colorbar;
% caxis([-1 1]/1e5);
% title('Vorticity Advection (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,3)
% pcolor(XX/1000,YY/1000,zeta_AdvRe)
% shading flat;colorbar;
% caxis([-1 1]/1e5);
% title('Vertical Advection (explicit part) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,5)
% pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e5);
% title('Total Adv - (Cori + Vort Adv + Vert Adv) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_decomposeAdv.png']);
% end
% 
% 
% figure(3)
% clf;set(gcf,'color','w');
% pcolor(XX/1000,YY/1000,zeta_Cori_betaV)
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e5);
% title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_betaV.png']);
% end
