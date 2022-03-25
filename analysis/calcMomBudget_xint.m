%%%
%%% calcMomBudget_xint.m
%%%
%%% Convenience script to calculate the topographic form stress.
%%%

rho0 = 1037;
ymin = 0;


%%% Load velocity
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','PHIHYD','UV_VEL_Z',...
    'oceTAUX','oceTAUY','Um_Diss','Um_Cori');

rho_a = 1.3;               %%% Air density, kg/m^3
load ([exppath '/input/setParams'],'Ua','Va')
uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1);
zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;
meridionalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;


uu = UVEL;
vv = VVEL;
pp = PHIHYD;

%%% Set true to calculate advective flux divergence
calc_adv_stress = true;

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
% dFac = squeeze(1 - min(hFacW,[],1));
dFac_bumps = squeeze(nanmean(1 - hFacW));
% dFac3D = (1-hFacW);
hFacE = hFacW([2:Nx 1],:,:);

%%% Form stress
% formStress = rho0*squeeze(nansum(pp.*(hFacE-hFacW),1));
% formStress(dFac>0) = formStress(dFac>0) ./ dFac(dFac>0);
% formStress_yint = sum(formStress(yy>ymin,:).*DY(yy>ymin,:),1);
% formStress_zint = sum(formStress.*dFac.*DZ,2)';
% formStress_total = sum(sum(formStress.*dFac.*DY.*DZ));

% %%% Form stress with bumps
formStress = rho0*squeeze(nansum(pp.*(hFacE-hFacW),1));
formStress(dFac_bumps>0) = formStress(dFac_bumps>0) ./ dFac_bumps(dFac_bumps>0);
formStress_yint = sum(formStress(yy>ymin,:).*DY(yy>ymin,:),1);
formStress_zint = sum(formStress.*dFac_bumps.*DZ,2)';
formStress_total = sum(sum(formStress.*dFac_bumps.*DY.*DZ));

% %%% Form stress with bumps???? Is this wrong?
% formStress3D = rho0*(pp.*(hFacE-hFacW));
% formStress3D(dFac3D>0) = formStress3D(dFac3D>0) ./ dFac3D(dFac3D>0);
% formStress_zint = sum(formStress3D.*dFac3D.*DZ_xyz,3)';
% formStress_total = sum(sum(formStress.*dFac_bumps.*DY.*DZ));

%%% Bottom pressure torque
dpdx = (pp(1:Nx,:,:) - pp([Nx 1:Nx-1],:,:)) ./ DX_xyz;
dpdy = (pp(:,1:Ny,:) - pp(:,[Ny 1:Ny-1],:)) ./ DY_xyz;
dpdx_tot = sum(dpdx.*DZ_xyz.*hFacW,3);
dpdy_tot = sum(dpdy.*DZ_xyz.*hFacS,3);
%%% Rate of change of circulation around grid cell corner
bot_torque = (dpdy_tot.*DY_xy - dpdx_tot.*DX_xy - dpdy_tot([Nx 1:Nx-1],:).*DY_xy + ...
    dpdx_tot(:,[Ny 1:Ny-1]).*DX_xy) ./ (DX_xy.*DY_xy);

%%% Surface wind stress
windStress = zonalWind;
windStress_xint = sum(windStress.*DX_xy,1);
% westerlyWind = zonalWind;
% westerlyWind(westerlyWind<0) = 0;
% totalWindStress = sum(sum(westerlyWind.*DX_xy.*DY_xy));
% % 
% %%% Linear bottom drag
% bd_msk = zeros(Nx,Ny,Nr);
% bd_msk(:,:,1:Nr-1) = ceil(hFacW(:,:,1:Nr-1))-ceil(hFacW(:,:,2:Nr));
% bd_msk(:,:,Nr) = hFacW(:,:,Nr)>0;
% bottomDrag = -rho0*bottomDragLinear*sum(sum(uu.*bd_msk,3).*DX_xy,1);

