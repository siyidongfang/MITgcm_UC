%%% Decompose ocean advection temporally into mean, eddy, tidal advection
%%% Use the exact model discretization

clear;close all;
addpath  ..
addpath  ../colormaps;
addpath  ../jpo_analysis/;
addpath  ../jpo_analysis-hires/;
expdir = '../../experiments/';
% expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
prodir = '../../products-hires/';
%%%%%%
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod' 
% exppath = [expdir expname];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Load velocity/advection data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loadexp;
% Nx = 400; Ny = 448; Nr = 70;
load([prodir expname '_tavg_5yrs.mat'], 'UVEL','VVEL','WVEL','Um_Advec','UVELSQ','VVELSQ','WU_VEL','UV_VEL_Z');

rho0 = 999.8;

use_exact_disc = true;
use_fourth_vort = false;

idx_uv = 2:Nx+1;
idx_ts = 2:Nx+1;
idx_dx = 1:Nx;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% For storage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hFacC = zeros(Nx+1,Ny,Nr);
hFacS = zeros(Nx+2,Ny,Nr);
hFacW = zeros(Nx+2,Ny,Nr);
rac = zeros(Nx+1,Ny,1);
raw = zeros(Nx,Ny,1);
raz = zeros(Nx+1,Ny,1);

dxc = zeros(Nx+2,Ny,1);
dyc = zeros(Nx+2,Ny,1);
dxg = zeros(Nx+2,Ny,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Load grid spacing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFacC(idx_ts,:,:) = rdmds([exppath,'/results/hFacC']);
hFacC(1,:,:) =hFacC(Nx+1,:,:);
hFacS(idx_uv,:,:) = rdmds([exppath,'/results/hFacS']);
hFacS(1,:)=hFacS(Nx+1,:); hFacS(Nx+2,:)=hFacS(2,:);
hFacW(idx_uv,:,:) = rdmds([exppath,'/results/hFacW']);
hFacW(1,:)=hFacW(Nx+1,:); hFacW(Nx+2,:)=hFacW(2,:);

rac(idx_ts,:,:) = rdmds([exppath,'/results/RAC']);  %%% rac,raw,raz == 4000000 (hires: 1.0045e+06)
rac(1,:,:) =rac(Nx+1,:,:);

raw = rdmds([exppath,'/results/RAW']);  %%% rac,raw,raz == 4000000
raz(idx_dx,:,:) = rdmds([exppath,'/results/RAZ']); %surface area of the vorticity cell
raz(Nx+1,:,:)=raz(1,:,:);


recip_RAZ = 1./raz;
recip_RAZ(raz==0) = 0;
recip_RAZ = repmat(recip_RAZ,[1 1 Nr]);

recip_RAW = 1./raw;
recip_RAW(raw==0) = 0;
recip_RAW = repmat(recip_RAW,[1 1 Nr]);
  
recip_hFacW = 1 ./ hFacW; % Reciprocal of hFacs
recip_hFacW(hFacW==0) = 0;


drf = rdmds([exppath,'/results/DRF']);
drc = rdmds([exppath,'/results/DRC']);
dxc(idx_uv,:) = rdmds([exppath,'/results/DXC']);
dxc(1,:)=dxc(Nx+1,:); dxc(Nx+2,:)=dxc(2,:);
dyc(idx_uv,:) = rdmds([exppath,'/results/DYC']);
dyc(1,:)=dyc(Nx+1,:); dyc(Nx+2,:)=dyc(2,:);
dxg(idx_uv,:,1) = rdmds([exppath,'/results/DXG']);
dxg(1,:)=dxg(Nx+1,:); dxg(Nx+2,:)=dxg(2,:);
% dxv = rdmds([exppath,'/results/DXV']);




RAC = repmat(rac,[1 1 Nr]);
RAW = repmat(raw,[1 1 Nr]);
DRF = repmat(reshape(drf,[1 1 Nr]),[Nx Ny 1]);

DXC = repmat(dxc,[1 1 Nr]);
DYC = repmat(dyc,[1 1 Nr]);
DXG = repmat(dxg,[1 1 Nr]);
% DXV = repmat(dxv,[1 1 Nr]);

  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Output intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dumpFreq =86400; % dumpFreq = diag_frequency(1);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Compute data for mean advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% For storage
u = zeros(Nx+2,Ny,Nr);
v = zeros(Nx+2,Ny,Nr);
w = zeros(Nx+1,Ny,Nr);
KE = zeros(Nx+2,Ny,Nr); 
half_dKEdx_avg = zeros(Nx,Ny,Nr);
vz_avg = zeros(Nx,Ny,Nr);  
wdu_dz_avg = zeros(Nx,Ny,Nr);

%%% Add zonal "halo" points
%%% Periodical boundary in the zonal direction
u(idx_uv,:,:) = UVEL;
v(idx_uv,:,:) = VVEL;
w(idx_ts,:,:) = WVEL;
u(1,:,:)=u(Nx+1,:,:); u(Nx+2,:,:)=u(2,:,:);
v(1,:,:)=v(Nx+1,:,:); v(Nx+2,:,:)=v(2,:,:);
w(1,:,:)=w(Nx+1,:,:); 

%%% Kinetic energy, on mass-grid
KE(1:end-1,1:end-1,:) = 0.5 * (u(1:end-1,1:end-1,:).^2+u(2:end,1:end-1,:).^2+v(1:end-1,1:end-1,:).^2+v(1:end-1,2:end,:).^2); %     KE(1:Nx,1:Ny-1,:) = 0.5 * (u(1:Nx,1:Ny-1,:).^2+u([2:Nx-1 1],1:Ny-1,:).^2+v(1:Nx,1:Ny-1,:).^2+v(1:Nx,2:Ny,:).^2);
gradKE =  diff(KE,1,1)./DXC(1:end-1,:,:);
half_dKEdx = 0.5*gradKE(1:Nx,:,:);

%%% Compute vorticity on cell corners, including an additional corner
%%% along the eastern edge of the grid cells at i=Nx    
zeta = zeros(Nx+1,Ny,Nr);
zeta(1:Nx+1,2:Ny,:) = ( v(2:Nx+2,2:Ny,:) .* DYC(2:Nx+2,2:Ny,:) ...
                    - u(2:Nx+2,2:Ny,:) .* DXC(2:Nx+2,2:Ny,:) ...
                    - v(1:Nx+1,2:Ny,:) .* DYC(1:Nx+1,2:Ny,:) ...
                    + u(2:Nx+2,1:Ny-1,:) .* DXC(2:Nx+2,1:Ny-1,:) ) ...
                    .* recip_RAZ(1:Nx+1,2:Ny,:);                          


%%% Vorticity stretching terms, on u-grid
if (use_exact_disc)
  wdu_dz = zeros(Nx,Ny,Nr+1);
  wdu_dz(:,:,2:Nr) = 0.5 * (RAC(1:Nx,:,2:Nr).*w(1:Nx,:,2:Nr) + RAC(2:Nx+1,:,2:Nr).*w(2:Nx+1,:,2:Nr));
  wdu_dz(:,:,2:Nr) = wdu_dz(:,:,2:Nr) .* (-diff(u(2:Nx+1,:,:),1,3));
  wdu_dz = 0.5 * (wdu_dz(:,:,1:Nr) + wdu_dz(:,:,2:Nr+1));
  wdu_dz = wdu_dz .* recip_RAW ./ DRF .* recip_hFacW(2:Nx+1,:,:);
else    
  %%% Old discretization
  wdu_dz(:,:,2:end) = -diff(u(2:end-1,:,:),1,3) ./ DRC(:,:,2:end-1) ...
                   .* 0.5.*(w(1:end-1,:,2:end)+w(2:end,:,2:end));    
end



%%% Vorticity fluxes, on u-grid
%%% NOTE: This follows the MITgcm discretization, and includes the
%%% fourth-order correction term, which adds vorticities from two
%%% gridpoints away
%%% TODO fourth-order terms require a larger "halo" 
if (use_exact_disc)
  vz = v .* DXG .* hFacS;
  vz = 0.5 * (vz(1:Nx,:,:) + vz(2:Nx+1,:,:));
  vz(:,1:Ny-1,:) = 0.5 * (vz(:,1:Ny-1,:) + vz(:,2:Ny,:));

  if (use_fourth_vort)
    vz(:,2:Ny-2,:) = vz(:,2:Ny-2,:) .* 0.5 .* (  ...
                        zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1,:) ...
                      + (1/12) .* (-zeta(1:Nx,1:Ny-3,:) + zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1) - zeta(1:Nx,4:Ny)) ...
                   ) ./ DXC(2:Nx+1,2:Ny-2,:);
    vz(:,[1 Ny-1 Ny],:) = 0;
  else
    vz(:,1:Ny-1,:) = vz(:,1:Ny-1,:) .* 0.5 .* (zeta(1:Nx,1:Ny-1,:) + zeta(1:Nx,2:Ny,:)) ./ DXC(2:Nx+1,1:Ny-1,:);
    vz(:,Ny,:) = 0;
  end
  vz(hFacW(2:Nx+1,:,:)==0) = 0;
