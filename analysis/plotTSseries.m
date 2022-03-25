%%%
%%% plotTSseries.m
%%%
%%% Plots the domain-integrated T/S output from MITgcm simulations.

clear

addpath jpo_analysis-hires/

expdir = '/Volumes/si/MITgcm_UC/exps_uc/';
expname ='ssurf33_0dS_lores_Ua0Va0_Atide0_Hi1Ai1_Ws25'


%%% Read experiment data
loadexp;

%%% Frequency of diagnostic output
dumpFreq = abs(diag_frequency(1));
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

nDumps = length(dumpIters);

% NN = 13;
NN = nDumps;

ntime = zeros(1,NN);
Tseries = zeros(1,NN);
Sseries = zeros(1,NN);

DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);



for n=1:NN
%   theta = rdmdsWrapper(fullfile(exppath,'/results/THETA'),dumpIters(n));  
%   salt  = rdmdsWrapper(fullfile(exppath,'/results/SALT') ,dumpIters(n));  
  theta = rdmdsWrapper(fullfile(exppath,'/results/T'),dumpIters(n));  
  salt  = rdmdsWrapper(fullfile(exppath,'/results/S') ,dumpIters(n));  

  Vol = sum(hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all');
  Tseries(n) = sum(theta.*hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all')/Vol;
  Sseries(n) = sum(salt.*hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all')/Vol;  
end

figure(1)
subplot(1,2,1)
plot(Tseries)
ylabel('Mean T (degC)')
xlabel('Time (year)')
subplot(1,2,2)
plot(Sseries)
ylabel('Mean S (psu)')
xlabel('Time (year)')




