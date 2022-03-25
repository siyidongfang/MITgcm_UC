%%%
%%% plotEKEseries_group.m
%%%
%%% Plots the total/eddy kinetic energy output from MITgcm simulations.
%%%
%%% NOTE: Doesn't account for u/v gridpoint locations, and doesn't handle
%%% partial cells.
%%%
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
expdir = '/data/MITgcm_ASF-csi/newexp/';

EXPNAME = char('fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25');


groupname = 'fresh02_wind'
group_num =  [1 4 5 6 7];

ne=1
expname = strtrim(EXPNAME(ne,:))
loadexp;

%%% Frequency of diagnostic output
dumpFreq = abs(diag_frequency(1));
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
nDumps = length(dumpIters);

EKEtot_group = zeros(size(EXPNAME,1),16);
MeanKEtot_group = zeros(size(EXPNAME,1),16);
ratio_group = zeros(size(EXPNAME,1),16);

% MEANKE = 1.0e+13*[0.4683  0.3297  1.3960];

% for ne = 1:size(EXPNAME,1)
for ne = group_num
    expname = strtrim(EXPNAME(ne,:))
    loadexp;
    ntime = zeros(1,nDumps);
    KEtot = zeros(1,nDumps);
    KElen = 0;
    
    %%% Frequency of diagnostic output
    dumpFreq = abs(diag_frequency(1));
    nDumps = round(nTimeSteps*deltaT/dumpFreq);
    dumpIters = round((1:nDumps)*dumpFreq/deltaT);
    dumpIters = dumpIters(dumpIters > nIter0);
    nDumps = length(dumpIters);

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

      EKE = 0.5*(uvelsq + vvelsq + wvelsq - uvel.^2 - vvel.^2 - wvel.^2);
      MeanKE = 0.5*(uvelsq + vvelsq + wvelsq);
      EKEtot(n) = 0;
      MeanKEtot(n) = 0;
      for i=1:Nx
        for j=1:Ny
          for k=1:Nr
            EKEtot(n) = EKEtot(n) + EKE(i,j,k)*delX(i)*delY(j)*delR(k);
            MeanKEtot(n) = MeanKEtot(n) + MeanKE(i,j,k)*delX(i)*delY(j)*delR(k);
          end
        end
      end
      KElen = KElen + 1;
    end
    
  EKEtot_group(ne,1:size(EKEtot,2)) = EKEtot;
  MeanKEtot_group(ne,1:size(MeanKEtot,2)) = MeanKEtot;
  ratio_group(ne,1:size(EKEtot,2)) = EKEtot./MeanKEtot;

end

figure(1);
clf;
axes('FontSize',16);
plot(ntime(1:KElen)/365,ratio_group(group_num,1:KElen));
axis tight;
xlabel('t (years)');
% ylabel('EKE (m^2s^-^2)');
ylabel('EKE/MeanKE');
% legend('1m','0.6m','0.2m')
legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
    'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
    'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','interpreter','latex')

saveas(gcf,[expdir '/data_poster/' groupname '_KEratio_series.png']);
% saveas(gcf,[expdir '/data_poster/' groupname '_KEratio_series.fig']);


figure(2);
clf;
axes('FontSize',16);
plot(ntime(1:KElen)/365,EKEtot_group(group_num,1:KElen));
axis tight;
xlabel('t (years)');
ylabel('EKE (m^2s^-^2)');
% legend('1m','0.6m','0.2m')
legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
    'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
    'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','interpreter','latex')

saveas(gcf,[expdir '/data_poster/' groupname '_EKE_series.png']);


figure(3);
clf;
axes('FontSize',16);
plot(ntime(1:KElen)/365,MeanKEtot_group(group_num,1:KElen));
axis tight;
xlabel('t (years)');
ylabel('Mean KE (m^2s^-^2)');
% legend('1m','0.6m','0.2m')
legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
    'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
    'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','interpreter','latex')

saveas(gcf,[expdir '/data_poster/' groupname '_MeanKE_series.png']);