%%% Quadratic bottom drag
bd_msk_forU = zeros(Nx,Ny,Nr);
bd_msk_forU(:,:,1:Nr-1) = ceil(hFacW(:,:,1:Nr-1))-ceil(hFacW(:,:,2:Nr));
bd_msk_forU(:,:,Nr) = hFacW(:,:,Nr)>0;
ubot = sum(uu.*bd_msk_forU,3); %%% bottom u
bd_msk_forV = zeros(Nx,Ny,Nr);
bd_msk_forV(:,:,1:Nr-1) = ceil(hFacS(:,:,1:Nr-1))-ceil(hFacS(:,:,2:Nr));
bd_msk_forV(:,:,Nr) = hFacS(:,:,Nr)>0;
vbot_vpoint = sum(vv.*bd_msk_forV,3); %%% bottom v, at C-grid V point
vbot_vorpoint(2:Nx,:,:) = (vbot_vpoint(1:Nx-1,:,:)+ vbot_vpoint(2:Nx,:,:))/2; % c-grid location: vorticity
vbot_vorpoint(1,:,:) = (vbot_vpoint(1,:,:)+vbot_vpoint(Nx,:,:))/2;
vbot(:,2:Ny,:) = (vbot_vorpoint(:,1:Ny-1,:)+ vbot_vorpoint(:,2:Ny,:))/2; % c-grid location: U
vbot(:,1,:) = 0;
botdrag_x = sqrt(ubot.^2+vbot.^2).*ubot;
bottomDrag = -rho0*bottomDragQuadratic*sum(botdrag_x.*DX_xy,1); % integrate in x direction


%%% TODO is hFacS the right matrix here?
%%% Advective flux divergence
%%% Use hFacS, vorticity-grid
% if (calc_adv_stress)
%   uv = UV_VEL_Z;
%   uv_mean = (0.5*(uu(:,[1:Ny],:)+uu(:,[Ny 1:Ny-1],:))) .*  (0.5*(vv([1:Nx],:,:)+vv([Nx 1:Nx-1],:,:)));
%   uv_eddy = uv - uv_mean;
%   uv_mean_tot = sum(sum(uv_mean.*hFacS.*DZ_xyz.*DX_xyz,3),1);
%   uv_eddy_tot = sum(sum(uv_eddy.*hFacS.*DZ_xyz.*DX_xyz,3),1);
%   advConv_mean(2:Ny) = - rho0 * (uv_mean_tot(2:Ny) - uv_mean_tot(1:Ny-1)) ./ delY(2:Ny);
%   advConv_eddy(2:Ny) = - rho0 * (uv_eddy_tot(2:Ny) - uv_eddy_tot(1:Ny-1)) ./ delY(2:Ny);
%   advConv_mean(1) = 0;
%   advConv_eddy(1) = 0;
% end

% %%% Use hFacW, vorticity-grid
% if (calc_adv_stress)
%   uv = UV_VEL_Z;
%   uv_mean = (0.5*(uu(:,[1:Ny],:)+uu(:,[Ny 1:Ny-1],:))) .*  (0.5*(vv([1:Nx],:,:)+vv([Nx 1:Nx-1],:,:))); % c-grid location: vorticity
%   uv_eddy = uv - uv_mean; % c-grid location: vorticity
%   uv_mean_tot = sum(sum(uv_mean.*hFacW.*DZ_xyz.*DX_xyz,3),1);
%   uv_eddy_tot = sum(sum(uv_eddy.*hFacW.*DZ_xyz.*DX_xyz,3),1);
%   advConv_mean = - rho0 * (uv_mean_tot([2:Ny 1]) - uv_mean_tot(1:Ny)) ./ delY;
%   advConv_eddy = - rho0 * (uv_eddy_tot([2:Ny 1]) - uv_eddy_tot(1:Ny)) ./ delY;
% end

%%% Use hFacW, U-grid
hFacW_vor(:,2:Ny,:) = (hFacW(:,1:Ny-1,:)+ hFacW(:,2:Ny,:))/2; % c-grid location: U
hFacW_vor(:,1,:) = hFacW(:,1,:);

