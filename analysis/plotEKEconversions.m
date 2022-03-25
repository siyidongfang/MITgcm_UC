%%%
%%% plotEKEconversions.m
%%%
%%% Makes plots of the zonally averaged energy budget.
%%%

imgname = 'img_energy';

addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;

%%% Load experiment data
calcEnergyBudget;
load([exppath '/' expname '_tavg_5yrs.mat']);
load([exppath '/' expname '_variables_5yrs.mat']);

