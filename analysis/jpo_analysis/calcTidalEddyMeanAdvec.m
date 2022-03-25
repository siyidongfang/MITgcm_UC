%%% Decompose ocean advection temporally into mean, eddy, tidal advection
%%% Use Andrew's discretization codes
loadexp;
load([exppath '/' expname '_tavg_5yrs16-20_momAdvec.mat'],'UVEL','VVEL','WVEL','Um_Advec');

rho0 = 1037;

um = UVEL;
vm = VVEL;
wm = WVEL;

rac = rdmds([exppath,'/results/RAC']);  %%% rac,raw == 4000000
RAC = repmat(rac,[1 1 Nr]);
raw = rdmds([exppath,'/results/RAW']);  %%% rac,raw == 4000000
RAW = repmat(raw,[1 1 Nr]);
drf = rdmds([exppath,'/results/DRF']);
DRF = repmat(reshape(drf,[1 1 Nr]),[Nx Ny 1]);

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

% delR_dudz(1:Nr-1) = (delR(1:Nr-1)+delR(2:Nr))/2; % Grid spacing to calculate dudz
% delR_dudz(Nr) =  delR(Nr)/2; %%% Is this right?
delR_dudz=delR; %% hasn't been used
DZ_dudz = repmat(delR_dudz,[Ny 1]);
DZ_dudz_xyz = repmat(reshape(delR_dudz,[1 1 Nr]),[Nx Ny 1]);

