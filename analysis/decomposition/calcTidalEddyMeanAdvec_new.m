%%% Decompose ocean advection temporally into mean, eddy, tidal advection
%%% Use Andrew's discretization codes

clear all;close all;
addpath  ..
addpath  ../colormaps;
addpath  ../jpo_analysis/
expdir = '../../experiments/';
prodir = '../../products-hires/';
%%%%%%
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis' 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Load velocity/advection data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loadexp;
load([prodir expname '_tavg_5yrs.mat'], 'UVEL','VVEL','WVEL','Um_Advec','UVELSQ','WU_VEL','UV_VEL_Z');

rho0 = 999.8;

um = UVEL;
vm = VVEL;
wm = WVEL;       % on mass-grid, model level -1/2
uu_m = UVELSQ;
uw_m = WU_VEL;   % on u-grid, model level -1/2
uv_m = UV_VEL_Z; % on vorticity-grid


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% For storage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u_m_zta = zeros(Nx,Ny,Nr); 
v_m_zta = zeros(Nx,Ny,Nr); 
u_m_L = zeros(Nx,Ny,Nr); 
w_m_ugrid = zeros(Nx,Ny,Nr); 
umvm = zeros(Nx,Ny,Nr); 
umwm = zeros(Nx,Ny,Nr); 
umum = zeros(Nx,Ny,Nr);   
dumvmdy = zeros(Nx,Ny,Nr); 
dumwmdz = zeros(Nx,Ny,Nr); 
dumumdx = zeros(Nx,Ny,Nr); 

utvt = zeros(Nx,Ny,Nr); 
utwt = zeros(Nx,Ny,Nr); 
utut = zeros(Nx,Ny,Nr);    
dutvtdy = zeros(Nx,Ny,Nr); 
dutwtdz = zeros(Nx,Ny,Nr); 
dututdx = zeros(Nx,Ny,Nr); 

duw_mdz = zeros(Nx,Ny,Nr); 
duv_mdy = zeros(Nx,Ny,Nr); 
duu_mdx = zeros(Nx,Ny,Nr); 

meanAdvec = zeros(Nx,Ny,Nr); 
eddyAdvec = zeros(Nx,Ny,Nr); 
tidalAdvec = zeros(Nx,Ny,Nr); 
G = zeros(Nx,Ny,Nr);  
totalAdvec_csi = zeros(Nx,Ny,Nr); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Load grid spacing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rac = rdmds([exppath,'/results/RAC']);  %%% rac,raw == 4000000
RAC = repmat(rac,[1 1 Nr]);
raw = rdmds([exppath,'/results/RAW']);  %%% rac,raw == 4000000
RAW = repmat(raw,[1 1 Nr]);
drf = rdmds([exppath,'/results/DRF']);
DRF = repmat(reshape(drf,[1 1 Nr]),[Nx Ny 1]);
drc = rdmds([exppath,'/results/DRC']);

recip_RAW = 1./raw;
recip_RAW(raw==0) = 0;
recip_RAW = repmat(recip_RAW,[1 1 Nr]);
  
recip_hFacW = 1 ./ hFacW; % Reciprocal of hFacs
recip_hFacW(hFacW==0) = 0;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Grid spacing matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dy = delY(1);
dx = delX(1);
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Output intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dumpFreq =86400; % dumpFreq = diag_frequency(1);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Mean advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u_m_zta(:,1,:) = 0.5.*(0+um(:,1,:));
u_m_zta(:,2:Ny,:) = 0.5.*(um(:,1:Ny-1,:)+um(:,2:Ny,:));    % time-mean u on vorticity grid
v_m_zta(:,:,:) = 0.5.*(vm([Nx 1:Nx-1],:,:)+vm(1:Nx,:,:));  % time-mean v on vorticity grid

