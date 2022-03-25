%%%
%%% calcSurfSpeed.m
%%%
%%% Convenience script to calculate surface speed.
%%%

%%% Load experiment and data
loadexp;
load([exppath '/' expname '_tavg.mat'],'uu','vv');

%%% Calculate surface speed
u_mid = 0.5*(uu(1:Nx,:,:) + uu([2:Nx 1],:,:));
v_mid = 0.5*(vv(:,1:Ny,:) + vv(:,[2:Ny 1],:));
uabs = sqrt(u_mid(:,:,1).^2+v_mid(:,:,1).^2);

%%% Remove topography
uabs(uabs==0) = NaN;