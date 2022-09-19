%%%
%%% calc_pressure_torque.m
%%%
%%% Estimate the bottom and surface pressure torque, using u,v,h,beta_t.
%%%
%%% This script should be run after calc_BTvorticity.m


f = f0+beta*YY;  %%% f in (x,y) section
fid = fopen(fullfile(inputpath,'SHELFICEtopoFile.bin'),'r','b');
icedraft = fread(fid,[Nx Ny],'real*8');
fclose(fid);

eta_exclude_iceshelf=ETAN;
eta_exclude_iceshelf(icedraft~=0)=0;

ho = icedraft+eta_exclude_iceshelf-bathy; %%% Ocean depth

sby = zeros(Nx,Ny);
sbx = zeros(Nx,Ny);
for j=2:Ny-1
    sby(:,j) = (ho(:,j+1)-ho(:,j-1))/2/dy; %%% topographic slope, centered difference 
end 
for i=2:Nx-1
    sbx(i,:) = (ho(i+1,:)-ho(i-1,:))/2/dx; %%% topographic slope, centered difference 
end 
beta_ty = f.*sby./ho; %%% topographic beta parameter
beta_tx = f.*sbx./ho; %%% topographic beta parameter

figure(5)
pcolor(beta_ty);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
figure(6)
pcolor(beta_tx);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);

% VV_tgrid = zeros(Nx,Ny);
% VV_tgrid(:,1:Ny-1) = (VV(:,1:Ny-1)+VV(:,2:Ny))/2;   % mass-grid
% UU = sum(uu.*hFacW.*DZ,3);
% UU_tgrid = zeros(Nx,Ny);
% UU_tgrid(1:Nx-1,:) = (UU(1:Nx-1,:)+UU(2:Nx,:))/2;
% 
% zeta_dPhi_UVbetat = rho0*UU_tgrid.*beta_tx + rho0*VV_tgrid.*beta_ty;

%%% Find bottom velocity

ub = zeros(Nx,Ny);          % bottom pressure
uu(uu==0) = NaN;            % make the topography (where dp==0) NaN values
idx_topog = isnan(uu);      % The dry grids (topography): 1, wet grids: 0
idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
for i = 1:Nx
    for j = 1:Ny
        if(idxb(i,j)~=0)
           ub(i,j) = uu(i,j,idxb(i,j));
        end
    end
end
ub(ub==0) = NaN;
uu(isnan(uu)) = 0;   

vb = zeros(Nx,Ny);          % bottom pressure
vv(vv==0) = NaN;            % make the topography (where dp==0) NaN values
idx_topog = isnan(vv);      % The dry grids (topography): 1, wet grids: 0
idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
for i = 1:Nx
    for j = 1:Ny
        if(idxb(i,j)~=0)
           vb(i,j) = vv(i,j,idxb(i,j));
        end
    end
end
vb(vb==0) = NaN;
vv(isnan(vv)) = 0;   

vb_tgrid = zeros(Nx,Ny);
vb_tgrid(:,1:Ny-1) = (vb(:,1:Ny-1)+vb(:,2:Ny))/2; 
ub_tgrid = zeros(Nx,Ny);
ub_tgrid(1:Nx-1,:) = (ub(1:Nx-1,:)+ub(2:Nx,:))/2;

zeta_dPhi_UVbetat = rho0*ho.*ub_tgrid.*beta_tx + rho0*ho.*vb_tgrid.*beta_ty;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the estimated pressure toruqe %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(10)
set(gcf,'Position',[90 232 2201 776])
clf;set(gcf,'color','w');
subplot(2,3,1)
pcolor(XX/1000,YY/1000,ub_tgrid);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/10);
title('Bottom zonal velocity (m/s)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(2,3,2)
pcolor(XX/1000,YY/1000,vb_tgrid);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/10);
title('Bottom meridonal velocity (m/s)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')

subplot(2,3,3)
pcolor(XX/1000,YY/1000,zeta_dPhi_UVbetat);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('Bottom pressure torque (m/s)')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')


if(savefigure)
print('-dpng','-r150',[figdir expname '_BPT.png']);
end
