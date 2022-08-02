%%%
%%% calcMomBudget_ice_xint.m
%%%
%%% Calculate the time-and-zonal-mean momentum budget terms for sea ice
%%%
%%% HEFF is already the seaice volume per grid cell area (in m), i.e. (mean ice thickness of ice covered area) * AREA. 
%%% So volume in m^3 is HEFF*RAC (RAC is the grid cell area)

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'SIvice',...
    'oceTAUX','SItaux',...
    'SIheff','SIarea',...
    'ETAN','SIsig12'...
    );
rho_i = 920; % Density of sea ice

Ai = SIarea(:,:,1);
hi = SIheff(:,:,1);


% ui = SIuice(:,:,1);  % u-grid
vi = SIvice;  % v-grid
% ui_mass = (ui(1:Nx,:) + ui([2:Nx 1],:))/2; % mass-grid
vi_mass(:,1:Ny-1) = (vi(:,1:Ny-1) + vi(:,2:Ny))/2;  % mass-grid
vi_mass(:,Ny) = 0;


%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);


%%% SIsig12 is on vorticity point
internal_xint = zeros(1,Ny);
internal_xint(1:Ny-1) =  Lx* diff(mean( SIsig12(:,:,1),1))./delY(1); % u-grid
internal_xint(Ny)= internal_xint(Ny-1);


%%% Coriolis force
coriolisforce = sum(f0*rho_i.*SIheff(:,:,1).*vi_mass(:,:).*DX_xy,1);



%%% TODO: Does SItaux contain the effect of Ai?
%%% Wind stress over sea ice
TAUai_xint = sum(SItaux(:,:,1).*DX_xy,1); % u-grid


%%% TODO: oceTAUX = Ai*TAUio + (1-Ai)*TAUao
%%% Ice-Ocean stress
TAUoi_xint = - sum(oceTAUX(:,:,1).*DX_xy,1); % u-grid

%%% Surface pressure gradient force: is negligible
g = 9.81; %%% Gravity
etaOCN = ETAN(:,:,1);  % C-grid location: mass
detaOCN_dx = (etaOCN([2:Nx 1],:) - etaOCN(1:Nx,:)) ./ DX_xy;
surfacepressure = -g*rho_i.*sum(detaOCN_dx.*SIheff(:,:,1).*DX_xy,1); %%% negligible, 4 orders smaller than other terms

%%% Residual term
totalchange =  internal_xint + TAUai_xint + TAUoi_xint + coriolisforce;

