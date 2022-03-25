
  addpath /data/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
  addpath /data/Software/gsw_matlab_v3_06_11/library/;
  addpath /data/Software/gsw_matlab_v3_06_11/;
  
%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);


%%% Matrices for taking derivatives
DYC = zeros(Ny,Nr);
for j=1:Ny
  jm1 = mod(j+Ny-2,Ny) + 1;
  DYC(j,:) = yy(j)-yy(jm1);
end
DZC = zeros(Ny,Nr-1);
for k=1:Nr-1
  DZC(:,k) = zz(k)-zz(k+1);
end

DZC_3D = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Transient eddy form stress %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% uv
uvel_vorgrid(:,2:Ny,:) = (UVEL(:,1:Ny-1,:)+ UVEL(:,2:Ny,:))/2; % vorticity-gird
uvel_vorgrid(:,1,:) = 0;
vvel_vorgrid(2:Nx,:,:) = (VVEL(1:Nx-1,:,:)+ VVEL(2:Nx,:,:))/2; % vorticity-gird
vvel_vorgrid(1,:,:) = (VVEL(1,:,:)+VVEL(Nx,:,:))/2;
uv_tran_eddy =  UV_VEL_Z - uvel_vorgrid.*vvel_vorgrid; % vorticity-gird


%%%%%TODO: CHECK THE VERTICAL GRID
wvel = (WVEL+ WVEL([Nx 1:Nx-1],:,:))/2; % u-grid
wvel(:,:,2:Nr) = (wvel(:,:,1:Nr-1)+wvel(:,:,2:Nr))/2;
wvel(:,:,1) = wvel(:,:,1)/2;       %%%% IS THIS CORRECT?
wu(:,:,2:Nr) = (WU_VEL(:,:,1:Nr-1)+WU_VEL(:,:,2:Nr))/2;
wu(:,:,1) = WU_VEL(:,:,1)/2;   %%%% IS THIS CORRECT?
uw_tran_eddy =  wu - UVEL.*wvel;  % u-grid, middle-level


p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1])+PHIHYD*rho0/1e4;
SA = gsw_SA_from_SP(SALT,p,-12,-64);  %%% Absolute Salinity from Practical Salinity
CT = gsw_CT_from_pt(SA,THETA);         %%% Conservative Temperature from potential temperature

