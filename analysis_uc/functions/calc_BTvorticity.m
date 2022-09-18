%%%
%%% calc_BTvorticity.m
%%%
%%% Calculate the barotropic vorticity budget


load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext');

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

% if(useSHELFICE)
%     load([prodir '/' expname '_tavg_5yrs.mat'],'SHI_TauX','SHI_TauY')
%     Um_Diss_zint = Um_Diss_zint - SHI_TauX;
%     Vm_Diss_zint = Vm_Diss_zint - SHI_TauY;
% end

%%% Residual term
residualU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
residualV = Vm_dPhiY_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;

%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3);
Vm_Cori_zint = rho0.*sum(Vm_Cori.*hFacS.*DZ,3);
    

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
zeta_Cori = zeros(Nx,Ny);
for i = 2:Nx
    for j = 2:Ny
        %%% Coriolis term (planetary vorticity advection)
        zeta_Cori(i,j) = ( Um_Cori_zint(i,j-1)*DXG(i,j-1) + Vm_Cori_zint(i,j)*DYF(i,j) ...
                         - Um_Cori_zint(i,j)*DXG(i,j)     - Vm_Cori_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
    end
end
zeta_Cori(zeta_Cori==0)=NaN;

load([prodir '/' expname '_tavg_5yrs.mat'],'VVEL');
zeta_Cori_betaV = rho0*beta.*sum(VVEL.*hFacS.*DZ,3);
zeta_Cori_betaV(zeta_Cori_betaV==0)=NaN;

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
clf;set(gcf,'color','w');
subplot(3,2,1)
pcolor(XX/1000,YY/1000,zeta_dPhi)
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('Pressure torque (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,2)
pcolor(XX/1000,YY/1000,zeta_Advec)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Advection term = Coriolis + nonlinear  (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,3)
pcolor(XX/1000,YY/1000,zeta_Diss)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Dissipation term (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,4)
pcolor(XX/1000,YY/1000,zeta_Ext)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Surface stress term (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,5)
pcolor(XX/1000,YY/1000,zeta_residual)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Residual term  (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')


figure(2)
clf;set(gcf,'color','w');
subplot(3,2,1)
pcolor(XX/1000,YY/1000,zeta_Cori)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Coriolis term (model diagnosed) (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,2)
pcolor(XX/1000,YY/1000,zeta_nonLin)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Nonlinear advection term = Advec. - Cori. (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,3)
pcolor(XX/1000,YY/1000,zeta_Cori_betaV)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('\rho_0 \beta V (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

% subplot(3,2,5)
% pcolor(XX/1000,YY/1000,zeta_ageo)
% shading flat;colorbar;
% caxis([-1 1]/1e5);
% title('Ageostrophic term = Advec. + Pressure torque')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

