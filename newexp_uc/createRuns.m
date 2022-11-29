
%%% createRuns.m
%%%
%%% Creates simulations using newexp with specified input parameters.
%%%

close all;clear;
addpath /Users/csi/MITgcm_UC/analysis_uc/functions/

% batch_name = 'exps_uc/pseudo_shelfice_seaice';

batch_name = 'exps_uc/seaice_boundary';

%%% Input parameters
Ua = -5;      %%% Reference value -5 (-4 with no ice shelf)
Va = 5;       %%% Reference value 5  ( 4 with no ice shelf)
Atide = 0;    %%% Reference value 0.02 (based on Jourdain et al. 2019)
Hi0 =1;       %%% Reference value 1
Ai0 =1;       %%% Reference value 1
m1km = 1000;
Ws =30*m1km;      %%% Reference value 30km, continental slope half-width

Hbed = 300;   %%% Change in bed elevation from shelf break to southern domain edge, ref 300
Htr = 200;    %%% Trough depth, ref 200
Zn = 350;     %%% CDW depth (thermocline) at the Northern boundary, ref 350
Zsb = 550;    %%% CDW depth (thermocline) over the shelf break, ref 550 (deeper: 750)
dZs = 150;    %%% The change in CDW depth from the shelfbreak to the Southern boundary (y=0), ref 150  (deeper: 250)

is_ContinuedRun = true;

%%% Select resolution
is_hires = false;

%%% Use sea ice or not
useSEAICE = true;

%%% Name pf the simulation
exp_name = createRunName (Ua,Va,Atide,Hi0,Ai0,Ws,Hbed,Htr,Zn,Zsb,dZs,is_hires,is_ContinuedRun);

%%% Create simulations
exp_name = ['res2km_' exp_name]

if(is_ContinuedRun)
    exp_name = [exp_name '_prod']
end

if(is_ContinuedRun)
    exp_name = [exp_name '_Adv7']
end

%%%%%% TODO: EXCLUDE LAND FROM OBCS grids

newexp(batch_name,exp_name,Ua,Va,Atide,Hi0,Ai0,Ws,Hbed,Htr,Zn,Zsb,dZs,is_ContinuedRun,is_hires,useSEAICE);



