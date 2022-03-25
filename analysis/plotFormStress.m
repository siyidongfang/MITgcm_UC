%%%
%%% plotFormStress.m
%%%
%%% Plots the time-mean form stress per unit depth as a function of depth.
%%%

%%% Read experiment data
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat']);
rho_a = 1.3;               %%% Air density, kg/m^3
zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;

vv = VVEL;
uu = UVEL;
vt = VVELTH;
pp = PHIHYD;
tt = THETA;

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Eulerian-mean MOC
vE = squeeze(sum(vv.*hFacS.*DZ_xyz,1));
psiE = zeros(Ny,Nr+1);
psiE(:,2:Nr+1) = cumsum(vE,2);
psiE = zeros(Ny+1,Nr+1);
psiE(1:Ny,2:Nr+1) = cumsum(vE,2);
yy_v = [0 cumsum(delY)];
zz_w = -[0 cumsum(delR)];
[ZZ,YY] = meshgrid(zz_w,yy_v);

% %%% Density bins for form stress calculation  
% ptlevs_fs = -1:0.05:2;
% pt_mid = 0.5*(ptlevs_fs(1:end-1)+ptlevs_fs(2:end));
% Npt_fs = length(ptlevs_fs)-1;

%%% Calculate form stress
dFac = squeeze(1 - min(hFacW,[],1));
hFacE = hFacW([2:Nx 1],:,:);
formStress = -rho0*squeeze(nansum(pp.*(hFacE-hFacW),1));
formStress(dFac>0) = formStress(dFac>0) ./ dFac(dFac>0);
formStress_yint = sum(formStress(yy>5e4,:).*DY(yy>5e4,:),1);
formStress_zint = sum(formStress.*dFac.*DZ,2)';
formStress_total = sum(sum(formStress.*dFac.*DY.*DZ)); 

% %%% Calculate form stress in isopycnal coordinates
% formStress_pt = zeros(Ny,Npt_fs);
% for n=1:Npt_fs  
%   msk = (tt > ptlevs_fs(n) & tt < ptlevs_fs(n+1));
%   formStress_pt(:,n) = -rho0*squeeze(nansum(nansum(pp.*(hFacE-hFacW).*msk.*DZ_xyz,3),1));
% end

%%% Calculate mean form stress
DXC = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DZC = repmat(reshape((zz(1:end-1)-zz(2:end)),[1 1 Nr-1]),[Nx Ny 1]);
tt(tt==0) = NaN;
dt_dx = (tt([2:Nx 1],:,:) - tt(1:Nx,:,:)) ./ DXC;
dt_dx = 0.5 * (dt_dx(1:Nx,:,:) + dt_dx([Nx 1:Nx-1],:,:));
dt_dz = zeros(Nx,Ny,Nr);
dt_dz(:,:,1:Nr-1) = -diff(tt,1,3) ./ DZC;
dt_dz(:,:,Nr) = dt_dz(:,:,Nr-1);
dt_dz(:,:,2:Nr-1) = 0.5*(dt_dz(:,:,1:Nr-2)+dt_dz(:,:,2:Nr-1));
fs_mean = pp.*(-dt_dx./dt_dz);

%%% Calculate eddy form stress
tt_v = 0.5*(tt(:,[Ny 1:Ny-1],:)+tt(:,1:Ny,:));
vt_eddy = vt - vv.*tt_v;
vt_eddy = 0.5*(vt_eddy(:,1:Ny,:)+vt_eddy(:,[2:Ny 1],:));
YY = repmat(reshape(yy,[1 Ny 1]),[Nx 1 Nr]);
FF = f0 + beta*YY;
fs_eddy = -FF.*vt_eddy ./ dt_dz;


%%% Calculate meander component
% calcBTStreamfunc;
% [YY,XX] = meshgrid(yy,xx);
% pp_BT = Psi;
% pp_BT = (pp_BT(1:Nx,1:Ny) + pp_BT(2:Nx+1,1:Ny) + pp_BT(1:Nx,2:Ny+1) + pp_BT(2:Nx+1,2:Ny+1)) / 4;
% pp_BT = pp_BT.*(f0+beta.*YY)./(-bathy);
% A = repmat(pp_BT,[1 1 Nr]);
% A(hFacC==0) = NaN;  
% DA = A([2:Nx 1],:,:)-A(:,:,:);
% meanderStress = rho0*squeeze(nansum(DA.*DY.*DZ,1));  
% % meanderStress_yint = nansum(meanderStress,1);
% meanderStress_yint = nansum(meanderStress(yy>5e4,:),1);
% meanderStress_zint = nansum(meanderStress,2);
% meanderStress_total = nansum(meanderStress_yint); 

