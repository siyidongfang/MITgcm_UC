%%% createRuns.m
%%%
%%% Creates simulations using newexp with specified input parameters.
%%%

batch_name = 'exps_uc'; 


%%% Input parameters
Ua = 0;      %%% Reference value -6
Va = 0;       %%% Reference value 6
Atide = 0; %%% Reference value 0.05
Hi0 =1;       %%% Reference value 1
Ai0 =1;       %%% Reference value 1
m1km = 1000;
Ws =25*m1km;      %%% Reference value 25km, slope half-width
                   %%% Note that in the manuscript Ws represents slope width. Slope width = [50 100 150 200 250]*m1km; 
                   %%% The corresponding Meridional slope position Ys = [150 175 200 225 250]*m1km;
is_ContinuedRun = true;

%%% Select resolution
is_hires = false;

%%% Name pf the simulation
exp_name = createRunName (Ua,Va,Atide,Hi0,Ai0,Ws,is_hires);

%%% Create simulations
exp_name = ['ssurf33_0dS_' exp_name '_prod']



newexp(batch_name,exp_name,Ua,Va,Atide,Hi0,Ai0,Ws,is_ContinuedRun,is_hires);

