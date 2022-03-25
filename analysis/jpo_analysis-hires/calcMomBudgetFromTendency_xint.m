%%%
%%% calcMomBudgetFromTendency_xint.m
%%%
%%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
%%%

rho0 = 999.8;

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext');
% load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
% 'Um_Cori','Um_AdvZ3','Um_AdvRe');

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% U momentum tendency from surface pressure horizontal gradient == 0,
%%% integrated zonally

%%% U momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_xint = squeeze(rho0.*sum(Um_dPhiX.*DX_xyz,1));
Um_dPhiX_xzint = rho0.*sum(sum(Um_dPhiX.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from Advection terms
Um_Advec_xint = squeeze(rho0.*sum(Um_Advec.*DX_xyz,1));
Um_Advec_xzint = rho0.*sum(sum(Um_Advec.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from Dissipation
Um_Diss_xzint = rho0.*sum(sum(Um_Diss.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from external forcing
Um_Ext_xzint = rho0.*sum(sum(Um_Ext.*hFacW.*DZ_xyz.*DX_xyz,3),1);

% %%% U momentum tendency from Adams-Bashforth
% AB_gU_xzint = rho0.*sum(sum(AB_gU.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))


% %%% U momentum tendency from Vorticity Advection
% Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3.*hFacW.*DZ_xyz.*DX_xyz,3),1);
% 
% %%% U momentum tendency from vertical Advection (Explicit part)
% Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe.*hFacW.*DZ_xyz.*DX_xyz,3),1);
% 
% %%% U momentum tendency from Coriolis term
% Um_Cori_xzint = rho0.*sum(sum(Um_Cori.*hFacW.*DZ_xyz.*DX_xyz,3),1);




% totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint+AB_gU_xzint;
totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint;


%%% Wind stress
rho_a = 1.3;               %%% Air density, kg/m^3
load ([exppath '/input/setParams'],'Ua','Va')
Ua(Ua==0)=1e-8;
uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1);
zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;
windStress_xint = sum(zonalWind.*DX_xy,1);
