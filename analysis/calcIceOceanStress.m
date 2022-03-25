%%%
%%% calcIceOceanStress.m
%%%
%%% Script to calculate the ice-ocean stress.
%%%
%%
Not correct!!!
Should be:
absvol = sqrt((ui-uo).^2+(vi-vo).^2);

tao_iox = Ai.*C_io*rho_o.*absvol.*(ui-uo);   %%% Ice-ocean stress in x direction, N/m2
tao_ioy = Ai.*C_io*rho_o.*absvol.*(vi-vo);   %%% Ice-ocean stress in y direction, N/m2
%%

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab; 
basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
% expdir = '/Volumes/LaCie/'
expname = 'ly0_2kmNr30Nly36_4bumps_atide0.05_ua-5va5_Hi1Ai1Sui0Svi0.1_Ta-10lwdown320Tis-0.65'
%   expname = 'ly01_2kmNr30Nly36_Hshelf500bumps4_atide0.05_ua-5va5_Hi1Ai1Sui0Svi0.1_Ta-10lwdown320Tis-0.65'

loadexp;

OUTPUT = 'avg'
switch (OUTPUT)
    case 'avg'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'mon';
        fname = '.';
    case 'inst'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = '_5d';
        fname = '_inst.';
end

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

C_io = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
rho_o = 1027;                %%% Water density, kg/m^3
Rio = 0; %%% SEAICE_waterTurnAngle

tao_iox = zeros(size(dumpIters,2),Nx,Ny);
tao_ioy = zeros(size(dumpIters,2),Nx,Ny);

% for m = 1:size(dumpIters,2)
for m = 1:106
    Ntime = navg(m*10-9:m*10);
    uvel=rdmds([exppath,'/results/UVEL' fname Ntime]);
    vvel=rdmds([exppath,'/results/VVEL' fname Ntime]);
    uo = squeeze(uvel(:,:,1));
    vo = squeeze(vvel(:,:,1));
    ui=rdmds([exppath,'/results/SIuice' fname Ntime]);
    vi=rdmds([exppath,'/results/SIvice' fname Ntime]);
    Ai=rdmds([exppath,'/results/SIarea' fname Ntime]);
    %%% Note: correct only when ice-ocean turning angle = 0.
    tao_iox(m,:,:) = Ai*C_io*rho_o.*(ui-uo).*abs(ui-uo);   %%% Ice-ocean stress in x direction, N/m2
    tao_ioy(m,:,:) = Ai*C_io*rho_o.*(vi-vo).*abs(vi-uo);   %%% Ice-ocean stress in y direction, N/m2
end


%%% Store computed data for later
save([exppath '/' expname,'_ice-ocn-stress.mat'],'tao_iox','tao_ioy');



