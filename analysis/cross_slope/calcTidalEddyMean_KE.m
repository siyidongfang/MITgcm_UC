%%% Decompose the total kinetic energy temporally into mean, eddy,
%%% tidal kinetic energy.
%%% KE: Total kinetic energy
%%% MKE: Mean component of the total KE
%%% EKE: Eddy component
%%% TKE: Tidal component
%%% G = 0.5 * \overline{ \overline{ \bm{u}^T^2 }^E, a conversion term

clear;close all;
addpath  ..
addpath  ../colormaps;
addpath  ../jpo_analysis/;
addpath  ../jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
%%%%%%
expname = 'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
loadexp;

load([prodir expname '_tavg_10yrs.mat'], 'UVEL','VVEL','WVEL','UVELSQ','VVELSQ','WVELSQ');

DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);


DRC = rdmds(fullfile(resultspath,'DRC')); % Nr+1
DZ_drc_xyz = repmat(reshape(squeeze(DRC(2:Nr+1))',[1 1 Nr]),[Nx Ny 1]);
for i = 1:Nx
    for j=1:Ny
        idx = WVEL(i,j,:)~=0;
        sumidx = sum(idx);
        if(sumidx~=0)
           DZ_drc_xyz(i,j,1:sumidx) = DZ_drc_xyz(i,j,idx); %%% Double check!!
        end
    end
end

KEuv =  0.5 * ( 0.5 * (UVELSQ(1:Nx,:,:) + UVELSQ([2:Nx 1],:,:)) + ...
                0.5 * (VVELSQ(:,1:Ny,:) + VVELSQ(:,[2:Ny 1],:))); % exclude WVELSQ
KEw = 0.5*WVELSQ;

MKEuv = 0.5 * ( 0.5 * (UVEL(1:Nx,:,:).^2 + UVEL([2:Nx 1],:,:).^2) + ...
                0.5 * (VVEL(:,1:Ny,:).^2 + VVEL(:,[2:Ny 1],:).^2) ); % exclude WVEL^2
MKEw=0.5*WVEL.^2;

            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Output intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dumpFreq =86400; 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

nEND =  size(dumpIters,2);

Guv = zeros(Nx,Ny,Nr);
Gw  = zeros(Nx,Ny,Nr);

for nI = 1:nEND
    nI
    Ntime = navg(nI*10-9:nI*10);  
    UVEL = rdmds([exppath,'/results/UVEL.' Ntime]);  % Daily-averaged data
    VVEL = rdmds([exppath,'/results/VVEL.' Ntime]); 
    WVEL = rdmds([exppath,'/results/WVEL.' Ntime]);     
  
    Guv = Guv + (0.5 * ( 0.5 * (UVEL(1:Nx,:,:).^2 + UVEL([2:Nx 1],:,:).^2) + ...
                    0.5 * (VVEL(:,1:Ny,:).^2 + VVEL(:,[2:Ny 1],:).^2) ))/nEND; % exclude WVEL^2 
    Gw = Gw + 0.5 * WVEL.^2/nEND;  
end

TKEuv = KEuv - Guv;
TKEw  = KEw - Gw;
EKEuv = Guv - MKEuv;
EKEw  = Gw - MKEw;

save([prodir expname,'_KE_' num2str(nEND) 'days.mat'],'yy','xx','zz',...
'KEuv','KEw','MKEuv','MKEw','TKEuv','TKEw','EKEuv','EKEw','Guv','Gw'...
  );