else
  vz(1:end,:,:) = v(1:end,:,:) .* 0.5.*(zeta(1:end-1,:,:)+zeta(2:end,:,:));
end

KE_m = KE;
half_dKEdx_m = half_dKEdx;
vz_m = vz;
wdu_dz_m = wdu_dz;


KE_m_xzint = rho0.*sum(sum(KE_m(idx_uv,:,:).*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
half_dKEdx_m_xzint = rho0.*sum(sum(half_dKEdx_m.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
wdu_dz_m_xzint = rho0.*sum(sum(wdu_dz_m.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
vz_m_xzint = rho0.*sum(sum(vz_m.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);

    

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Compute data for tidal advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% For storage
u = zeros(Nx+2,Ny,Nr);
v = zeros(Nx+2,Ny,Nr);
w = zeros(Nx+1,Ny,Nr);
KE = zeros(Nx+2,Ny,Nr); 
KE_avg = zeros(Nx+2,Ny,Nr); 
half_dKEdx_avg = zeros(Nx,Ny,Nr);
vz_avg = zeros(Nx,Ny,Nr);  
wdu_dz_avg = zeros(Nx,Ny,Nr);

% nEND = 675; % %1825; ref 1350; ssurf33 540; sdiff3 675
nEND =  size(dumpIters,2); 

for nI = 1:nEND
        nI
        Ntime = navg(nI*10-9:nI*10);

        %%% Add zonal "halo" points
        %%% Periodical boundary in the zonal direction
        u(idx_uv,:,:) = rdmds([exppath,'/results/UVEL.' Ntime]); % Daily-averaged data
        v(idx_uv,:,:) = rdmds([exppath,'/results/VVEL.' Ntime]);
        w(idx_ts,:,:) = rdmds([exppath,'/results/WVEL.' Ntime]);
        u(1,:,:)=u(Nx+1,:,:); u(Nx+2,:,:)=u(2,:,:);
        v(1,:,:)=v(Nx+1,:,:); v(Nx+2,:,:)=v(2,:,:);
        w(1,:,:)=w(Nx+1,:,:); 

        %%% Kinetic energy, on mass-grid
        KE(1:end-1,1:end-1,:) = 0.5 * (u(1:end-1,1:end-1,:).^2+u(2:end,1:end-1,:).^2+v(1:end-1,1:end-1,:).^2+v(1:end-1,2:end,:).^2); %     KE(1:Nx,1:Ny-1,:) = 0.5 * (u(1:Nx,1:Ny-1,:).^2+u([2:Nx-1 1],1:Ny-1,:).^2+v(1:Nx,1:Ny-1,:).^2+v(1:Nx,2:Ny,:).^2);
        gradKE =  diff(KE,1,1)./DXC(1:end-1,:,:);
        half_dKEdx = 0.5*gradKE(1:Nx,:,:);
        
        %%% Compute vorticity on cell corners, including an additional corner
        %%% along the eastern edge of the grid cells at i=Nx    
        zeta = zeros(Nx+1,Ny,Nr);
        zeta(1:Nx+1,2:Ny,:) = ( v(2:Nx+2,2:Ny,:) .* DYC(2:Nx+2,2:Ny,:) ...
                            - u(2:Nx+2,2:Ny,:) .* DXC(2:Nx+2,2:Ny,:) ...
                            - v(1:Nx+1,2:Ny,:) .* DYC(1:Nx+1,2:Ny,:) ...
                            + u(2:Nx+2,1:Ny-1,:) .* DXC(2:Nx+2,1:Ny-1,:) ) ...
                            .* recip_RAZ(1:Nx+1,2:Ny,:);                          


        %%% Vorticity stretching terms, on u-grid
        if (use_exact_disc)
          wdu_dz = zeros(Nx,Ny,Nr+1);
          wdu_dz(:,:,2:Nr) = 0.5 * (RAC(1:Nx,:,2:Nr).*w(1:Nx,:,2:Nr) + RAC(2:Nx+1,:,2:Nr).*w(2:Nx+1,:,2:Nr));
          wdu_dz(:,:,2:Nr) = wdu_dz(:,:,2:Nr) .* (-diff(u(2:Nx+1,:,:),1,3));
          wdu_dz = 0.5 * (wdu_dz(:,:,1:Nr) + wdu_dz(:,:,2:Nr+1));
          wdu_dz = wdu_dz .* recip_RAW ./ DRF .* recip_hFacW(2:Nx+1,:,:);
        else    
          %%% Old discretization
          wdu_dz(:,:,2:end) = -diff(u(2:end-1,:,:),1,3) ./ DRC(:,:,2:end-1) ...
                           .* 0.5.*(w(1:end-1,:,2:end)+w(2:end,:,2:end));    
        end



        %%% Vorticity fluxes, on u-grid
        %%% NOTE: This follows the MITgcm discretization, and includes the
        %%% fourth-order correction term, which adds vorticities from two
        %%% gridpoints away
        %%% TODO fourth-order terms require a larger "halo" 
        if (use_exact_disc)
          vz = v .* DXG .* hFacS;
          vz = 0.5 * (vz(1:Nx,:,:) + vz(2:Nx+1,:,:));
          vz(:,1:Ny-1,:) = 0.5 * (vz(:,1:Ny-1,:) + vz(:,2:Ny,:));

          if (use_fourth_vort)
            vz(:,2:Ny-2,:) = vz(:,2:Ny-2,:) .* 0.5 .* (  ...
                                zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1,:) ...
                              + (1/12) .* (-zeta(1:Nx,1:Ny-3,:) + zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1) - zeta(1:Nx,4:Ny)) ...
                           ) ./ DXC(2:Nx+1,2:Ny-2,:);
            vz(:,[1 Ny-1 Ny],:) = 0;
          else
            vz(:,1:Ny-1,:) = vz(:,1:Ny-1,:) .* 0.5 .* (zeta(1:Nx,1:Ny-1,:) + zeta(1:Nx,2:Ny,:)) ./ DXC(2:Nx+1,1:Ny-1,:);
            vz(:,Ny,:) = 0;
          end
          vz(hFacW(2:Nx+1,:,:)==0) = 0;
        else
          vz(1:end,:,:) = v(1:end,:,:) .* 0.5.*(zeta(1:end-1,:,:)+zeta(2:end,:,:));
        end
        
        
        KE_avg = KE_avg + KE/nEND;
        half_dKEdx_avg = half_dKEdx_avg + half_dKEdx/nEND;
        wdu_dz_avg = wdu_dz_avg + wdu_dz/nEND;
        vz_avg = vz_avg + vz/nEND;
        
       

end % end the loop

KE_avg_xzint = rho0.*sum(sum(KE_avg(idx_uv,:,:).*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
half_dKEdx_avg_xzint = rho0.*sum(sum(half_dKEdx_avg.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
wdu_dz_avg_xzint = rho0.*sum(sum(wdu_dz_avg.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
vz_avg_xzint = rho0.*sum(sum(vz_avg.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);

G = -half_dKEdx_avg +vz_avg -wdu_dz_avg;
G_xzint = rho0.*sum(sum(G.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Mean advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanAdvec = -half_dKEdx_m +vz_m -wdu_dz_m;
meanAdvec_xzint = rho0.*sum(sum(meanAdvec.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Eddy advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eddyAdvec = G - meanAdvec;
eddyAdvec_xzint = rho0.*sum(sum(eddyAdvec.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Total advection, calculated by this script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uu_m = zeros(Nx+2,Ny,Nr);
vv_m = zeros(Nx+2,Ny,Nr);
uu_m(idx_uv,:,:) = UVELSQ;
vv_m(idx_uv,:,:) = VVELSQ;
uu_m(1,:,:)=uu_m(Nx+1,:,:); uu_m(Nx+2,:,:)=uu_m(2,:,:);
vv_m(1,:,:)=vv_m(Nx+1,:,:); vv_m(Nx+2,:,:)=vv_m(2,:,:);

uw_m = zeros(Nx,Ny,Nr+1);
uw_m(:,:,2:Nr+1) = WU_VEL;
uv_m = UV_VEL_Z;


KE_tot = zeros(Nx+2,Ny,Nr); 
KE_tot(1:end-1,1:end-1,:) = 0.5 * (uu_m(1:end-1,1:end-1,:)+uu_m(2:end,1:end-1,:)+vv_m(1:end-1,1:end-1,:)+vv_m(1:end-1,2:end,:));
gradKE_tot =  diff(KE_tot,1,1)./DXC(1:end-1,:,:);
dKEdx_tot = 2* 0.5*gradKE_tot(1:Nx,:,:);


dvv_mdx = zeros(Nx+1,Ny,Nr);
dvv_mdx(:,1:Ny-1,:) = 0.5.* (vv_m(1:Nx+1,1:Ny-1,:) + vv_m(1:Nx+1,2:Ny,:));% on u grid
dvv_mdx(:,Ny,:)=0;

dvv_mdx = diff(dvv_mdx,1,1)./DXC(idx_uv,:,:);

duv_mdy(:,1:Ny-1,:) = diff(uv_m,1,2)./DYC(idx_uv,1:Ny-1,:);  % on u grid
duv_mdy(:,Ny,:) = (0-uv_m(:,Ny,:))./DYC(idx_uv,Ny,:);

%????????????????
duw_mdz = -diff(uw_m,1,3)./DRF .* recip_hFacW(2:Nx+1,:,:); % on u grid


dKEdx_tot_xzint = rho0.*sum(sum(dKEdx_tot.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
dvv_mdx_xzint = rho0.*sum(sum(dvv_mdx.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
duv_mdy_xzint = rho0.*sum(sum(duv_mdy.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
duw_mdz_xzint = rho0.*sum(sum(duw_mdz.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);
%%

totalAdvec_csi = -dKEdx_tot +dvv_mdx -duv_mdy -duw_mdz;
totalAdvec_csi_xzint = rho0.*sum(sum(totalAdvec_csi.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% 5-yr averaged total advection in MITgcm output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalAdvec_MITgcm = Um_Advec;
totalAdvec_MITgcm_xzint = rho0.*sum(sum(Um_Advec.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Tidal advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tidalAdvec_csi = totalAdvec_csi - G;
tidalAdvec_csi_xzint = rho0.*sum(sum(tidalAdvec_csi.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);


tidalAdvec_MITgcm = totalAdvec_MITgcm - G;
tidalAdvec_MITgcm_xzint = rho0.*sum(sum(tidalAdvec_MITgcm.*hFacW(idx_uv,:,:).*DRF.*DXC(idx_uv,:,:),3),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Store computed data for later
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save([expname,'_tidalEddyMeanAdvec_exact_' num2str(nEND) 'days.mat'],'yy',...
    'meanAdvec_xzint','eddyAdvec_xzint','G_xzint',...
    'tidalAdvec_csi_xzint','tidalAdvec_MITgcm_xzint',...
    'totalAdvec_MITgcm_xzint','totalAdvec_csi_xzint',...
    'KE_m_xzint','half_dKEdx_m_xzint','wdu_dz_m_xzint','vz_m_xzint',...
    'KE_avg_xzint','half_dKEdx_avg_xzint','wdu_dz_avg_xzint','vz_avg_xzint',...
    'dKEdx_tot_xzint','dvv_mdx_xzint','duv_mdy_xzint','duw_mdz_xzint');