if (calc_adv_stress)
  uv = UV_VEL_Z;
  uu_vor(:,2:Ny,:) = (uu(:,1:Ny-1,:)+ uu(:,2:Ny,:))/2; % c-grid location: vorticity
  uu_vor(:,1,:) = 0;
  vv_vor(2:Nx,:,:) = (vv(1:Nx-1,:,:)+ vv(2:Nx,:,:))/2; % c-grid location: vorticity
  vv_vor(1,:,:) = (VVEL(1,:,:)+VVEL(Nx,:,:))/2;
  uv_mean = uu_vor.*vv_vor; % c-grid location: vorticity
  uv_eddy = uv - uv_mean; % c-grid location: vorticity
  
  uv_mean(:,2:Ny,:) = (uv_mean(:,1:Ny-1,:)+ uv_mean(:,2:Ny,:))/2; % c-grid location: U
  uv_mean(:,1,:) = 0;
  uv_eddy(:,2:Ny,:) = (uv_eddy(:,1:Ny-1,:)+ uv_eddy(:,2:Ny,:))/2; % c-grid location: U
  uv_eddy(:,1,:) = 0;
%   hFacVor(2:Nx,:,:) = (hFacW(1:Nx-1,:,:)+ hFacW(2:Nx,:,:))/2; 
%   hFacVor(1,:,:) = (hFacW(1,:,:)+hFacW(Nx,:,:))/2;
%   uv_mean_tot = sum(sum(uv_mean.*hFacVor.*DZ_xyz.*DX_xyz,3),1);
%   uv_eddy_tot = sum(sum(uv_eddy.*hFacVor.*DZ_xyz.*DX_xyz,3),1);
  uv_mean_tot = sum(sum(uv_mean.*hFacW_vor.*DZ_xyz.*DX_xyz,3),1);
  uv_eddy_tot = sum(sum(uv_eddy.*hFacW_vor.*DZ_xyz.*DX_xyz,3),1);
  advConv_mean(2:Ny) = - rho0 * (uv_mean_tot(2:Ny) - uv_mean_tot(1:Ny-1)) ./ delY(2:Ny);
  advConv_eddy(2:Ny) = - rho0 * (uv_eddy_tot(2:Ny) - uv_eddy_tot(1:Ny-1)) ./ delY(2:Ny);
  advConv_mean(1) = 0;
  advConv_eddy(1) = 0;
end




%%%%%%%%%%%%%%%
%%% For ice-ocean stress calculation
C_io = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
Rio = 0; %%% SEAICE_waterTurnAngle

tao_iox_xint = sum(oceTAUX(:,:,1).*DX_xy,1);
tao_ioy_xint = sum(oceTAUY(:,:,1).*DX_xy,1);

for i = 1:size(UVEL,1)
    for j = 2:size(UVEL,2)-1
        n_bot = UVEL(i,j,:)~=0;
        idx_bot(i,j) = sum(n_bot);
        uobot(i,j) = squeeze(UVEL(i,j,idx_bot(i,j)));
        vobot(i,j) = squeeze(VVEL(i,j,idx_bot(i,j)));
    end
    uobot(i,225) = 0;
    vobot(i,225) = 0;
end

absvolb = sqrt(uobot.^2+vobot.^2);

tau_bx = bottomDragQuadratic*rho0.*absvolb.*uobot; % estimated bottom stress in x direction
tau_by = bottomDragQuadratic*rho0.*absvolb.*vobot; 

tau_bx_xavg = nanmean(tau_bx,1);
tau_by_xavg = nanmean(tau_by,1);

IceOceanDrag = tao_iox_xint;
% bottomDrag = tau_bx_xavg*Lx;

%%% Coriolis 
coriolisfv = sum(sum(f0*rho0.*VVEL.*hFacS.*DZ_xyz.*DX_xyz,3),1);

% %%% U momentum tendency from Coriolis term
% coriolisfv = rho0.*sum(sum(Um_Cori.*hFacW.*DZ_xyz.*DX_xyz,3),1);




%%% U momentum tendency from Dissipation
Um_Diss_xzint = rho0.*sum(sum(Um_Diss.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%%%%%%%%%%%%% Tidal Forcing

totalchange = IceOceanDrag+formStress_zint+Um_Diss_xzint+advConv_mean+advConv_eddy+coriolisfv;