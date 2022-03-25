%%%
%%% plotBTStreamfunc.m
%%%
%%% Plots the time-mean barotropic streamfunction.
%%%

%%% Load velocity
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'],'UVEL');
uu=UVEL;
%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Calculate depth-averaged zonal velocity
UU = sum(uu.*DZ.*hFacW,3);

%%% Calculate barotropic streamfunction
Psi = zeros(Nx+1,Ny+1);
Psi(1:Nx,1:Ny) = flip(cumsum(flip(UU.*DY(:,:,1),2),2),2);
Psi(:,Ny+1) = 0;
Psi(Nx+1,:) = Psi(1,:);