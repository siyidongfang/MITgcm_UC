%%%
%%% setExpname.m
%%%
%%% Convenience script to set the experiment name before loadexp.m is 
%%% called in other scripts.
%%%
clear; close all


tmin = 0;
tmax = 5;


addpath /Users/csi/MITgcm_UC/utils/matlab; 
addpath /Users/csi/MITgcm_UC/analysis_uc;
addpath /Users/csi/MITgcm_UC/analysis/jpo_analysis-hires/;
addpath /Users/csi/MITgcm_UC/analysis/jpo_analysis;
addpath /Users/csi/MITgcm_UC/analysis/colormaps;


expdir = '/Volumes/si/MITgcm_UC/exps_uc';
prodir = '/Volumes/si/MITgcm_UC/products_uc/';


EXPNAME = {
'ssurf33_0dS_lores_Ua0Va0_Atide0_Hi0Ai0_Ws25_prod'
        };
    

for n=1:length(EXPNAME)
%  for n=4
  expname = EXPNAME{n} 
  avg_t
  calcOverturning_rho_Aocean (expdir,expname,prodir)
  load([prodir '/' expname '_tavg_5yrs.mat'],'THETA','SALT','PHIHYD');
  calcNeutralDensity;
end


