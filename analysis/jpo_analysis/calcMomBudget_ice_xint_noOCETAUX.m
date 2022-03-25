%%%
%%% calcMomBudget_ice_xint_noOCETAUX.m
%%%
%%% Calculate the time-and-zonal-mean momentum budget terms for sea ice
%%%
%%% HEFF is already the seaice volume per grid cell area (in m), i.e. (mean ice thickness of ice covered area) * AREA. 
%%% So volume in m^3 is HEFF*RAC (RAC is the grid cell area)

loadexp;
load([exppath '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','SIuice','SIvice',...
    'Um_Ext','SIheff','SIarea',...
    'SIpress','SIzeta','SIeta','SIsig1','SIsig2','SIshear','SIdelta','SItensil', ...
    'ETAN'...
    ); %'oceTAUX','SItaux',...

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);


rho_i = 920; % Density of sea ice

ui = SIuice(:,:,1);  % C-grid location: U
vi = SIvice(:,:,1);  % C-grid location: V
ui_mass = (ui(1:Nx,:) + ui([2:Nx 1],:))/2; % C-grid location: mass
vi_mass(:,1:Ny-1) = (vi(:,1:Ny-1) + vi(:,2:Ny))/2;  % C-grid location: mass
vi_mass(:,Ny) = 0;

ui_vor(:,1:Ny-1) = (ui(:,1:Ny-1) + ui(:,2:Ny))/2; % grid location: vorticity
ui_vor(:,Ny) = 0;
vi_vor = (vi(1:Nx,:) + vi([2:Nx 1],:))/2; % grid location: vorticity


%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);


%%% Derivatives
dui_dy(:,1:Ny-1) = (ui_mass(:,2:Ny) - ui_mass(:,1:Ny-1)) ./ DY_xy(:,2:Ny);  % C-grid location: mass
dui_dy(:,Ny) = 0;
dvi_dx = (vi_mass([2:Nx 1],:) - vi_mass(1:Nx,:)) ./ DX_xy;  % C-grid location: mass

dui_dx= (ui_mass([2:Nx 1],:) - ui_mass(1:Nx,:)) ./ DX_xy;  % C-grid location: mass

%%% Ice internal stress
sig12 = SIeta(:,:,1).*(dvi_dx + dui_dy);  % C-grid location: mass
dsig12_dy(:,1:Ny-1) = (sig12(:,2:Ny) - sig12(:,1:Ny-1)) ./ DY_xy(:,2:Ny);
dsig12_dy(:,Ny) = 0;
internal_xint = sum(dsig12_dy.*DX_xy,1);

% dui_dx = (ui_mass([2:Nx 1],:) - ui_mass(1:Nx,:)) ./ DX_xy;
% sig11 = (SIeta(:,:,1) + SIzeta(:,:,1) .* dui_dx) - SIpress(:,:,1)/2 ;
% dsig11_dx = (sig11([2:Nx 1],:) - sig11(1:Nx,:)) ./ DX_xy;
% internal_xint = sum((dsig11_dx+dsig12_dy).*DX_xy,1);


% dui_dy(:,1:Ny-1) = (ui_vor(:,2:Ny) - ui_vor(:,1:Ny-1)) ./ DY_xy(:,2:Ny);  % grid location: vorticity
% dui_dy(:,Ny) = 0;
% dvi_dx = (vi_vor([2:Nx 1],:) - vi_vor(1:Nx,:)) ./ DX_xy;
% sig12 = SIeta(:,:,1).*(dvi_dx + dui_dy);  % grid location: vorticity
% dsig12_dy(:,1:Ny-1) = (sig12(:,2:Ny) - sig12(:,1:Ny-1)) ./ DY_xy(:,2:Ny);
% dsig12_dy(:,Ny) = 0;


%%% Coriolis force
coriolisforce = sum(f0*rho_i.*SIheff(:,:,1).*vi_mass(:,:,1).*DX_xy,1);


%%% Surface pressure gradient force
g = 9.81; %%% Gravity
etaOCN = ETAN(:,:,1);  % C-grid location: mass
detaOCN_dx = (etaOCN([2:Nx 1],:) - etaOCN(1:Nx,:)) ./ DX_xy;
surfacepressure = -g*rho_i.*sum(detaOCN_dx.*SIheff(:,:,1).*DX_xy,1); %%% negligible, 4 orders smaller than other terms


%%% TODO: Does SItaux contain the effect of Ai?
%%% Wind stress over sea ice
TAUai_xint = sum(SItaux(:,:,1).*DX_xy,1);


%%% TODO: oceTAUX = Ai*TAUio + (1-Ai)*TAUao
%%% Ice-Ocean stress
% TAUoi_xint = - sum(oceTAUX(:,:,1).*DX_xy,1);

rho0 = 1027;
Um_Ext_xzint = rho0.*sum(sum(Um_Ext.*hFacW.*DZ_xyz.*DX_xyz,3),1);
TAUoi_xint = -Um_Ext_xzint;

%%% Mean advection: is negligible
meanAdv_xint = sum(rho_i.*SIheff(:,:,1).*(ui_mass.*dui_dx + vi_mass.*dui_dy).*DX_xy,1);
% uv_mass = ui_mass.*vi_mass;
% uv_dy(:,1:Ny-1) = (uv_mass(:,2:Ny) - uv_mass(:,1:Ny-1)) ./ DY_xy(:,2:Ny);  % C-grid location: mass
% uv_dy(:,Ny) = 0;
% meanAdv_xint = sum(rho_i.*SIheff(:,:,1).*uv_dy.*DX_xy,1);

%%% TODO: tide/eddy advection


%%% Residual term
totalchange = internal_xint + meanAdv_xint + TAUai_xint + TAUoi_xint + coriolisforce + surfacepressure;

iceResidual = -(meanAdv_xint + TAUai_xint + TAUoi_xint + coriolisforce); %%% should be internal stress

%%% Calculate zonally averaged ice/surface ocean velocities
ui_xavg = mean(ui);
uo_xavg = mean(UVEL(:,:,1));


%%% Calculate zonally averaged ice thickness and fraction
hi_xavg = mean(SIheff(:,:,1));
Ai_xavg = mean(SIarea(:,:,1));