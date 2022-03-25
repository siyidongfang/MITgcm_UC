%%% Decompose meridional ocean heat transport temporally into mean, eddy,
%%% tidal heat transport.

clear;close all;
addpath  ..
addpath  ../colormaps;
addpath  ../jpo_analysis/;
addpath  ../jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
%%%%%%
expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
loadexp;

Fmean = zeros(Nx,Ny,Nr); % Mean component of the total advective heat flux
Feddy = zeros(Nx,Ny,Nr); % Eddy component
Ftide = zeros(Nx,Ny,Nr); % Tidal component
G = zeros(Nx,Ny,Nr); % G = \overline{ \overline{v}^t * \overline{theta}^t}^e

DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Output intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dumpFreq =86400; 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

nEND =  size(dumpIters,2);

for nI = 1:nEND
    nI
    Ntime = navg(nI*10-9:nI*10);  
    theta = rdmds([exppath,'/results/THETA.' Ntime]); % Daily-averaged data
    v = rdmds([exppath,'/results/VVEL.' Ntime]);
    G(:,2:Ny,:)  = G(:,2:Ny,:) + 0.5*(theta(:,1:Ny-1,:)+theta(:,2:Ny,:)).*v(:,2:Ny,:)/nEND;      
end

load([prodir expname '_tavg_10yrs.mat'], 'THETA','VVEL','VVELTH');
Fmean(:,2:Ny,:) = 0.5*(THETA(:,1:Ny-1,:)+THETA(:,2:Ny,:)).*VVEL(:,2:Ny,:);
Feddy = G - Fmean;
Ftide = VVELTH - G;

Fmean_xint = squeeze(sum(Fmean.*DX_xyz,1)); 
Feddy_xint = squeeze(sum(Feddy.*DX_xyz,1)); 
Ftide_xint = squeeze(sum(Ftide.*DX_xyz,1)); 
G_xint     = squeeze(sum(G    .*DX_xyz,1)); 

Fmean_zint = sum(Fmean.*hFacS.*DZ_xyz,3);
Feddy_zint = sum(Feddy.*hFacS.*DZ_xyz,3);
Ftide_zint = sum(Ftide.*hFacS.*DZ_xyz,3);
G_zint     = sum(G    .*hFacS.*DZ_xyz,3);

Fmean_xzint = sum(sum(Fmean.*hFacS.*DZ_xyz.*DX_xyz,3),1);
Feddy_xzint = sum(sum(Feddy.*hFacS.*DZ_xyz.*DX_xyz,3),1);
Ftide_xzint = sum(sum(Ftide.*hFacS.*DZ_xyz.*DX_xyz,3),1);
G_xzint     = sum(sum(G    .*hFacS.*DZ_xyz.*DX_xyz,3),1);

save([prodir expname,'_heat_' num2str(nEND) 'days.mat'],'yy',...
    'Fmean','Fmean_xint','Fmean_xzint','Fmean_zint',...
    'Feddy','Feddy_xint','Feddy_xzint','Feddy_zint',...
    'Ftide','Ftide_xint','Ftide_xzint','Ftide_zint',...
    'G','G_xint','G_xzint','G_zint');

