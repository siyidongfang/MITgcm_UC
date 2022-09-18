%%%
%%% calc_BTvorticity.m
%%%
%%% Calculate the barotropic vorticity budget


    load([prodir expname '_tavg_5yrs.mat'],'Um_Ext','Vm_Ext',...
        'Um_Cori','Vm_Cori','Um_dPhiX','Vm_dPhiY','Um_Diss','Vm_Diss',...
        'Um_Advec','Vm_Advec','VISrI_Um','VISrI_Vm');

%     TODO: 1. TOTUTEND, TOTVTEND
%     2. Surface pressure torque
%     3. There must be something wrong with the nonlinear term (way too large)

    dxC = rdmds(fullfile(resultspath,'DXC'));
    dyC = rdmds(fullfile(resultspath,'DYC'));
    rAz = rdmds(fullfile(resultspath,'RAZ'));
    drF = rdmds(fullfile(resultspath,'DRF'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated momentum equation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Um_Ext_int = sum(Um_Ext.*DZ.*hFacW,3); 
    Vm_Ext_int = sum(Vm_Ext.*DZ.*hFacS,3); 
    
    Um_Cori_int = sum(Um_Cori.*DZ.*hFacW,3); 
    Vm_Cori_int = sum(Vm_Cori.*DZ.*hFacS,3); 
    
    Um_dPHdx_int = sum(Um_dPhiX.*DZ.*hFacW,3); 
    Vm_dPHdy_int = sum(Vm_dPhiY.*DZ.*hFacS,3); 
    
    Um_Diss_int = sum(Um_Diss.*DZ.*hFacW,3); 
    Vm_Diss_int = sum(Vm_Diss.*DZ.*hFacS,3); 
    
    Um_Advec_int = sum(Um_Advec.*DZ.*hFacW,3); 
    Vm_Advec_int = sum(Vm_Advec.*DZ.*hFacS,3); 
    
    latViscU_int = sum(VISrI_Um.*DZ,3); 
    latViscV_int = sum(VISrI_Vm.*DZ,3); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Surface and bottom stress terms 
d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_Ext_int.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_Ext_int.*dyC);
zeta_wind_int = ( d1 + d2 ) ./rAz;        % Surface stress curl

d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_Diss_int.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_Diss_int.*dyC);
zeta_bottomDrag_int = ( d1 + d2 ) ./rAz;  % Bottom frictional stress curl

zeta_tau_bt = zeta_wind_int+zeta_bottomDrag_int;

%%% Planetary vorticity advection
d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_Cori_int.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_Cori_int.*dyC);
zeta_cori_bt = ( d1 + d2 ) ./rAz;

%%% Hydrostatic pressure torque
d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_dPHdx_int.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_dPHdy_int.*dyC);
zeta_phiHyd_int = ( d1 + d2 ) ./rAz;  

%%% Surface pressure torque
dETANdx = zeros(Nx,Ny);
dETANdx(2:Nx,:) = diff(ETAN)/dx; % u-grid
depth_x = sum(hFacW.*drF,3,'omitnan');
Um_dETANdx=dETANdx.*depth_x;

dETANdy = zeros(Nx,Ny);
dETANdy(:,2:Ny) = diff(ETAN,1,2)/dy; % v-grid
depth_y = sum(hFacS.*drF,3,'omitnan');
Vm_dETANdy=dETANdy.*depth_y;

d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_dETANdx.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_dETANdy.*dyC);
zeta_phiSurf_int = ( d1 + d2 ) ./rAz;  

zeta_phiSurf_int = zeros(Nx,Ny);
%%% The bottom pressure torque = surface pressure torque + hydrostatic pressure torque
zeta_bpt_bt = zeta_phiHyd_int+zeta_phiSurf_int;

%%% non-linear term
d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(latViscU_int.*dxC,1,2);
d2(2:Nx,:) =  diff(latViscV_int.*dyC);
zeta_ViscLat_int = ( d1 + d2 ) ./rAz;
zeta_A_bt = zeta_ViscLat_int;
zeta_A_bt =0;
    
%%% Viscous term
d1 = zeros(Nx,Ny);
d2 = zeros(Nx,Ny);
d1(:,2:Ny) = -diff(Um_Advec_int.*dxC,1,2);
d2(2:Nx,:) =  diff(Vm_Advec_int.*dyC);
zeta_Adv_int = ( d1 + d2 ) ./rAz;
zeta_AB_int = 0;
zeta_B_bt = (zeta_Adv_int-zeta_cori_bt)+zeta_AB_int;
    
    
%%% Residual term
residual_BTvort = zeta_tau_bt + zeta_bpt_bt + zeta_A_bt + zeta_B_bt + zeta_cori_bt;
    
 

fontsize = 18;
load_colors;
figure(1)
subplot(3,3,1)
pcolor(XX/1000,YY/1000,rho0*zeta_wind_int)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Ice-ocean stress curl')
set(gca,'FontSize',fontsize);

subplot(3,3,2)
pcolor(XX/1000,YY/1000,rho0*zeta_bottomDrag_int)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8); 
title('Bottom frictional stress curl')
set(gca,'FontSize',fontsize);


% subplot(3,3,4)
% pcolor(zeta_A_bt)
% shading flat;colorbar;colormap(redblue);caxis([-5 5]/1e2);
% set(gca,'FontSize',fontsize);

subplot(3,3,4)
pcolor(XX/1000,YY/1000,rho0*zeta_Adv_int)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Total advection')
set(gca,'FontSize',fontsize);

subplot(3,3,5)
pcolor(XX/1000,YY/1000,rho0*zeta_cori_bt)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Planetary vorticity advection')
set(gca,'FontSize',fontsize);

subplot(3,3,6)
pcolor(XX/1000,YY/1000,rho0*zeta_B_bt)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Nonlinear term  = Total adv. - Planetary vort. adv.')
set(gca,'FontSize',fontsize);

subplot(3,3,7)
pcolor(XX/1000,YY/1000,rho0*zeta_phiHyd_int)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Hydrostatic pressure torque')
set(gca,'FontSize',fontsize);

subplot(3,3,8)
pcolor(XX/1000,YY/1000,rho0*zeta_phiSurf_int)
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8);
title('Surface pressure torque')
set(gca,'FontSize',fontsize);

subplot(3,3,9)
pcolor(XX/1000,YY/1000,rho0*residual_BTvort);
shading flat;colorbar;colormap(redblue);caxis(rho0*[-1 1]/1e8/10);
title('Residual')
set(gca,'FontSize',fontsize);

if(savefigure)
print('-dpng','-r150',[figdir expname '_vorticity.png']);
end


%     zeta_bpt_bt = zeta_phiHyd_int+zeta_phiSurf_int;


% %%%%%%%%%%%%%%%%%%%%%
% %%% Save the data %%%
% %%%%%%%%%%%%%%%%%%%%%
%     
%     
%     
%     
%     
% 
