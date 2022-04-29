%%% createRuns.m
%%%
%%% Creates simulations using newexp with specified input parameters.
%%%

batch_name = 'exps_test'; 


%%% Input parameters
Ua = -1;      %%% Reference value -2
Va = 0.5;       %%% Reference value 1
Atide = 0; %%% Reference value 0.02 (based on Jourdain et al. 2019)
Hi0 =0;       %%% Reference value 1
Ai0 =0;       %%% Reference value 1
m1km = 1000;
Ws =30*m1km;      %%% Reference value 30km, continental slope half-width
                   %%% Note that in the manuscript Ws represents slope width. Slope width = [50 100 150 200 250]*m1km; 
                   %%% The corresponding Meridional slope position Ys = [150 175 200 225 250]*m1km;
is_ContinuedRun = false;

%%% Select resolution
is_hires = false;

%%% Use sea ice or not
useSEAICE = false;

%%% Name pf the simulation
exp_name = createRunName (Ua,Va,Atide,Hi0,Ai0,Ws,is_hires);

%%% Create simulations
exp_name = ['res2km_' exp_name '_fresher0.5psu_hoffman2']

newexp(batch_name,exp_name,Ua,Va,Atide,Hi0,Ai0,Ws,is_ContinuedRun,is_hires,useSEAICE);

