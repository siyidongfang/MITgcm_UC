%%%
%%% plotTKE.m
%%%
%%% Plots the total kinetic energy output from MITgcm simulations.
%%%
%%% NOTE: Doesn't account for u/v gridpoint locations, and doesn't handle
%%% partial cells.
%%%

    
clear; close all;

%%% Add path
addpath ../analysis/colormaps;
addpath ../analysis/;
addpath ../analysis/jpo_analysis-hires/;
addpath ../analysis/colormaps/cmocean/;

expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_obcsE_orlanskiW/';
expname = 'res2km_Ua-2Va1_Atide0_Hi0Ai0_Ws30_ardbeg'
loadexp;

figdir = [exppath '/img/'];


%%% Frequency of diagnostic output
dumpFreq = abs(diag_frequency(1));
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
nDumps = length(dumpIters);

% clear nDumps dumpIters
% dumpIters = [167745 225257 335489 450514 675771 901029 1126286 1351543]
% nDumps = length(dumpIters);

ntime = zeros(1,nDumps);
EKEtot = zeros(1,nDumps);
KEtot = zeros(1,nDumps);
KElen = 0;

for n=1:nDumps
 
  ntime(n) =  dumpIters(n)*deltaT/86400;  
  
  uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),dumpIters(n));      
  vvel = rdmdsWrapper(fullfile(exppath,'/results/VVEL'),dumpIters(n));      
  wvel = rdmdsWrapper(fullfile(exppath,'/results/WVEL'),dumpIters(n));      
  uvelsq = rdmdsWrapper(fullfile(exppath,'/results/UVELSQ'),dumpIters(n));      
  vvelsq = rdmdsWrapper(fullfile(exppath,'/results/VVELSQ'),dumpIters(n));      
  wvelsq = rdmdsWrapper(fullfile(exppath,'/results/WVELSQ'),dumpIters(n));      
  
  if (isempty(uvelsq) || isempty(vvelsq) || isempty(wvelsq))
    break;
  end

  KE = 0.5*(uvelsq + vvelsq + wvelsq);
  EKE = 0.5*(uvelsq + vvelsq + wvelsq - uvel.^2 - vvel.^2 - wvel.^2);
  KEtot(n) = 0;
  EKEtot(n) = 0;
  

  for i=1:Nx
    for j=1:Ny
      for k=1:Nr
        KEtot(n) = KEtot(n) + KE(i,j,k)*delX(i)*delY(j)*delR(k);
        EKEtot(n) = EKEtot(n) + EKE(i,j,k)*delX(i)*delY(j)*delR(k);
      end
    end
  end
  KElen = KElen + 1;
end
  



DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
Tseries = zeros(1,nDumps);
Sseries = zeros(1,nDumps);

for n=1:KElen
  theta = rdmdsWrapper(fullfile(exppath,'/results/THETA'),dumpIters(n));  
  salt  = rdmdsWrapper(fullfile(exppath,'/results/SALT') ,dumpIters(n));  
  
  Vol = sum(hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all');
  Tseries(n) = sum(theta.*hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all')/Vol;
  Sseries(n) = sum(salt.*hFacC.*DX_xyz.*DY_xyz.*DY_xyz,'all')/Vol;  
end



%%% Make plots!
fontsize = 16;

figure(1);
clf;
subplot(2,2,1)
plot(ntime(1:KElen)/365,KEtot(1:KElen),'LineWidth',2);
axis tight;
xlabel('t (years)');
ylabel('Mean KE (m^2s^-^2)');
set(gca,'FontSize',fontsize);
subplot(2,2,2)
plot(ntime(1:KElen)/365,EKEtot(1:KElen),'LineWidth',2);
axis tight;
xlabel('t (years)');
ylabel('EKE (m^2s^-^2)');
set(gca,'FontSize',fontsize);
subplot(2,2,3)
plot(ntime(1:KElen)/365,Tseries(1:KElen),'LineWidth',2);
axis tight;
xlabel('t (years)');
ylabel('T (degC)');
set(gca,'FontSize',fontsize);
subplot(2,2,4)
plot(ntime(1:KElen)/365,Sseries(1:KElen),'LineWidth',2);
axis tight;
xlabel('t (years)');
ylabel('S (psu)');
set(gca,'FontSize',fontsize);
set(gcf,'Position', [76 328 833 591])
print('-dpng','-r150',[figdir 'series_KE_EKE_T_S.png']);
