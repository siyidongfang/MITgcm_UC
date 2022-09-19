%%%
%%% calc_pressure_torque.m
%%%
%%% Estimate the bottom and surface pressure torque, using u,v,h,beta_t.
%%%
%%% This script should be run after calc_BTvorticity.m


%%% Coriolis parameter
f = f0+beta*YY;  %%% f in (x,y) section

%%% Calculate ocean depth
fid = fopen(fullfile(inputpath,'SHELFICEtopoFile.bin'),'r','b');
icedraft = fread(fid,[Nx Ny],'real*8');
fclose(fid);

eta_exclude_iceshelf=ETAN;
eta_exclude_iceshelf(icedraft~=0)=0;

ho = icedraft+eta_exclude_iceshelf-bathy; %%% Ocean depth

load([prodir expname '_tavg_5yrs.mat'],'PHIHYD');
ZZ_3D = repmat(reshape(zz,[1 1 Nr]),[Nx Ny 1]);

dp = PHIHYD; %%% pressure anomaly
pp =  rhoConst*(-gravity*ZZ_3D + dp)/1e4; %%% 3D pressure, unit: dbar (1e4 kg/m/s^2)

%%% Find bottom pressure
pb = zeros(Nx,Ny);          % bottom pressure
for i = 1:Nx
    for j = 1:Ny
        idxb = find(ss(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom pressure
        if(idxb~=0)
           pb(i,j) = pp(i,j,idxb);
        end
    end
end
pb(pb==0) = NaN;

ps = zeros(Nx,Ny);          % surface pressure
for i = 1:Nx
    for j = 1:Ny
        idxs = find(ss(i,j,:)~=0,1,'first'); % Find the vertical grid of surface pressure
        if(idxs~=0)
           ps(i,j) = pp(i,j,idxs);
        end
    end
end
ps(ps==0) = NaN;

etab = bathy;
etas = icedraft+eta_exclude_iceshelf;

dpbdx = zeros(Nx,Ny);
dpbdy = zeros(Nx,Ny);
detabdx = zeros(Nx,Ny);
detabdy = zeros(Nx,Ny); 

etab_vgrid = zeros(Nx,Ny);    
etab_ugrid = zeros(Nx,Ny); 
pb_vgrid = zeros(Nx,Ny); 
pb_ugrid = zeros(Nx,Ny); 

etab_vgrid(:,1) = etab(:,1);
etab_vgrid(:,2:Ny) = (etab(:,1:Ny-1)+etab(:,2:Ny))/2; %%% v-grid
pb_vgrid(:,1) = pb(:,1);
pb_vgrid(:,2:Ny) = (pb(:,1:Ny-1)+pb(:,2:Ny))/2; %%% v-grid

etab_ugrid(2:Nx,:) = 0.5.*(etab(1:Nx-1,:)+etab(2:Nx,:));
pb_ugrid(2:Nx,:) = 0.5.*(pb(1:Nx-1,:)+pb(2:Nx,:));

dpbdx(2:Nx,:) = diff(pb_vgrid)/dx; % vorticity-gird
detabdx(2:Nx,:)  = diff(etab_vgrid)/dx; % vorticity-gird
dpbdy(:,2:Ny) = diff(pb_ugrid,1,2)/dy; % vorticity-gird
detabdy(:,2:Ny)  = diff(etab_ugrid,1,2)/dy; % vorticity-gird

zeta_dPhi_bot = dpbdy.*detabdx-dpbdx.*detabdy;
% zeta_dPhi_surf = 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the estimated pressure toruqe %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(10)
set(gcf,'Position',[90 232 2201 776])
clf;set(gcf,'color','w');

subplot(2,3,3)
pcolor(XX/1000,YY/1000,zeta_dPhi_bot);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom pressure torque (Pa/s)','Interpreter','latex','FontSize',fontsize+3)

% subplot(2,3,6)
% pcolor(XX/1000,YY/1000,zeta_dPhi_surf);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e5);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Surface pressure torque (Pa/s)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '_pressure_torque.png']);
end











