%%%
%%% calc_BTvorticity_uc.m
%%%
%%% Calculate the barotropic vorticity budget for the undercurrent


load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
    'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

dxg = rdmds(fullfile(resultspath,'DXG'));
dyf = rdmds(fullfile(resultspath,'DYF'));
raz = rdmds(fullfile(resultspath,'RAZ'));

DXG = dxg(xidx,yidx);
DYF = dyf(xidx,yidx);
RAZ = raz(xidx,yidx);

%%% Find (x,y,z) indices for the undercurrent
uu_slope = uu(xidx,yidx,zidx);
mask_uc = zeros(length(xidx),length(yidx),length(zidx)); %%% mask of the undercurrent
mask_uc(uu_slope>0)=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated momentum equation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% momentum tendency from hydrostatic pressure gradient
Um_dPhiX_zint = rho0.*sum(mask_uc.*Um_dPhiX(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_dPhiY_zint = rho0.*sum(mask_uc.*Vm_dPhiY(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%% momentum tendency from advection terms
Um_Advec_zint = rho0.*sum(mask_uc.*Um_Advec(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_Advec_zint = rho0.*sum(mask_uc.*Vm_Advec(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%% momentum tendency from dissipation
Um_Diss_zint = rho0.*sum(mask_uc.*Um_Diss(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_Diss_zint = rho0.*sum(mask_uc.*Vm_Diss(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%% momentum tendency from external forcing (ice-ocean stress)
Um_Ext_zint = rho0.*sum(mask_uc.*Um_Ext(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_Ext_zint = rho0.*sum(mask_uc.*Vm_Ext(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%% Residual term
residualU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
residualV = Vm_dPhiY_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;

%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(mask_uc.*Um_Cori(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_Cori_zint = rho0.*sum(mask_uc.*Vm_Cori(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
 
%%% momentum tendency from Vorticity Advection
Um_AdvZ3_zint = rho0.*sum(mask_uc.*Um_AdvZ3(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_AdvZ3_zint = rho0.*sum(mask_uc.*Vm_AdvZ3(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%% momentum tendency from Vertical Advection (Explicit part)
Um_AdvRe_zint = rho0.*sum(mask_uc.*Um_AdvRe(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');
Vm_AdvRe_zint = rho0.*sum(mask_uc.*Vm_AdvRe(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3,'omitnan');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_dPhi = zeros(length(xidx),length(yidx));
zeta_Advec = zeros(length(xidx),length(yidx));
zeta_Diss = zeros(length(xidx),length(yidx));
zeta_Ext = zeros(length(xidx),length(yidx));

for i = 2:length(xidx)
    for j = 2:length(yidx)
        %%% Pressure torque
        zeta_dPhi(i,j) = ( Um_dPhiX_zint(i,j-1)*DXG(i,j-1) + Vm_dPhiY_zint(i,j)*DYF(i,j) ...
                         - Um_dPhiX_zint(i,j)*DXG(i,j)     - Vm_dPhiY_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
        
        %%% Advection term
        zeta_Advec(i,j) = ( Um_Advec_zint(i,j-1)*DXG(i,j-1) + Vm_Advec_zint(i,j)*DYF(i,j) ...
                          - Um_Advec_zint(i,j)*DXG(i,j)     - Vm_Advec_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
        
        %%% Dissipation term
        zeta_Diss(i,j) = ( Um_Diss_zint(i,j-1)*DXG(i,j-1) + Vm_Diss_zint(i,j)*DYF(i,j) ...
                         - Um_Diss_zint(i,j)*DXG(i,j)     - Vm_Diss_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
       
        %%% Surface stress term
        zeta_Ext(i,j) = ( Um_Ext_zint(i,j-1)*DXG(i,j-1) + Vm_Ext_zint(i,j)*DYF(i,j) ...
                        - Um_Ext_zint(i,j)*DXG(i,j)     - Vm_Ext_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);   
    end
end
      
%%% Residual term
zeta_residual = zeta_dPhi + zeta_Advec + zeta_Diss + zeta_Ext;

zeta_dPhi(zeta_dPhi==0)=NaN;
zeta_Advec(zeta_Advec==0)=NaN;
zeta_Diss(zeta_Diss==0)=NaN;
zeta_Ext(zeta_Ext==0)=NaN;
zeta_residual(zeta_residual==0)=NaN;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VV = sum(mask_uc.*vv(xidx,yidx,zidx).*hFacS(xidx,yidx,zidx).*DZ(xidx,yidx,zidx),3);
zeta_Cori_betaV = -rho0*beta.*VV;
zeta_Cori_betaV(zeta_Cori_betaV==0)=NaN;

zeta_Cori = zeros(length(xidx),length(yidx));
zeta_AdvZ3 = zeros(length(xidx),length(yidx));
zeta_AdvRe = zeros(length(xidx),length(yidx));

for i = 2:length(xidx)
    for j = 2:length(yidx)
        %%% Coriolis term (planetary vorticity advection)
        zeta_Cori(i,j) = ( Um_Cori_zint(i,j-1)*DXG(i,j-1) + Vm_Cori_zint(i,j)*DYF(i,j) ...
                         - Um_Cori_zint(i,j)*DXG(i,j)     - Vm_Cori_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 

        %%% Vorticity Advection
        zeta_AdvZ3(i,j) = ( Um_AdvZ3_zint(i,j-1)*DXG(i,j-1) + Vm_AdvZ3_zint(i,j)*DYF(i,j) ...
                          - Um_AdvZ3_zint(i,j)*DXG(i,j)     - Vm_AdvZ3_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);

        %%% Vertical Advection (Explicit part)
        zeta_AdvRe(i,j) = ( Um_AdvRe_zint(i,j-1)*DXG(i,j-1) + Vm_AdvRe_zint(i,j)*DYF(i,j) ...
                          - Um_AdvRe_zint(i,j)*DXG(i,j)     - Vm_AdvRe_zint(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);
    end
end

zeta_Cori(zeta_Cori==0)=NaN;
zeta_AdvZ3(zeta_AdvZ3==0)=NaN;
zeta_AdvRe(zeta_AdvRe==0)=NaN;

%%% Nonlinear advection term
zeta_nonLin = zeta_Advec - zeta_Cori; 

%%% Ageostrophic term
zeta_ageo = zeta_Advec + zeta_dPhi;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 18;
load_colors;
YLIM = [Ymin-5*m1km Ymax+3*m1km]/1000;

figure(1)
set(gcf,'Position',[1 503 1839 549])
clf;set(gcf,'color','w');
subplot(2,2,1)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_dPhi)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,2)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_Advec)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,3)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_Diss)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Dissipation term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,4)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_residual)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Residual term  (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '_uc_vort.png']);
end

figure(2)
set(gcf,'Position',[1 142 2503 566])
clf;set(gcf,'color','w');
subplot(2,3,1)
colormap(cmocean('balance'));
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_Cori)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
title('Coriolis term (model diagnosed) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,2)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_AdvZ3)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
title('Vorticity Advection (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,3)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_AdvRe)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
title('Vertical Advection (explicit part) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

subplot(2,3,5)
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/1e4);
title('Total Adv - (Cori + Vort Adv + Vert Adv) (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_uc_decomposeAdv.png']);
end


figure(3)
clf;set(gcf,'color','w');
set(gcf,'Position',[704 169 1000 236])
pcolor(XX(xidx,yidx)/1000,YY(xidx,yidx)/1000,zeta_Cori_betaV)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis([-1 1]/5e6);
title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:10:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_uc_betaV.png']);
end
