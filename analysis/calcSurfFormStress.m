%%%
%%% calcFormStress.m
%%%
%%% Convenience script to calculate the topographic form stress.
%%%


%%% Load velocity
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat']);

ymin = 0;

uu = UVEL;
vv = VVEL;
pp = PHIHYD;

pp = repmat(pp(:,:,1),[1 1 Nr]);

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
dFac = squeeze(1 - min(hFacW,[],1));
hFacE = hFacW([2:Nx 1],:,:);

%%% Form stress
formStress = rho0*squeeze(nansum(pp.*(hFacE-hFacW),1));
formStress(dFac>0) = formStress(dFac>0) ./ dFac(dFac>0);
formStress_yint = sum(formStress(yy>ymin,:).*DY(yy>ymin,:),1);
formStress_zint = sum(formStress.*dFac.*DZ,2)';
formStress_total = sum(sum(formStress.*dFac.*DY.*DZ));

%%% Bottom pressure torque
dpdx = (pp(1:Nx,:,:) - pp([Nx 1:Nx-1],:,:)) ./ DX_xyz;
dpdy = (pp(:,1:Ny,:) - pp(:,[Ny 1:Ny-1],:)) ./ DY_xyz;
dpdx_tot = sum(dpdx.*DZ_xyz.*hFacW,3);
dpdy_tot = sum(dpdy.*DZ_xyz.*hFacS,3);
%%% Rate of change of circulation around grid cell corner
bot_torque = (dpdy_tot.*DY_xy - dpdx_tot.*DX_xy - dpdy_tot([Nx 1:Nx-1],:).*DY_xy + dpdx_tot(:,[Ny 1:Ny-1]).*DX_xy) ./ (DX_xy.*DY_xy);

%%% Surface wind stress
windStress = zonalWind;
windStress_xint = sum(windStress.*DX_xy,1);
westerlyWind = zonalWind;
westerlyWind(westerlyWind<0) = 0;
totalWindStress = sum(sum(westerlyWind.*DX_xy.*DY_xy));

%%% Bottom drag
bd_msk = zeros(Nx,Ny,Nr);
bd_msk(:,:,1:Nr-1) = ceil(hFacW(:,:,1:Nr-1))-ceil(hFacW(:,:,2:Nr));
bd_msk(:,:,Nr) = hFacW(:,:,Nr)>0;
bottomDrag = -rho0*bottomDragLinear*sum(sum(uu.*bd_msk,3).*DX_xy,1);
