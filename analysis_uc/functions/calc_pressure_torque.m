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

hob = -bathy;
hos = icedraft+eta_exclude_iceshelf;

%%% Calculate topographic beta parameter 
sby = zeros(Nx,Ny);
sbx = zeros(Nx,Ny);
ssy = zeros(Nx,Ny);
ssx = zeros(Nx,Ny);
for j=2:Ny-1
    sby(:,j) = -(hob(:,j+1)-hob(:,j-1))/2/dy; %%% bottom topographic slope, centered difference 
    ssy(:,j) = -(hos(:,j+1)-hos(:,j-1))/2/dy; %%% surface slope (ice shelf+SSH), centered difference 
end 
for i=2:Nx-1
    sbx(i,:) = -(hob(i+1,:)-hob(i-1,:))/2/dx; %%% bottom topographic slope, centered difference 
    ssx(i,:) = -(hos(i+1,:)-hos(i-1,:))/2/dx; %%% surface slope (ice shelf+SSH), centered difference 
end 
betab_ty = f.*sby./ho; %%% bottom topographic beta parameter, in y direction
betab_tx = f.*sbx./ho; %%% bottom topographic beta parameter, in x direction
betas_ty = f.*ssy./ho; %%% surface topographic beta parameter, in y direction
betas_tx = f.*ssx./ho; %%% surface topographic beta parameter, in x direction

figure(5)
subplot(2,2,1)
pcolor(betab_ty);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
subplot(2,2,2)
pcolor(betab_tx);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
subplot(2,2,3)
pcolor(betas_ty);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);
subplot(2,2,4)
pcolor(betas_tx);shading flat;colorbar;caxis([-1 1]*1e-8);colormap(redblue);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot surface and bottom velocity %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Find bottom velocity
ub = zeros(Nx,Ny);          
idxb = 0;
for i = 1:Nx
    for j = 1:Ny
        idxb = find(uu(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom velocity
        if(idxb~=0)
           ub(i,j) = uu(i,j,idxb);
        end
    end
end
ub(ub==0) = NaN;

vb = zeros(Nx,Ny);          
idxb = 0;
for i = 1:Nx
    for j = 1:Ny
        idxb = find(vv(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom velocity
        if(idxb~=0)
           vb(i,j) = vv(i,j,idxb);
        end
    end
end
vb(vb==0) = NaN;

wb = zeros(Nx,Ny);          
idxb = 0;
for i = 1:Nx
    for j = 1:Ny
        idxb = find(ww(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom velocity
        if(idxb~=0)
           wb(i,j) = ww(i,j,idxb);
        end
    end
end
wb(wb==0) = NaN;


vb_tgrid = zeros(Nx,Ny);
vb_tgrid(:,1:Ny-1) = (vb(:,1:Ny-1)+vb(:,2:Ny))/2; 
ub_tgrid = zeros(Nx,Ny);
ub_tgrid(1:Nx-1,:) = (ub(1:Nx-1,:)+ub(2:Nx,:))/2;


%%% Find surface velocity (include ice shelf cavity)
us = zeros(Nx,Ny);          
idxs = 0;
for i = 1:Nx
    for j = 1:Ny
        idxs = find(uu(i,j,:)~=0,1,'first'); % Find the vertical grid of surface velocity 
        if(idxs~=0)
           us(i,j) = uu(i,j,idxs);
        end
    end
end
us(us==0) = NaN;

vs = zeros(Nx,Ny);         
idxs = 0;
for i = 1:Nx
    for j = 1:Ny
        idxs = find(vv(i,j,:)~=0,1,'first'); % Find the vertical grid of surface velocity
        if(idxs~=0)
           vs(i,j) = vv(i,j,idxs);
        end
    end
end
vs(vs==0) = NaN;

vs_tgrid = zeros(Nx,Ny);
vs_tgrid(:,1:Ny-1) = (vs(:,1:Ny-1)+vs(:,2:Ny))/2; 
us_tgrid = zeros(Nx,Ny);
us_tgrid(1:Nx-1,:) = (us(1:Nx-1,:)+us(2:Nx,:))/2;


zeta_dPhi_bot = -rho0*ho.*ub_tgrid.*betab_tx - rho0*ho.*vb_tgrid.*betab_ty;
zeta_dPhi_surf = -rho0*ho.*us_tgrid.*betas_tx - rho0*ho.*vs_tgrid.*betas_ty;


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
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom zonal velocity $u_g^b$ (m/s)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,3,2)
pcolor(XX/1000,YY/1000,vb_tgrid);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom meridonal velocity $v_g^b$ (m/s)','Interpreter','latex','FontSize',fontsize+3)

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


subplot(2,3,3)
pcolor(XX/1000,YY/1000,zeta_dPhi_bot);
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title({'Bottom pressure torque (Pa/s)','$-\rho_oh_o \big(u_g^b\beta_t^{b,x}+v_g^b\beta_t^{b,y}\big)$'},'Interpreter','latex','FontSize',fontsize+3)

% subplot(2,3,6)
% pcolor(XX/1000,YY/1000,zeta_dPhi_surf);
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e8);
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title({'Surface pressure torque (Pa/s)','$-\rho_oh_o \big(u_g^{s}\beta_t^{s,x}+v_g^{s}\beta_t^{s,y}\big)$'},'Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '_pressure_torque.png']);
end




% figure(6)
% clf;set(gcf,'color','w');
% pcolor(XX/1000,YY/1000,zeta_dPhi-zeta_dPhi_bot)
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e5);
% title('','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_diff.png']);
% end




figure(7)
clf;set(gcf,'color','w');
pcolor(XX/1000,YY/1000,-rho0*f.*wb)
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')




prodname_new = [prodir expname '_vorticity_cdw.mat'];
load(prodname_new)

figure(8)
clf;set(gcf,'color','w');
pcolor(XX/1000,YY/1000,-VV_cdwf*rho0*beta)
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e6);
title('','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')









