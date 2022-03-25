%%%
%%% calcTotalEKE.m
%%%
%%% Integrates EKE over the whole domain.
%%%

%%% Set true to include AABW formation region
include_AABW = true;

%%% Load experiment and data
loadexp;
load([expname,'_tavg.mat'],'uu','vv','usq','vsq');

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

%%% Calculate EKE
EKE_u = 0.5*(usq-uu.^2);
EKE_v = 0.5*(vsq-vv.^2);
EKE = 0.5*(EKE_u([1:Nx],:,:)+EKE_u([2:Nx 1],:,:)) + 0.5*(EKE_v(:,[1:Ny],:)+EKE_v(:,[2:Ny 1],:));

%%% Depth-averaged EKE
EKE_zavg = sum(EKE.*DZ.*hFacC,3) ./ sum(DZ.*hFacC,3);
% EKE_zavg = EKE(:,:,1);

%%% Total EKE
EKEDV = EKE.*DX.*DY.*DZ.*hFacC;

%%% Calculate total EKE
if (include_AABW)
  startidx = 1;
else
  startidx = 126; %%% y=500km
end
EKEtot = sum(sum(sum(EKEDV(:,startidx:end,:))));