u_m_L(:,:,1:Nr-1) = 0.5.*(um(:,:,1:Nr-1)+um(:,:,2:Nr)); % time-mean u on u grid, model level -1/2
u_m_L(:,:,Nr) = 0.5.*(um(:,:,Nr)+0);
w_m_ugrid(:,:,:) = 0.5.*(wm([Nx 1:Nx-1],:,:)+wm(1:Nx,:,:)); % time-mean w on u grid, model level -1/2

umum = um.^2;
umvm = u_m_zta.*v_m_zta; % on vorticity grid
umwm = u_m_L.*w_m_ugrid; % on u grid, model level -1/2

dumvmdy(:,1:Ny-1,:) = diff(umvm,1,2)./dy; % on u grid
dumvmdy(:,Ny,:) = (0-umvm(:,Ny,:))./dy;

dumwmdz(:,:,2:Nr) = -diff(umwm,1,3)./DRF(:,:,2:Nr); % on u grid
% dumwmdz(:,:,1) = -(umwm(:,:,1)-0)./DRF(:,:,1);
dumwmdz(:,:,1) = 0;

dumumdx = (umum([2:Nx 1],:,:)-umum([Nx 1:Nx-1],:,:))./(2*dx); % Centered difference, on u grid

dumvmdy_xzint = rho0.*sum(sum(dumvmdy.*hFacW.*DZ_xyz.*DX_xyz,3),1);
dumwmdz_xzint = rho0.*sum(sum(dumwmdz.*hFacW.*DZ_xyz.*DX_xyz,3),1);
dumumdx_xzint = rho0.*sum(sum(dumumdx.*hFacW.*DZ_xyz.*DX_xyz,3),1);
  
meanAdvec = -dumvmdy-dumwmdz-dumumdx;
meanAdvec_xzint = rho0.*sum(sum(meanAdvec.*hFacW.*DZ_xyz.*DX_xyz,3),1);



%% Loop

nEND = 540; % nEND =  size(dumpIters,2); %1825; ref 1350; ssurf33 540; sdiff3 675

for nI = 1:nEND
    nI
    Ntime = navg(nI*10-9:nI*10);
    vt = rdmds([exppath,'/results/VVEL.' Ntime]); % Daily-averaged data
    ut = rdmds([exppath,'/results/UVEL.' Ntime]);
    wt = rdmds([exppath,'/results/WVEL.' Ntime]);
    
    u_t_zta(:,1,:) = 0.5.*(0+ut(:,1,:));
    u_t_zta(:,2:Ny,:) = 0.5.*(ut(:,1:Ny-1,:)+ut(:,2:Ny,:));    % time-mean u on vorticity grid
    v_t_zta(:,:,:) = 0.5.*(vt([Nx 1:Nx-1],:,:)+vt(1:Nx,:,:));  % time-mean v on vorticity grid

    u_t_L(:,:,1:Nr-1) = 0.5.*(ut(:,:,1:Nr-1)+ut(:,:,2:Nr)); % time-mean u on u grid, model level -1/2
    u_t_L(:,:,Nr) = 0.5.*(ut(:,:,Nr)+0);
    w_t_ugrid(:,:,:) = 0.5.*(wt([Nx 1:Nx-1],:,:)+wt(1:Nx,:,:)); % time-mean w on u grid, model level -1/2

    utut = ut.^2;
    utvt = u_t_zta.*v_t_zta; % on vorticity grid
    utwt = u_t_L.*w_t_ugrid; % on u grid, model level -1/2

    dutvtdy(:,1:Ny-1,:) = dutvtdy(:,1:Ny-1,:) + diff(utvt,1,2)./dy ./nEND; % on u grid
    dutvtdy(:,Ny,:) = dutvtdy(:,Ny,:) + (0-utvt(:,Ny,:))./dy ./nEND;
    dutwtdz(:,:,2:Nr) = dutwtdz(:,:,2:Nr) - diff(utwt,1,3)./DRF(:,:,2:Nr) ./nEND; % on u grid
