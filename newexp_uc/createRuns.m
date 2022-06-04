%%% createRuns.m
%%%
%%% Creates simulations using newexp with specified input parameters.
%%%

close all;clear;
addpath /Users/csi/MITgcm_UC/analysis_uc/functions/

batch_name = 'experiments/shelfice_double_obcs';


%%% Input parameters
Ua = -5;      %%% Reference value -2
Va = 5;       %%% Reference value 1
Atide = 0; %%% Reference value 0.02 (based on Jourdain et al. 2019)
Hi0 =1;       %%% Reference value 1
Ai0 =1;       %%% Reference value 1
m1km = 1000;
Ws =30*m1km;      %%% Reference value 30km, continental slope half-width
                   %%% Note that in the manuscript Ws represents slope width. Slope width = [50 100 150 200 250]*m1km; 
                   %%% The corresponding Meridional slope position Ys = [150 175 200 225 250]*m1km;
is_ContinuedRun = false;

%%% Select resolution
is_hires = false;

%%% Use sea ice or not
useSEAICE = true;

%%% Name pf the simulation
exp_name = createRunName (Ua,Va,Atide,Hi0,Ai0,Ws,is_hires);

%%% Create simulations
exp_name = ['res2km_' exp_name '_seaice_balance_ardbeg']
% exp_name = ['test']

%%%%%% TODO: EXCLUDE LAND FROM OBCS grids


newexp(batch_name,exp_name,Ua,Va,Atide,Hi0,Ai0,Ws,is_ContinuedRun,is_hires,useSEAICE);

