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


groupname = 'fresh02_tide'
group_num =  [2 1 3];

ne=1
expname = strtrim(EXPNAME(ne,:))
loadexp;


      

%%% Frequency of diagnostic output
dumpFreq = abs(diag_frequency(1));
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
nDumps = length(dumpIters);

Ttot_group = zeros(size(EXPNAME,1),16);
Stot_group = zeros(size(EXPNAME,1),16);

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

      theta = rdmdsWrapper(fullfile(exppath,'/results/THETA'),dumpIters(n));      
      salt = rdmdsWrapper(fullfile(exppath,'/results/SALT'),dumpIters(n));      

      if (isempty(theta) || isempty(salt))
        break;
      end

      Ttot(n) = 0;
      Stot(n) = 0;
      for i=1:Nx
        for j=1:Ny
          for k=1:Nr
            Ttot(n) = Ttot(n) + theta(i,j,k)*delX(i)*delY(j)*delR(k);
            Stot(n) = Stot(n) + salt(i,j,k)*delX(i)*delY(j)*delR(k);
          end
        end
      end
      KElen = KElen + 1;
    end
    
  Ttot_group(ne,1:size(Ttot,2)) = Ttot;
  Stot_group(ne,1:size(Stot,2)) = Stot;  

end

figure(1);
clf;
axes('FontSize',16);
plot(ntime(1:KElen)/365,Ttot_group(group_num,1:KElen)/1e15);
axis tight;
xlabel('t (years)');
ylabel('(degC* 10^6 km^3)');
title('Domain-integrated temperature')
legend('No tdies','Weak tides','Strong tides')
% legend('1m','0.6m','0.2m')
% legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
%     'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
%     'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','interpreter','latex')

% saveas(gcf,[expdir '/data_poster/' groupname '_T_series.png']);


figure(2);
clf;
axes('FontSize',16);
plot(ntime(1:KElen)/365,Stot_group(group_num,1:KElen)/1e15);
axis tight;
xlabel('t (years)');
ylabel('(psu* 10^6 km^3)');
title('Domain-integrated salinity')
legend('No tdies','Weak tides','Strong tides')
% legend('1m','0.6m','0.2m')
% legend('Reference: u$_{a0}$ = -6, v$_{a0}$ = 6 [m/s]',...
%     'Weaker u$_a$: u$_{a0}$= -4, v$_{a0}$= 6','Stronger u$_a$: u$_{a0}$ = -8, v$_{a0}$ = 6',...
%     'Weaker v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 4','Stronger v$_a$: u$_{a0}$ = -6, v$_{a0}$ = 8','interpreter','latex')

% saveas(gcf,[expdir '/data_poster/' groupname '_S_series.png']);