%%% Total advection, 5-yr average
totalAdvec_xzint = rho0.*sum(sum(Um_Advec.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% Mean advection
vm = (vm+ vm([2:Nx 1],:,:))/2; % c-grid location: vorticity
dum_dy(:,1:Ny-1,:) = (um(:,1:Ny-1,:) - um(:,2:Ny,:))./DY_xyz(:,2:Ny,:); % c-grid location: vorticity
dum_dy(:,Ny,:) = 0;
vmdumdy = vm.*dum_dy; % c-grid location: vorticity
vmdumdy(:,2:Ny,:) = (vmdumdy(:,1:Ny-1,:)+vmdumdy(:,2:Ny,:))/2; % c-grid location: u
vmdumdy(:,1,:)=vmdumdy(:,1,:)/2;

meanVorAdv_xzint = rho0.*sum(sum((-vmdumdy).*hFacW.*DZ_xyz.*DX_xyz,3),1);

recip_RAW = 1./raw;
recip_RAW(raw==0) = 0;
recip_RAW = repmat(recip_RAW,[1 1 Nr]);
  
recip_hFacW = 1 ./ hFacW; % Reciprocal of hFacs
recip_hFacW(hFacW==0) = 0;
wmdum_dz = zeros(Nx,Ny,Nr);
wmdum_dz(:,:,2:Nr) = 0.5 * (RAC(1:Nx,:,2:Nr) .* wm(1:Nx,:,2:Nr) + RAC([2:Nx 1],:,2:Nr) .* wm([2:Nx 1],:,2:Nr));
wmdum_dz(:,:,2:Nr) = wmdum_dz(:,:,2:Nr) .* (-diff(um([2:Nx 1],:,:),1,3));
wmdum_dz(:,:,2:Nr) = 0.5 * (wmdum_dz(:,:,1:Nr-1) + wmdum_dz(:,:,2:Nr));
% wmdum_dz = wmdum_dz  .* recip_RAW ./ DRF .* recip_hFacW([2:Nx 1],:,:);
wmdum_dz = wmdum_dz  .* recip_RAW ./ DZ_xyz .* recip_hFacW([2:Nx 1],:,:);

meanVerAdv_xzint = rho0.*sum(sum((-wmdum_dz).*hFacW([2:Nx 1],:,:).*DZ_xyz.*DX_xyz,3),1);
  
meanAdvec = -vmdumdy-wmdum_dz;
meanAdvec_xzint = rho0.*sum(sum(meanAdvec.*hFacW.*DZ_xyz.*DX_xyz,3),1);




%%

%%% Eddy advection
dumpFreq = diag_frequency(1);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

eddyAdvec = zeros(size(meanAdvec));
sumvtdutdy = zeros(size(meanAdvec));
sumwtdutdz = zeros(size(meanAdvec));

wdu_dz_e = zeros(Nx,Ny,Nr);

  
for nI = 1:size(dumpIters,2)
    Ntime = navg(nI*10-9:nI*10);
    vt = rdmds([exppath,'/results/VVEL.' Ntime]); % Daily-averaged data
    ut = rdmds([exppath,'/results/UVEL.' Ntime]);
    wt = rdmds([exppath,'/results/WVEL.' Ntime]);
    
    vt = (vt+ vt([2:Nx 1],:,:))/2; % c-grid location: vorticity
    dut_dy(:,1:Ny-1,:) = (ut(:,1:Ny-1,:) - ut(:,2:Ny,:))./DY_xyz(:,2:Ny,:); % c-grid location: vorticity
    dut_dy(:,Ny,:) = 0;
    vtdutdy = vt.*dut_dy; % c-grid location: vorticity
    vtdutdy(:,2:Ny,:) = (vtdutdy(:,1:Ny-1,:)+vtdutdy(:,2:Ny,:))/2; % c-grid location: u
    vtdutdy(:,1,:)=vtdutdy(:,1,:)/2;
    sumvtdutdy = sumvtdutdy + vtdutdy;
    
    wdu_dz_e(:,:,2:Nr) = 0.5 * (wt(1:Nx,:,2:Nr) + wt([2:Nx 1],:,2:Nr));
    wdu_dz_e(:,:,2:Nr) = wdu_dz_e(:,:,2:Nr) .* (-diff(ut([2:Nx 1],:,:),1,3));
    wdu_dz_e(:,:,2:Nr) = 0.5 * (wdu_dz_e(:,:,1:Nr-1) + wdu_dz_e(:,:,2:Nr));
    wdu_dz_e = wdu_dz_e  ./ DZ_xyz .* recip_hFacW([2:Nx 1],:,:);
  
    
    sumwtdutdz = sumwtdutdz + wdu_dz_e;

    eddyAdvec = eddyAdvec + (-vtdutdy-wdu_dz_e);
end


eddyAdvec = eddyAdvec./(size(dumpIters,2));
eddyAdvec = eddyAdvec - ( -vmdumdy - wmdum_dz);
eddyAdvec_xzint = rho0.*sum(sum(eddyAdvec.*hFacW([2:Nx 1],:,:).*DZ_xyz.*DX_xyz,3),1);

vtdutdy_xzint = rho0.*sum(sum(sumvtdutdy./(size(dumpIters,2)).*hFacW([2:Nx 1],:,:).*DZ_xyz.*DX_xyz,3),1);  %% doublecheck hFacW([2:Nx 1],:,:)
wtdutdz_xzint = rho0.*sum(sum(sumwtdutdz./(size(dumpIters,2)).*hFacW([2:Nx 1],:,:).*DZ_xyz.*DX_xyz,3),1);

eddyVorAdv_xzint = -vtdutdy_xzint - meanVorAdv_xzint;
eddyVerAdv_xzint = -wtdutdz_xzint - meanVerAdv_xzint;

%%% Tidal advection
tidalAdvec_xzint = totalAdvec_xzint - meanAdvec_xzint - eddyAdvec_xzint;

%%% Store computed data for later
save([exppath '/' expname,'tidalEddyMeanAdvec.mat'],'xx','yy','zz','delR','delR_dudz',...
    'totalAdvec_xzint','meanAdvec_xzint','eddyAdvec_xzint','tidalAdvec_xzint',...
    'meanAdvec','eddyAdvec',...
    'meanVorAdv_xzint','meanVerAdv_xzint',...
    'vtdutdy_xzint','wtdutdz_xzint','eddyVorAdv_xzint','eddyVerAdv_xzint');