ff = f0+beta*(yy);  % u-grid
f_3D = repmat(reshape(ff,[1 Ny 1]),[Nx 1 Nr]);
f_2D = repmat(ff',[1 Nr]);


Alpha = gsw_alpha(SA,CT,p);   % mass-grid
Beta = gsw_beta(SA,CT,p);    % mass-grid  

dS_dz(:,:,1:Nr-1) = (SALT(:,:,1:Nr-1)-SALT(:,:,2:Nr)) ./ DZC_3D;  % mass-grid, level-1/2
dS_dz(:,:,Nr) = dS_dz(:,:,Nr-1);       %%%% IS THIS CORRECT?
dTheta_dz(:,:,1:Nr-1) = (THETA(:,:,1:Nr-1)-THETA(:,:,2:Nr)) ./ DZC_3D;
dTheta_dz(:,:,Nr) = dTheta_dz(:,:,Nr-1);  %%%% IS THIS CORRECT?
 
dS_dz(:,:,2:Nr) = (dS_dz(:,:,1:Nr-1)+dS_dz(:,:,2:Nr))/2; % mass-grid, middle-level
dS_dz(:,:,1) = dS_dz(:,:,1);   %%%% IS THIS CORRECT?
dTheta_dz(:,:,2:Nr) = (dTheta_dz(:,:,1:Nr-1)+dTheta_dz(:,:,2:Nr))/2; % mass-grid, middle-level
dTheta_dz(:,:,1) = dTheta_dz(:,:,1);   %%%% IS THIS CORRECT?

dgamma_dz = Beta.*dS_dz - Alpha.*dTheta_dz; % mass-grid, middle-level
dgamma_dz = (dgamma_dz+ dgamma_dz([Nx 1:Nx-1],:,:))/2; % u-grid, middle-level

vvel_tgrid(:,1:Ny-1,:) = (VVEL(:,1:Ny-1,:)+VVEL(:,2:Ny,:))/2;     % mass-grid
vvel_tgrid(:,Ny,:) = VVEL(:,Ny,:)/2;  %%%% IS THIS CORRECT?
vvelslt(:,1:Ny-1,:) = (VVELSLT(:,1:Ny-1,:)+VVELSLT(:,2:Ny,:))/2;  % mass-grid
vvelslt(:,Ny,:) = VVELSLT(:,Ny,:)/2;  %%%% IS THIS CORRECT?
vvelth(:,1:Ny-1,:) = (VVELTH(:,1:Ny-1,:)+VVELTH(:,2:Ny,:))/2;  % mass-grid
vvelth(:,Ny,:) = VVELTH(:,Ny,:)/2;  %%%% IS THIS CORRECT?
 
vs_tran = vvelslt - vvel_tgrid.*SALT;
vtheta_tran = vvelth - vvel_tgrid.*THETA;   
vgamma_tran = Beta.*vs_tran - Alpha.*vtheta_tran; % mass-grid
vgamma_tran = (vgamma_tran+ vgamma_tran([Nx 1:Nx-1],:,:))/2; % u-grid, middle-level


%%% Transient eddy form stress
fs_tran_eddy = (f_3D.*vgamma_tran./dgamma_dz); % u-grid, middle-level
fs_tran_eddy(isnan(fs_tran_eddy)) = 0;

uv_tran_eddy_xint = squeeze(nansum(uv_tran_eddy.*DX_xyz,1));
uw_tran_eddy_xint = squeeze(nansum(uw_tran_eddy.*DX_xyz,1));
fs_tran_eddy_xint = squeeze(nansum(fs_tran_eddy.*DX_xyz,1));

uv_tran_eddy_xzint = nansum(nansum((uv_tran_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);
uw_tran_eddy_xzint = nansum(nansum((uw_tran_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);
fs_tran_eddy_xzint = nansum(nansum((fs_tran_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);

% figure(10)
% plot(yy(1:Ny)/1000,fs_transient_eddy_xzint(1:Ny))
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Standing eddy form stress %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u_zonal = squeeze(sum(UVEL.*DX_xyz,1))/Lx;
v_zonal = squeeze(sum(VVEL.*DX_xyz,1))/Lx;
w_zonal = squeeze(sum(WVEL.*DX_xyz,1))/Lx;
T_zonal = squeeze(sum(THETA.*DX_xyz,1))/Lx;
S_zonal = squeeze(sum(SALT.*DX_xyz,1))/Lx;

u_zonal3D = repmat(reshape(u_zonal,[1 Ny Nr]),[Nx 1 1]);
v_zonal3D = repmat(reshape(v_zonal,[1 Ny Nr]),[Nx 1 1]);
w_zonal3D = repmat(reshape(w_zonal,[1 Ny Nr]),[Nx 1 1]);
T_zonal3D = repmat(reshape(T_zonal,[1 Ny Nr]),[Nx 1 1]);
S_zonal3D = repmat(reshape(S_zonal,[1 Ny Nr]),[Nx 1 1]);


%%% uv
u_zonal3D_vorgrid(:,2:Ny,:) = (u_zonal3D(:,1:Ny-1,:)+ u_zonal3D(:,2:Ny,:))/2; % vorticity-gird
u_zonal3D_vorgrid(:,1,:) = 0;
v_zonal3D_vorgrid(2:Nx,:,:) = (v_zonal3D(1:Nx-1,:,:)+ v_zonal3D(2:Nx,:,:))/2; % vorticity-gird
v_zonal3D_vorgrid(1,:,:) = (v_zonal3D(1,:,:)+v_zonal3D(Nx,:,:))/2;

uv_std_eddy =  (uvel_vorgrid - u_zonal3D_vorgrid)...
    .*(vvel_vorgrid - v_zonal3D_vorgrid); % vorticity-gird


%%% wu
%%%%%TODO: CHECK THE VERTICAL GRID
w_zonal3D = (w_zonal3D+ w_zonal3D([Nx 1:Nx-1],:,:))/2; % u-grid
w_zonal3D(:,:,2:Nr) = (w_zonal3D(:,:,1:Nr-1)+w_zonal3D(:,:,2:Nr))/2; % middle level
w_zonal3D(:,:,1) = w_zonal3D(:,:,1)/2;       %%%% IS THIS CORRECT?

uw_std_eddy =  (UVEL - u_zonal3D)...
    .*(wvel - w_zonal3D);  % u-grid, middle-level

%%%
v_zonal3D_tgrid(:,1:Ny-1,:) = (v_zonal3D(:,1:Ny-1,:)+v_zonal3D(:,2:Ny,:))/2;  % mass-grid   % mass-grid
v_zonal3D_tgrid(:,Ny,:) = v_zonal3D(:,Ny,:)/2;  %%%% IS THIS CORRECT?

vs_std = (vvel_tgrid-v_zonal3D_tgrid).*(SALT-S_zonal3D);  % mass-grid
vt_std = (vvel_tgrid-v_zonal3D_tgrid).*(THETA-T_zonal3D);

vgamma_std = Beta.*vs_std - Alpha.*vt_std; % mass-grid
vgamma_std = (vgamma_std+ vgamma_std([Nx 1:Nx-1],:,:))/2; % u-grid, middle-level


%%% Standing eddy form stress
standingCase = 2;

if(standingCase == 1)
    dgamma_dz(dgamma_dz==0) = NaN;
    vgamma_std_xint = squeeze(nansum(vgamma_std.*DX_xyz,1));
    dgamma_dz_xmean =  squeeze(nansum(dgamma_dz.*DX_xyz,1))/Lx;
    fs_std_eddy_xint = (f_2D.*vgamma_std_xint./dgamma_dz_xmean);
    fs_std_eddy_xint(isnan(fs_std_eddy_xint)) = 0;
    hFacW_xmean = squeeze(sum(hFacW.*DX_xyz,1))/Lx;
    fs_std_eddy_xzint = sum((fs_std_eddy_xint).*hFacW_xmean.*DZ,2);

elseif (standingCase == 2)
    dgamma_dz(dgamma_dz==0) = NaN;
    fs_std_eddy = (f_3D.*vgamma_std./dgamma_dz); % u-grid, middle-level
    fs_std_eddy(isnan(fs_std_eddy)) = 0;
    fs_std_eddy_xint = squeeze(nansum(fs_std_eddy.*DX_xyz,1));
    fs_std_eddy_xzint = nansum(nansum((fs_std_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);

end


uv_std_eddy_xint = squeeze(nansum(uv_std_eddy.*DX_xyz,1));
uw_std_eddy_xint = squeeze(nansum(uw_std_eddy.*DX_xyz,1));
uv_std_eddy_xzint = nansum(nansum((uv_std_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);
uw_std_eddy_xzint = nansum(nansum((uw_std_eddy).*hFacW.*DZ_xyz.*DX_xyz,3),1);

figure(11)
plot(yy(1:end)/1000,fs_std_eddy_xzint(1:end))


