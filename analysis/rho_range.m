close all;clear all;

addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/data/MITgcm_ASF-csi/newexp/';

% expname = 'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25';
% % expname = 'fresh02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% expname = 'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'

% expname = 'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% expname = 'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% expname = 'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'

loadexp;

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

xx = xx + abs(xx(1));
OUTPUT = 'avg';

switch (OUTPUT)
    case 'avg'
        imgname = 'img_analysis';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'years';
        fname = '.';
    case 'inst'
        imgname = 'img_analysis_inst';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = 'years, inst.';
        fname = '_inst.';
end

m =10;
Ntime = navg(m*10-9:m*10);
salt0=rdmds([exppath,'/results/SALT' fname Ntime]);
theta0=rdmds([exppath,'/results/THETA' fname Ntime]);
pot_dens0 = densmdjwf(salt0,theta0,1982.8.*ones(size(salt0))); 
pd_min = min(min(min(pot_dens0)))-1000;
pd_max = max(max(max(pot_dens0)))-1000;
range = [pd_min pd_max]
