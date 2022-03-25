
clear;

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';

EXPNAME = {...
    'ssurf34.12_3dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
    'ssurf34.12_2.5dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
  };

ne = 1;
expname = EXPNAME{ne};
loadexp;

for ne = 1:size(EXPNAME,1)
expname = EXPNAME{ne}
load([prodir '/' expname '_tavg_10yrs.mat'],'THETA','SALT','PHIHYD');
calcNeutralDensity;
end