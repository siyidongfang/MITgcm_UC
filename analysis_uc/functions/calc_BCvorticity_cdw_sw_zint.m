

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated momentum equation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% momentum tendency from hydrostatic pressure gradient
Um_dPhiX_zint = rho0.*sum(mask_ugrid.*Um_dPhiXf.*hFacWf.*DZf,3,'omitnan');
Vm_dPhiY_zint = rho0.*sum(mask_vgrid.*Vm_dPhiYf.*hFacSf.*DZf,3,'omitnan');

%%% momentum tendency from advection terms
Um_Advec_zint = rho0.*sum(mask_ugrid.*Um_Advecf.*hFacWf.*DZf,3,'omitnan');
Vm_Advec_zint = rho0.*sum(mask_vgrid.*Vm_Advecf.*hFacSf.*DZf,3,'omitnan');

%%% momentum tendency from dissipation
Um_Diss_zint = rho0.*sum(mask_ugrid.*Um_Dissf.*hFacWf.*DZf,3,'omitnan');
Vm_Diss_zint = rho0.*sum(mask_vgrid.*Vm_Dissf.*hFacSf.*DZf,3,'omitnan');

%%% momentum tendency from external forcing (ice-ocean stress)
Um_Ext_zint = rho0.*sum(mask_ugrid.*Um_Extf.*hFacWf.*DZf,3,'omitnan');
Vm_Ext_zint = rho0.*sum(mask_vgrid.*Vm_Extf.*hFacSf.*DZf,3,'omitnan');

%%% Residual term
residualU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
residualV = Vm_dPhiY_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint; 

%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(mask_ugrid.*Um_Corif.*hFacWf.*DZf,3,'omitnan');
Vm_Cori_zint = rho0.*sum(mask_vgrid.*Vm_Corif.*hFacSf.*DZf,3,'omitnan');

%%% momentum tendency from Vorticity Advection
Um_AdvZ3_zint = rho0.*sum(mask_ugrid.*Um_AdvZ3f.*hFacWf.*DZf,3,'omitnan');
Vm_AdvZ3_zint = rho0.*sum(mask_vgrid.*Vm_AdvZ3f.*hFacSf.*DZf,3,'omitnan');

%%% momentum tendency from Vertical Advection (Explicit part)
Um_AdvRe_zint = rho0.*sum(mask_ugrid.*Um_AdvRef.*hFacWf.*DZf,3,'omitnan');
Vm_AdvRe_zint = rho0.*sum(mask_vgrid.*Vm_AdvRef.*hFacSf.*DZf,3,'omitnan');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_dPhi = zeros(Nxf,Nyf);
zeta_Advec = zeros(Nxf,Nyf);
zeta_Diss = zeros(Nxf,Nyf);
zeta_Ext = zeros(Nxf,Nyf);

for i = 2:Nxf
    for j = 2:Nyf
        %%% Pressure torque
        zeta_dPhi(i,j) = ( Um_dPhiX_zint(i,j-1)*DXGf(i,j-1) + Vm_dPhiY_zint(i,j)*DYFf(i,j) ...
                         - Um_dPhiX_zint(i,j)*DXGf(i,j)     - Vm_dPhiY_zint(i-1,j)*DYFf(i-1,j) ) ./RAZf(i,j); 
        
        %%% Advection term
        zeta_Advec(i,j) = ( Um_Advec_zint(i,j-1)*DXGf(i,j-1) + Vm_Advec_zint(i,j)*DYFf(i,j) ...
                          - Um_Advec_zint(i,j)*DXGf(i,j)     - Vm_Advec_zint(i-1,j)*DYFf(i-1,j) ) ./RAZf(i,j); 
        
        %%% Dissipation term
        zeta_Diss(i,j) = ( Um_Diss_zint(i,j-1)*DXGf(i,j-1) + Vm_Diss_zint(i,j)*DYFf(i,j) ...
                         - Um_Diss_zint(i,j)*DXGf(i,j)     - Vm_Diss_zint(i-1,j)*DYFf(i-1,j) ) ./RAZf(i,j); 
       
        %%% Surface stress term
        zeta_Ext(i,j) = ( Um_Ext_zint(i,j-1)*DXGf(i,j-1) + Vm_Ext_zint(i,j)*DYFf(i,j) ...
                        - Um_Ext_zint(i,j)*DXGf(i,j)     - Vm_Ext_zint(i-1,j)*DYFf(i-1,j) ) ./RAZf(i,j);   
    end
end
      
%%% Residual term
zeta_residual = zeta_dPhi + zeta_Advec + zeta_Diss + zeta_Ext;

zeta_dPhi(zeta_dPhi==0)=NaN;
zeta_Advec(zeta_Advec==0)=NaN;
zeta_Diss(zeta_Diss==0)=NaN;
zeta_Ext(zeta_Ext==0)=NaN;
zeta_residual(zeta_residual==0)=NaN;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


save(prodname,...
    'Um_dPhiX_zint','Vm_dPhiY_zint','Um_Advec_zint','Vm_Advec_zint',...
    'Um_Diss_zint','Vm_Diss_zint','Um_Ext_zint','Vm_Ext_zint',...
    'residualU','residualV','Um_Cori_zint','Vm_Cori_zint',...
    'Um_AdvZ3_zint','Vm_AdvZ3_zint','Um_AdvRe_zint','Vm_AdvRe_zint',...
    'zeta_dPhi','zeta_Advec','zeta_Diss','zeta_Ext','zeta_residual',...
    'zeta_Cori','zeta_AdvZ3','zeta_AdvRe','zeta_nonLin','zeta_ageo',...
    'XXf','YYf')