%     dutwtdz(:,:,1) = dutwtdz(:,:,1) - (utwt(:,:,1)-0)./DRF(:,:,1) ./nEND;
    dutwtdz(:,:,1) = 0;
    
    dututdx = dututdx + (utut([2:Nx 1],:,:)-utut([Nx 1:Nx-1],:,:))./(2*dx) ./nEND; % Centered difference, on u grid
end

dutvtdy_xzint = rho0.*sum(sum(dutvtdy.*hFacW.*DZ_xyz.*DX_xyz,3),1);
dutwtdz_xzint = rho0.*sum(sum(dutwtdz.*hFacW.*DZ_xyz.*DX_xyz,3),1);
dututdx_xzint = rho0.*sum(sum(dututdx.*hFacW.*DZ_xyz.*DX_xyz,3),1);

G = -dutvtdy-dutwtdz-dututdx;
G_xzint = rho0.*sum(sum(G.*hFacW.*DZ_xyz.*DX_xyz,3),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Eddy advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eddyAdvec = G - meanAdvec;
eddyAdvec_xzint = rho0.*sum(sum(eddyAdvec.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Tidal advection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


duv_mdy(:,1:Ny-1,:) = diff(uv_m,1,2)./dy;  % on u grid
duv_mdy(:,Ny,:) = (0-uv_m(:,Ny,:))./dy;

duw_mdz(:,:,2:Nr) = -diff(uw_m,1,3)./DRF(:,:,2:Nr); % on u grid
% duw_mdz(:,:,1) = -(uw_m(:,:,1)-0)./DRF(:,:,1);
duw_mdz(:,:,1) = 0;

duu_mdx = (uu_m([2:Nx 1],:,:)-uu_m([Nx 1:Nx-1],:,:))./(2*dx);   % Centered difference, on u grid

duv_mdy_xzint = rho0.*sum(sum(duv_mdy.*hFacW.*DZ_xyz.*DX_xyz,3),1);
duw_mdz_xzint = rho0.*sum(sum(duw_mdz.*hFacW.*DZ_xyz.*DX_xyz,3),1);
duu_mdx_xzint = rho0.*sum(sum(duu_mdx.*hFacW.*DZ_xyz.*DX_xyz,3),1);

tidalAdvec = -duv_mdy -duw_mdz -duu_mdx -G;
tidalAdvec_xzint = rho0.*sum(sum(tidalAdvec.*hFacW.*DZ_xyz.*DX_xyz,3),1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Total advection, calculated by this script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalAdvec_csi = meanAdvec + eddyAdvec + tidalAdvec;
totalAdvec_csi_xzint = rho0.*sum(sum(totalAdvec_csi.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% 5-yr averaged total advection in MITgcm output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalAdvec_MITgcm = Um_Advec;
totalAdvec_MITgcm_xzint = rho0.*sum(sum(Um_Advec.*hFacW.*DZ_xyz.*DX_xyz,3),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Store computed data for later
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save([expname,'_tidalEddyMeanAdvec_new_' num2str(nEND) 'days.mat'],'xx','yy','zz','delR',...
    'meanAdvec_xzint','eddyAdvec_xzint','tidalAdvec_xzint','G_xzint',...
    'totalAdvec_MITgcm_xzint','totalAdvec_csi_xzint',...
    'dumvmdy_xzint','dumwmdz_xzint','dumumdx_xzint',...
    'dutvtdy_xzint','dutwtdz_xzint','dututdx_xzint',...
    'duv_mdy_xzint','duw_mdz_xzint','duu_mdx_xzint');

    %'meanAdvec','eddyAdvec','tidalAdvec','G',...
    %'totalAdvec_MITgcm','totalAdvec_csi',...
    %'umvm','umwm','umum',...
    %'dumvmdy','dumwmdz','dumumdx',...
    %'dutvtdy','dutwtdz','dututdx',...
    %'duv_mdy','duw_mdz','duu_mdx',...
