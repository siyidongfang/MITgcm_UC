clear;close all;
addpath ..
addpath  ../colormaps;
addpath ../jpo_analysis/;
addpath ../jpo_analysis-hires/;
prodir = '/Volumes/si/MITgcm_UC/products_uc'
expdir = '/Volumes/si/MITgcm_UC/exps_uc';
expname = 'noice_ssurf33_0dS_lores_Ua0Va0_Atide0_Hi0Ai0_Ws25'
% loadexp;

load([prodir '/' expname '_tavg_5yrs.mat']);