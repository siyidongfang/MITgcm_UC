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

Ai = SIarea(xidx,:,1);
hi = SIheff(xidx,:,1);


% ui = SIuice(:,:,1);  % u-grid
vi = SIvice;  % v-grid
% ui_mass = (ui(1:Nx,:) + ui([2:Nx 1],:))/2; % mass-grid
vi_mass = zeros(Nx,Ny);
vi_mass(xidx,1:Ny-1) = (vi(xidx,1:Ny-1) + vi(xidx,2:Ny))/2;  % mass-grid
vi_mass(xidx,Ny) = 0;


%%% SIsig12 is on vorticity point
internal_xint = zeros(1,Ny);
internal_xint(1:Ny-1) =  Lx* diff(mean(SIsig12(xidx,:,1),1))./delY(1); % u-grid
internal_xint(Ny)= internal_xint(Ny-1);

%%% Coriolis force
coriolisforce = sum(f0*rho_i.*SIheff(xidx,:).*vi_mass(xidx,:).*DX_xy(xidx,:),1);



%%% TODO: Does SItaux contain the effect of Ai?
%%% Wind stress over sea ice
TAUai_xint = sum(SItaux(xidx,:,1).*DX_xy(xidx,:),1); % u-grid


%%% TODO: oceTAUX = Ai*TAUio + (1-Ai)*TAUao
%%% Ice-Ocean stress
TAUoi_xint = - sum(oceTAUX(xidx,:,1).*DX_xy(xidx,:),1); % u-grid

%%% Surface pressure gradient force: is negligible
g = 9.81; %%% Gravity
etaOCN = ETAN;  % C-grid location: mass
detaOCN_dx = zeros(length(xidx),Ny);
detaOCN_dx(2:end-1,:) = (etaOCN(xidx(3:end),:) - etaOCN(xidx(1:end-2),:)) /2 ./ DX_xy(xidx(2:end-1),:);
detaOCN_dx(1,:) = detaOCN_dx(2,:);
detaOCN_dx(end,:) = detaOCN_dx(end-1,:);
surfacepressure = -g*rho_i.*sum(detaOCN_dx.*SIheff(xidx,:,1).*DX_xy(xidx,:),1); %%% negligible, 4 orders smaller than other terms

%%% Residual term
totalchange =  internal_xint + TAUai_xint + TAUoi_xint + coriolisforce;

