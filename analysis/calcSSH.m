%%%
%%% calcSSH.m
%%%
%%% Calculates SSH anomaly in the standing meander.
%%%

%%% Load experiment data
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'],'PHIHYD');
pp = PHIHYD;
%%% Range of latitudinal indices 
startidx = 125;
endidx = Ny;
JJ = repmat(1:Ny,[Nx 1]);

%%% Max ocean depth for averaging anomaly in meander
maxdepth = 2500;

%%% Calculate SSH
eta = pp(:,:,1)/gravity;
eta(eta==0) = NaN;
eta = eta - mean(eta(:,end-1));

%%% Zonal mean
eta_xavg = mean(eta,1);
eta_xavg = repmat(eta_xavg,[Nx 1]);

%%% SSH anomaly
eta_anom = eta - eta_xavg;
eta_anom_avg = mean(eta_anom(JJ>startidx & JJ < endidx & bathy>-maxdepth));