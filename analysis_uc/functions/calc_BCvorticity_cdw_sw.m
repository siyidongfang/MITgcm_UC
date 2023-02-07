%%%
%%% calc_BCvorticity_cdw_sw.m
%%%
%%% Calculate the baroclinic vorticity budget for the CDW layer and the
%%% surface layer.
%%% Interporate the results onto a finer grid


    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
        'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
        'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

    mask_interpolate;


    %%% Interpolate the momentum terms onto this new grid
    Um_dPhiXf = zeros(Nxf,Nyf,Nrf);
    Um_Advecf = zeros(Nxf,Nyf,Nrf);
    Um_Dissf = zeros(Nxf,Nyf,Nrf);
    Um_Extf = zeros(Nxf,Nyf,Nrf);
    Vm_dPhiYf = zeros(Nxf,Nyf,Nrf);
    Vm_Advecf = zeros(Nxf,Nyf,Nrf);
    Vm_Dissf = zeros(Nxf,Nyf,Nrf);
    Vm_Extf = zeros(Nxf,Nyf,Nrf);
    Um_Corif = zeros(Nxf,Nyf,Nrf);
    Vm_Corif = zeros(Nxf,Nyf,Nrf);
    Um_AdvZ3f = zeros(Nxf,Nyf,Nrf);
    Um_AdvRef = zeros(Nxf,Nyf,Nrf);
    Vm_AdvZ3f = zeros(Nxf,Nyf,Nrf);
    Vm_AdvRef = zeros(Nxf,Nyf,Nrf);

    %%% Piecewise-constant interpolation for momentum terms
for i=1:Nx
    i
    for j=1:Ny
        for k=1:Nr
            Um_dPhiXf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_dPhiX(i,j,k);
            Um_Advecf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Advec(i,j,k);
            Um_Dissf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Diss(i,j,k);
            Um_Extf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Ext(i,j,k);
            Vm_dPhiYf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_dPhiY(i,j,k);
            Vm_Advecf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Advec(i,j,k);
            Vm_Dissf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Diss(i,j,k);
            Vm_Extf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Ext(i,j,k);
            Um_Corif((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Cori(i,j,k);
            Vm_Corif((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Cori(i,j,k);
            Um_AdvZ3f((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_AdvZ3(i,j,k);
            Um_AdvRef((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_AdvRe(i,j,k);
            Vm_AdvZ3f((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_AdvZ3(i,j,k);
            Vm_AdvRef((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_AdvRe(i,j,k);
        end
    end
end



%%% Vorticity budget for the CDW layer
    mask_ugrid = mask_cdw_ugridf;
    mask_vgrid = mask_cdw_vgridf;
    prodname = [prodir expname '_BCvorticity_cdw.mat'];
    calc_BCvorticity_cdw_sw_zint;

%%% Vorticity budget for the surface layer
    mask_ugrid = mask_sw_ugridf;
    mask_vgrid = mask_sw_vgridf;
    prodname = [prodir expname '_BCvorticity_sw.mat'];
    calc_BCvorticity_cdw_sw_zint;

%%% Vorticity budget for all-depth integral
    mask_ugrid = 1;
    mask_vgrid = 1;
    prodname = [prodir expname '_BCvorticity_AllDepth.mat'];
    calc_BCvorticity_cdw_sw_zint;


clear Um_Corif Vm_Corif
clear Um_AdvZ3f Vm_AdvZ3f
clear Um_Extf Vm_Extf
clear Um_AdvRef Vm_AdvRef
clear Um_Dissf Vm_Dissf
clear Um_Advecf Vm_Advecf
clear Um_dPhiXf Vm_dPhiYf
clear hFacWf hFacSf DZf



if(showfigrue)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 18;
load_colors;
YLIM = [0 400];
CLIM = [-1 1]/1e5;

figure(1)
set(gcf,'Position',[1 503 1839 1000])
clf;set(gcf,'color','w');
subplot(2,2,1)
pcolor(XXf/1000,YYf/1000,zeta_dPhi)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,2)
pcolor(XXf/1000,YYf/1000,zeta_Advec)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,3)
pcolor(XXf/1000,YYf/1000,zeta_Diss)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Dissipation term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,4)
pcolor(XXf/1000,YYf/1000,zeta_Ext)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Surface stress term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '_cdw_vort.png']);
end


figure(11)
pcolor(XXf/1000,YYf/1000,zeta_residual)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);colormap(cmocean('balance'));
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Residual (Pa/m)','Interpreter','latex','FontSize',fontsize+3)



figure(2)
set(gcf,'Position',[62 305 1889 699])
clf;set(gcf,'color','w');
subplot(2,3,1)
colormap(cmocean('balance'));
pcolor(XX/1000,YY/1000,zeta_Cori)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
title('Coriolis term (model diagnosed) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,2)
pcolor(XX/1000,YY/1000,zeta_AdvZ3)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
title('Vorticity Advection (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,3)
pcolor(XX/1000,YY/1000,zeta_AdvRe)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
title('Vertical Advection (explicit part) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,5)
pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
title('Total Adv - (Cori + Vort Adv + Vert Adv) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_cdw_decomposeAdv.png']);
end


end