% %%% Calculate topographic beta parameter 
% sby = zeros(Nx,Ny);
% sbx = zeros(Nx,Ny);
% for j=2:Ny-1
%     sby(:,j) = -(ho(:,j+1)-ho(:,j-1))/2/dy; %%% topographic slope, centered difference 
% end 
% for i=2:Nx-1
%     sbx(i,:) = -(ho(i+1,:)-ho(i-1,:))/2/dx; %%% topographic slope, centered difference 
% end 
% beta_ty = f.*sby./ho; %%% topographic beta parameter, in y direction
% beta_tx = f.*sbx./ho; %%% topographic beta parameter, in x direction
% 
% figure(5)
% pcolor(beta_ty);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
% figure(6)
% pcolor(beta_tx);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Plot surface and bottom velocity %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%% Find bottom velocity
% ub = zeros(Nx,Ny);          
% idxb = 0;
% for i = 1:Nx
%     for j = 1:Ny
%         idxb = find(uu(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom velocity
%         if(idxb~=0)
%            ub(i,j) = uu(i,j,idxb);
%         end
%     end
% end
% ub(ub==0) = NaN;
% 
% vb = zeros(Nx,Ny);          
% idxb = 0;
% for i = 1:Nx
%     for j = 1:Ny
%         idxb = find(vv(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom velocity
%         if(idxb~=0)
%            vb(i,j) = vv(i,j,idxb);
%         end
%     end
% end
% vb(vb==0) = NaN;
% 
% vb_tgrid = zeros(Nx,Ny);
% vb_tgrid(:,1:Ny-1) = (vb(:,1:Ny-1)+vb(:,2:Ny))/2; 
% ub_tgrid = zeros(Nx,Ny);
% ub_tgrid(1:Nx-1,:) = (ub(1:Nx-1,:)+ub(2:Nx,:))/2;
% 
% 
% %%% Find surface velocity (include ice shelf cavity)
% us = zeros(Nx,Ny);          
% idxs = 0;
% for i = 1:Nx
%     for j = 1:Ny
%         idxs = find(uu(i,j,:)~=0,1,'first'); % Find the vertical grid of surface velocity 
%         if(idxs~=0)
%            us(i,j) = uu(i,j,idxs);
%         end
%     end
% end
% us(us==0) = NaN;
% 
% vs = zeros(Nx,Ny);         
% idxs = 0;
% for i = 1:Nx
%     for j = 1:Ny
%         idxs = find(vv(i,j,:)~=0,1,'first'); % Find the vertical grid of surface velocity
%         if(idxs~=0)
%            vs(i,j) = vv(i,j,idxs);
%         end
%     end
% end
% vs(vs==0) = NaN;
% 
% vs_tgrid = zeros(Nx,Ny);
% vs_tgrid(:,1:Ny-1) = (vs(:,1:Ny-1)+vs(:,2:Ny))/2; 
% us_tgrid = zeros(Nx,Ny);
% us_tgrid(1:Nx-1,:) = (us(1:Nx-1,:)+us(2:Nx,:))/2;
% 
% 
% subplot(2,3,1)
% pcolor(XX/1000,YY/1000,ub_tgrid);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/10);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Bottom zonal velocity $u_b$ (m/s)','Interpreter','latex','FontSize',fontsize+3)
% 
% subplot(2,3,2)
% pcolor(XX/1000,YY/1000,vb_tgrid);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/10);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Bottom meridonal velocity $v_b$ (m/s)','Interpreter','latex','FontSize',fontsize+3)
% 
% subplot(2,3,4)
% pcolor(XX/1000,YY/1000,us_tgrid);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/10);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Surface zonal velocity $u_s$ (m/s)','Interpreter','latex','FontSize',fontsize+3)
% 
% subplot(2,3,5)
% pcolor(XX/1000,YY/1000,vs_tgrid);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/10);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Surface meridonal velocity $v_s$ (m/s)','Interpreter','latex','FontSize',fontsize+3)
% 
% 
% 


% zeta_dPhi_bot = -rho0*ho.*ub_tgrid.*beta_tx - rho0*ho.*vb_tgrid.*beta_ty;
% zeta_dPhi_surf = -rho0*ho.*us_tgrid.*beta_tx - rho0*ho.*vs_tgrid.*beta_ty;
