%%%
%%% calcMomBudget_xy.m
%%%
%%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
%%%

rho0 = 999.8;

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori');
% load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
% 'Um_Cori','Um_AdvZ3','Um_AdvRe');

%%% Grid spacing matrices

Um_dPhiX(Um_dPhiX==0)=NaN;
Um_Advec(Um_Advec==0)=NaN;
Um_Diss(Um_Diss==0)=NaN;
Um_Ext(Um_Ext==0)=NaN;

Vm_dPhiY(Vm_dPhiY==0)=NaN;
Vm_Advec(Vm_Advec==0)=NaN;
Vm_Diss(Vm_Diss==0)=NaN;
Vm_Ext(Vm_Ext==0)=NaN;


%%% momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_zint = rho0.*sum(Um_dPhiX.*hFacW.*DZ,3,'omitnan');
Vm_dPhiX_zint = rho0.*sum(Vm_dPhiY.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Advection terms
Um_Advec_zint = rho0.*sum(Um_Advec.*hFacW.*DZ,3,'omitnan');
Vm_Advec_zint = rho0.*sum(Vm_Advec.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Dissipation
Um_Diss_zint = rho0.*sum(Um_Diss.*hFacW.*DZ,3,'omitnan');
Vm_Diss_zint = rho0.*sum(Vm_Diss.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from external forcing
Um_Ext_zint = rho0.*sum(Um_Ext.*hFacW.*DZ,3,'omitnan');
Vm_Ext_zint = rho0.*sum(Vm_Ext.*hFacS.*DZ,3,'omitnan');


%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))

% %%% U momentum tendency from Vorticity Advection
% Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
% %%% U momentum tendency from vertical Advection (Explicit part)
% Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3,'omitnan');
Vm_Cori_zint = rho0.*sum(Vm_Cori.*hFacS.*DZ,3,'omitnan');

% totalchange_tendency = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint+AB_gU_zint;
totalchange_tendencyU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
totalchange_tendencyV = Vm_dPhiX_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;



if(useSEAICE)
    %%% Calculate wind stress from EXF wind speeds
    rho_a = 1.3;               %%% Air density, kg/m^3
    load ([exppath '/setParams'],'Ua','Va')
    Ua(Ua==0)=1e-8;
    uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
    vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1);
    zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind; 
    meridWindFile = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;
else 
    %%% Load surface wind stress 
    fid = fopen(fullfile(exppath,'input','zonalWindFile.bin'),'r','b');
    zonalWind = fread(fid,[Nx Ny],'real*8');
    fclose(fid);
    fid = fopen(fullfile(exppath,'input','meridWindFile.bin'),'r','b');
    meridWind = fread(fid,[Nx Ny],'real*8');
    fclose(fid);
end


Um_dPhiX_zint(Um_dPhiX_zint==0)=NaN;
Um_Advec_zint(Um_Advec_zint==0)=NaN;
Um_Diss_zint(Um_Diss_zint==0)=NaN;
totalchange_tendencyU(totalchange_tendencyU==0)=NaN;
Vm_dPhiX_zint(Vm_dPhiX_zint==0)=NaN;
Vm_Advec_zint(Vm_Advec_zint==0)=NaN;
Vm_Diss_zint(Vm_Diss_zint==0)=NaN;
totalchange_tendencyV(totalchange_tendencyV==0)=NaN;

fontsize = 18;
load_colors;
YLIM = [0 400];

figure(7)
set(gcf,'Position',[1 503 1839 1000])
clf;set(gcf,'color','w');
subplot(2,2,1)
pcolor(XX/1000,YY/1000,Um_dPhiX_zint)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]*5);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Pressure gradient force (Pa)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,2)
pcolor(XX/1000,YY/1000,Um_Advec_zint)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]*5);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Coriolis force (Pa)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,3)
pcolor(XX/1000,YY/1000,Um_Diss_zint)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/50);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom dissipation (Pa)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,4)
pcolor(XX/1000,YY/1000,totalchange_tendencyU)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/50);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Residual term (Pa)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '/geomom_x.png']);
end






figure(8)
set(gcf,'Position',[1 503 1839 1000])
clf;set(gcf,'color','w');
subplot(2,2,1)
pcolor(XX/1000,YY/1000,Vm_dPhiX_zint)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]*5);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Pressure gradient force (Pa)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,2)
pcolor(XX/1000,YY/1000,Vm_Advec_zint)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]*5);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Coriolis force (Pa)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,3)
pcolor(XX/1000,YY/1000,Vm_Diss_zint)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/50);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom dissipation (Pa)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,4)
pcolor(XX/1000,YY/1000,totalchange_tendencyV)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/50);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Residual term (Pa)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '/geomom_y.png']);
end
    