%%% Wind forcing
windStress = zonalWind;
windStress_xint = sum(windStress.*DX_xy,1);
westerlyWind = zonalWind;
westerlyWind(westerlyWind<0) = 0;
totalWindStress = sum(sum(westerlyWind.*DX_xy.*DY_xy));

%%% Make the plots

formStress_yint_plot = formStress_yint;
formStress_yint_plot(formStress_yint_plot==0) = NaN;
figure(18);
plot(formStress_yint_plot,zz);
hold on
% plot(meanderStress_yint,zz,'r');
% plot(formStress_yint-meanderStress_yint,zz,'g');
plot([min(formStress_yint) max(formStress_yint)],[-2000 -2000],'k--');
hold off;
ylabel('z (m)');
xlabel('Form stress per unit depth (N/m)');
% thetitle = 'Channel+';
% if (use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'ridge,'];
% end
% if (use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'north,'];
% end
% if (~use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'south,'];
% end
% if (~use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'bump,'];
% end
% if (~force_aabw)
%   thetitle = [thetitle,' no AABW'];
% else
%   if (taue == 0.075)
%     thetitle = [thetitle,' weak wind'];
%   else
%     thetitle = [thetitle,' reference'];
%   end  
% end
% title(thetitle,'FontSize',14);
set(gca,'FontSize',14);
% text(1e8,-500,['Total westerly wind force = ',num2str(totalWindStress,'%.2e'),' N'],'FontSize',14);
% text(1e8,-1000,['Total form stress = ',num2str(formStress_total,'%.2e'),' N'],'FontSize',14);

figure(19);
plot(yy,formStress_zint);
hold on;
plot(yy,windStress_xint,'r');
hold off;
ylabel('Form stress per unit latitude (N/m)');
xlabel('y (m)');
% thetitle = 'Channel+';
% if (use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'ridge,'];
% end
% if (use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'north,'];
% end
% if (~use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'south,'];
% end
% if (~use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'bump,'];
% end
% if (~force_aabw)
%   thetitle = [thetitle,' no AABW'];
% else
%   if (taue == 0.075)
%     thetitle = [thetitle,' weak wind'];
%   else
%     thetitle = [thetitle,' reference'];
%   end  
% end
% title(thetitle,'FontSize',14);
set(gca,'FontSize',14);
% text(1e8,-500,['Total westerly wind force = ',num2str(totalWindStress,'%.2e'),' N'],'FontSize',14);
% text(1e8,-1000,['Total form stress = ',num2str(formStress_total,'%.2e'),' N'],'FontSize',14);
  

figure(20);
[ZZ,YY] = meshgrid(zz,yy);
contourf(YY,ZZ,formStress,-1e3:1e1:1e3,'EdgeColor','None');
colorbar;
caxis([-5e2 5e2]);
colormap redblue;
ylabel('z(m)')
xlabel('y (m)');
thetitle = 'Form stress per unit area (N/m^2); Channel+';
% if (use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'ridge,'];
% end
% if (use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'north,'];
% end
% if (~use_ridge_north && use_ridge_south)
%   thetitle = [thetitle,'south,'];
% end
% if (~use_ridge_north && ~use_ridge_south)
%   thetitle = [thetitle,'bump,'];
% end
% if (~force_aabw)
%   thetitle = [thetitle,' no AABW'];
% else
%   if (taue == 0.075)
%     thetitle = [thetitle,' weak wind'];
%   else
%     thetitle = [thetitle,' reference'];
%   end  
% end
title(thetitle,'FontSize',14);
set(gca,'FontSize',14);
% text(1e8,-500,['Total westerly wind force = ',num2str(totalWindStress,'%.2e'),' N'],'FontSize',14);
% text(1e8,-1000,['Total form stress = ',num2str(formStress_total,'%.2e'),' N'],'FontSize',14);
  

  