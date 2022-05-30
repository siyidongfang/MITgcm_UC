%%%
%%% calcEulerianMOC.m
%%%
%%% Convenience script to calculate the Eulerian-Mean MOC.
%%%

DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

vE = squeeze(sum(vv.*hFacS.*DZ_xyz.*DX_xyz,1));
psiE = zeros(Ny,Nr+1);
psiE(:,2:Nr+1) = cumsum(vE,2);
psiE = zeros(Ny+1,Nr+1);
psiE(1:Ny,2:Nr+1) = cumsum(vE,2);