%%%
%%% calc_BTvorticity_curl_int.m
%%%
%%% Calculate the barotropic vorticity budget using model diagnostics
%%% Take the curl first, then vertically integrate the vorticity budget terms


load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
    'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

DXC = rdmds(fullfile(resultspath,'DXC'));
DYC = rdmds(fullfile(resultspath,'DYC'));
RAZ = rdmds(fullfile(resultspath,'RAZ'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_dPhi_3D = zeros(Nx,Ny,Nr);
zeta_Advec_3D = zeros(Nx,Ny,Nr);
zeta_Diss_3D = zeros(Nx,Ny,Nr);
zeta_Ext_3D = zeros(Nx,Ny,Nr);

Um_dPhiX(Um_dPhiX==0)=NaN;
Vm_dPhiY(Vm_dPhiY==0)=NaN;
Um_Advec(Um_Advec==0)=NaN;
Vm_Advec(Vm_Advec==0)=NaN;
Um_Diss(Um_Diss==0)=NaN;
Vm_Diss(Vm_Diss==0)=NaN;
Um_Ext(Um_Ext==0)=NaN;
Vm_Ext(Vm_Ext==0)=NaN;

for k=1:Nr
    for i = 2:Nx
        for j = 2:Ny
            %%% Pressure torque
            zeta_dPhi_3D(i,j,k) = ( Um_dPhiX(i,j-1,k)*DXC(i,j-1) + Vm_dPhiY(i,j,k)*DYC(i,j) ...
                                  - Um_dPhiX(i,j,k)*DXC(i,j)     - Vm_dPhiY(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j); 
            
            %%% Advection term
            zeta_Advec_3D(i,j,k) = ( Um_Advec(i,j-1,k)*DXC(i,j-1) + Vm_Advec(i,j,k)*DYC(i,j) ...
                                   - Um_Advec(i,j,k)*DXC(i,j)     - Vm_Advec(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j); 
            
            %%% Dissipation term
            zeta_Diss_3D(i,j,k) = ( Um_Diss(i,j-1,k)*DXC(i,j-1) + Vm_Diss(i,j,k)*DYC(i,j) ...
                                   - Um_Diss(i,j,k)*DXC(i,j)     - Vm_Diss(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j); 
           
            %%% Surface stress term
            zeta_Ext_3D(i,j,k) = ( Um_Ext(i,j-1,k)*DXC(i,j-1) + Vm_Ext(i,j,k)*DYC(i,j) ...
                                 - Um_Ext(i,j,k)*DXC(i,j)     - Vm_Ext(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j);   
        end
    end
end

zeta_dPhi_3D(isnan(zeta_dPhi_3D))=0;
zeta_Advec_3D(isnan(zeta_Advec_3D))=0;
zeta_Diss_3D(isnan(zeta_Diss_3D))=0;
zeta_Ext_3D(isnan(zeta_Ext_3D))=0;

%%% Residual term
zeta_residual_3D = zeta_dPhi_3D + zeta_Advec_3D + zeta_Diss_3D + zeta_Ext_3D;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_Cori_3D = zeros(Nx,Ny,Nr);
zeta_AdvZ3_3D = zeros(Nx,Ny,Nr);
zeta_AdvRe_3D = zeros(Nx,Ny,Nr);

Um_Cori(Um_Cori==0)=NaN;
Vm_Cori(Vm_Cori==0)=NaN;
Um_AdvZ3(Um_AdvZ3==0)=NaN;
Vm_AdvZ3(Vm_AdvZ3==0)=NaN;
Um_AdvRe(Um_AdvRe==0)=NaN;
Vm_AdvRe(Vm_AdvRe==0)=NaN;

for k=1:Nr
    for i = 2:Nx
        for j = 2:Ny
            %%% Coriolis term (planetary vorticity advection)
            zeta_Cori_3D(i,j,k) = ( Um_Cori(i,j-1,k)*DXC(i,j-1) + Vm_Cori(i,j,k)*DYC(i,j) ...
                                  - Um_Cori(i,j,k)*DXC(i,j)     - Vm_Cori(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j); 
    
            %%% Vorticity Advection
            zeta_AdvZ3_3D(i,j,k) = ( Um_AdvZ3(i,j-1,k)*DXC(i,j-1) + Vm_AdvZ3(i,j,k)*DYC(i,j) ...
                                   - Um_AdvZ3(i,j,k)*DXC(i,j)     - Vm_AdvZ3(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j);
    
            %%% Vertical Advection (Explicit part)
            zeta_AdvRe_3D(i,j,k) = ( Um_AdvRe(i,j-1,k)*DXC(i,j-1) + Vm_AdvRe(i,j,k)*DYC(i,j) ...
                                   - Um_AdvRe(i,j,k)*DXC(i,j)     - Vm_AdvRe(i-1,j,k)*DYC(i-1,j) ) ./RAZ(i,j);
        end
    end
end

%%% Nonlinear advection term
zeta_nonLin_3D = zeta_Advec_3D - zeta_Cori_3D; 

%%% Ageostrophic term
zeta_ageo_3D = zeta_Advec_3D + zeta_dPhi_3D;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated vorticity budget %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFacZeta = zeros(Nx,Ny,Nr);


for i=1:Nx-1
    for j=2:Ny
        hFacZeta(i,j,:) = 0.25*( hFacW(i,j,:) + hFacW(i,j-1,:)...
                              + hFacS(i,j,:) + hFacS(i+1,j,:));
    end
end

zeta_dPhi = rho0.*sum(zeta_dPhi_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_Advec = rho0.*sum(zeta_Advec_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_Diss = rho0.*sum(zeta_Diss_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_Ext = rho0.*sum(zeta_Ext_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_residual = rho0.*sum(zeta_residual_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_Cori = rho0.*sum(zeta_Cori_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_AdvZ3 = rho0.*sum(zeta_AdvZ3_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_AdvRe = rho0.*sum(zeta_AdvRe_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_nonLin = rho0.*sum(zeta_nonLin_3D.*hFacZeta.*DZ,3,'omitnan');
zeta_ageo = rho0.*sum(zeta_ageo_3D.*hFacZeta.*DZ,3,'omitnan');


% % zeta_dPhi_3D_ugrid = zeta_dPhi_3D;
% % zeta_dPhi_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_dPhi_3D(:,1:Ny-1,:)+zeta_dPhi_3D(:,2:Ny,:));
% % zeta_Advec_3D_ugrid = zeta_Advec_3D;
% % zeta_Advec_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Advec_3D(:,1:Ny-1,:)+zeta_Advec_3D(:,2:Ny,:));
% % zeta_Diss_3D_ugrid = zeta_Diss_3D;
% % zeta_Diss_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Diss_3D(:,1:Ny-1,:)+zeta_Diss_3D(:,2:Ny,:));
% % zeta_Ext_3D_ugrid = zeta_Ext_3D;
% % zeta_Ext_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Ext_3D(:,1:Ny-1,:)+zeta_Ext_3D(:,2:Ny,:));
% % zeta_residual_3D_ugrid = zeta_residual_3D;
% % zeta_residual_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_residual_3D(:,1:Ny-1,:)+zeta_residual_3D(:,2:Ny,:));
% % 
% % zeta_dPhi = rho0.*sum(zeta_dPhi_3D_ugrid.*hFacW.*DZ,3,'omitnan');
% % zeta_Advec = rho0.*sum(zeta_Advec_3D_ugrid.*hFacW.*DZ,3,'omitnan');
% % zeta_Diss = rho0.*sum(zeta_Diss_3D_ugrid.*hFacW.*DZ,3,'omitnan');
% % zeta_Ext = rho0.*sum(zeta_Ext_3D_ugrid.*hFacW.*DZ,3,'omitnan');
% % zeta_residual = rho0.*sum(zeta_residual_3D_ugrid.*hFacW.*DZ,3,'omitnan');


% % zeta_dPhi_3D_vgrid = zeta_dPhi_3D;
% % zeta_dPhi_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_dPhi_3D(1:Nx-1,:,:)+zeta_dPhi_3D(2:Nx,:,:));
% % zeta_Advec_3D_vgrid = zeta_Advec_3D;
% % zeta_Advec_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Advec_3D(1:Nx-1,:,:)+zeta_Advec_3D(2:Nx,:,:));
% % zeta_Diss_3D_vgrid = zeta_Diss_3D;
% % zeta_Diss_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Diss_3D(1:Nx-1,:,:)+zeta_Diss_3D(2:Nx,:,:));
% % zeta_Ext_3D_vgrid = zeta_Ext_3D;
% % zeta_Ext_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Ext_3D(1:Nx-1,:,:)+zeta_Ext_3D(2:Nx,:,:));
% % zeta_residual_3D_vgrid = zeta_residual_3D;
% % zeta_residual_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_residual_3D(1:Nx-1,:,:)+zeta_residual_3D(2:Nx,:,:));
% % 
% % zeta_dPhi = rho0.*sum(zeta_dPhi_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% % zeta_Advec = rho0.*sum(zeta_Advec_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% % zeta_Diss = rho0.*sum(zeta_Diss_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% % zeta_Ext = rho0.*sum(zeta_Ext_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% % zeta_residual = rho0.*sum(zeta_residual_3D_vgrid.*hFacS.*DZ,3,'omitnan');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 18;
load_colors;
figure(1)
set(gcf,'Position',[234 88 1361 1110])
clf;set(gcf,'color','w');
subplot(3,2,1)
pcolor(XX/1000,YY/1000,zeta_dPhi)
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('Pressure torque (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,2)
pcolor(XX/1000,YY/1000,zeta_Advec)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,3)
pcolor(XX/1000,YY/1000,zeta_Diss)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Dissipation term (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,4)
pcolor(XX/1000,YY/1000,zeta_Ext)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Surface stress term (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(3,2,5)
pcolor(XX/1000,YY/1000,zeta_residual)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Residual term  (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_vort.png']);
end


figure(2)
set(gcf,'Position',[90 232 2201 776])
clf;set(gcf,'color','w');
subplot(2,3,1)
colormap(cmocean('balance'));
pcolor(XX/1000,YY/1000,zeta_Cori)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Coriolis term (model diagnosed) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,2)
pcolor(XX/1000,YY/1000,zeta_AdvZ3)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Vorticity Advection (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,3)
pcolor(XX/1000,YY/1000,zeta_AdvRe)
shading flat;colorbar;
caxis([-1 1]/1e5);
title('Vertical Advection (explicit part) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,5)
pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
shading flat;colorbar;colormap(cmocean('balance'));
caxis([-1 1]/1e5);
title('Total Adv - (Cori + Vort Adv + Vert Adv) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_decomposeAdv.png']);
end


% figure(3)
% clf;set(gcf,'color','w');
% pcolor(XX/1000,YY/1000,zeta_Cori_betaV)
% shading flat;colorbar;colormap(cmocean('balance'));
% caxis([-1 1]/1e5);
% title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_betaV.png']);
% end



