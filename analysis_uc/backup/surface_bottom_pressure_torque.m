


%%% Find bottom pressure
load([prodir expname '_tavg_5yrs.mat'],'PHIHYD');
ZZ_3D = repmat(reshape(zz,[1 1 Nr]),[Nx Ny 1]);
dp = PHIHYD; %%% pressure anomaly
pp =  rhoConst*(-gravity*ZZ_3D + dp)/1e4; %%% 3D pressure, unit: dbar (1e4 kg/m/s^2)

pb = zeros(Nx,Ny);          % bottom pressure
ss(ss==0) = NaN;            % make the topography (where dp==0) NaN values
idx_topog = isnan(ss);      % The dry grids (topography): 1, wet grids: 0
idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
for i = 1:Nx
    for j = 1:Ny
        if(idxb(i,j)~=0)
           pb(i,j) = pp(i,j,idxb(i,j));
        end
    end
end

ps = PHIHYD(:,:,1);
etas = ETAN;
etab = bathy;

pb_ugrid = zeros(Nx,Ny); 
ps_vgrid = zeros(Nx,Ny); 
pb_ugrid = zeros(Nx,Ny); 
ps_vgrid = zeros(Nx,Ny); 
etab_ugrid = zeros(Nx,Ny); 
etab_vgrid = zeros(Nx,Ny); 
etas_ugrid = zeros(Nx,Ny); 
etas_vgrid = zeros(Nx,Ny); 

pb_vgrid(:,1) = pb(:,1);
pb_vgrid(:,2:Ny) = (pb(:,1:Ny-1)+pb(:,2:Ny))/2; %%% v-grid
ps_vgrid(:,1) = ps(:,1);
ps_vgrid(:,2:Ny) = (ps(:,1:Ny-1)+ps(:,2:Ny))/2; %%% v-grid
etab_vgrid(:,1) = etab(:,1);
etab_vgrid(:,2:Ny) = (etab(:,1:Ny-1)+etab(:,2:Ny))/2; %%% v-grid
etas_vgrid(:,1) = etas(:,1);
etas_vgrid(:,2:Ny) = (etas(:,1:Ny-1)+etas(:,2:Ny))/2; %%% v-grid

pb_ugrid(2:Nx,:) = 0.5.*(pb(1:Nx-1,:)+pb(2:Nx,:));
ps_ugrid(2:Nx,:) = 0.5.*(ps(1:Nx-1,:)+ps(2:Nx,:));
etab_ugrid(2:Nx,:) = 0.5.*(etab(1:Nx-1,:)+etab(2:Nx,:));
etas_ugrid(2:Nx,:) = 0.5.*(etas(1:Nx-1,:)+etas(2:Nx,:));

dpb_dx = zeros(Nx,Ny);
dpb_dy = zeros(Nx,Ny);
dps_dx = zeros(Nx,Ny);
dps_dy = zeros(Nx,Ny); 
detab_dx = zeros(Nx,Ny); 
detab_dy = zeros(Nx,Ny); 
detas_dx = zeros(Nx,Ny); 
detas_dy = zeros(Nx,Ny); 

dpb_dy(:,2:Ny) = diff(pb_ugrid,1,2)/dy; % vorticity-gird
dps_dy(:,2:Ny) = diff(ps_ugrid,1,2)/dy; % vorticity-gird
detab_dy(:,2:Ny)  = diff(etab_ugrid,1,2)/dy; % vorticity-gird
detas_dy(:,2:Ny)  = diff(etas_ugrid,1,2)/dy; % vorticity-gird

dpb_dx(2:Nx,:)  = diff(pb_vgrid)/dx; % vorticity-gird
dps_dx(2:Nx,:)  = diff(ps_vgrid)/dx; % vorticity-gird
detab_dx(2:Nx,:) = diff(etab_vgrid)/dx; % vorticity-gird
detas_dx(2:Nx,:) = diff(etas_vgrid)/dx; % vorticity-gird

%%% Bottom pressure torque 
zeta_dPhi_bott = dpb_dy.*detab_dx - dpb_dx.*detab_dy;
%%% Surface pressure torque 
zeta_dPhi_surf = - ( dps_dy.*detas_dx - dps_dx.*detas_dy);



subplot(3,2,5)
pcolor(XX/1000,YY/1000,zeta_dPhi_surf)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Surface pressure torque (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(3,2,6)
pcolor(XX/1000,YY/1000,zeta_dPhi_bott)
shading flat;colorbar;
caxis([-1 1]/1e4);
title('Bottom pressure torque (Pa/m)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

