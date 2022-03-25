%%%
%%% plotOverturning.m
%%%
%%% Plots the overturning circulation in potential temperature space.
%%%

%%% Load experiment and pre-computed MOC data
loadexp;
load([expname,'_MOC_pt.mat']);
%%
%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];
psimin = -5;
psimax = 5;

%%% Calculate zonal-mean density
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
vflux_xint = squeeze(nanmean(vflux(:,:,:)))*Lx;
vflux_m_xint = squeeze(nanmean(vflux_m(:,:,:)))*Lx;

%%% Overturning in y/pt space
figure(6);
clf;
axes('FontSize',16);
[PT YY] = meshgrid(ptlevs,yy);
contourf(YY/1000,PT,psi_pt,[psimin:0.1:psimax],'EdgeColor','None');
colorbar;
colormap redblue;
caxis([psimin -psimin]);
set(gca,'FontSize',15);
xlabel('y (km)');
ylabel('\theta (^oC)');

%%% Mean overturning in y/pt space
figure(7);
clf;
axes('FontSize',16);
[PT YY] = meshgrid(ptlevs,yy);
contourf(YY/1000,PT,psim_pt,[psimin:0.1:psimax],'EdgeColor','None');
colorbar;
colormap redblue;
caxis([psimin -psimin]);
set(gca,'FontSize',15);
xlabel('y (km)');
ylabel('\theta (^oC)');

%%% Eddy overturning in y/pt space
figure(8);
clf;
axes('FontSize',16);
[PT YY] = meshgrid(ptlevs,yy);
contourf(YY/1000,PT,psie_pt,[psimin:0.1:psimax],'EdgeColor','None');
colorbar;
colormap redblue;
caxis([psimin -psimin]);
set(gca,'FontSize',15);
xlabel('y (km)');
ylabel('\theta (^oC)');

%%% Isopycnal fluxes in y/pt space
figure(9);
clf;
axes('FontSize',16);
[PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
contourf(YY,PT,vflux_xint,30);
colorbar;
colormap redblue;

%%% Isopycnal fluxes in y/pt space
figure(10);
clf;
axes('FontSize',16);
[PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
contourf(YY,PT,vflux_m_xint,30);
colorbar;
colormap redblue;

%%% Isopycnal fluxes in y/pt space
figure(11);
clf;
axes('FontSize',16);
[PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
contourf(YY,PT,vflux_xint-vflux_m_xint,30);
colorbar;
colormap redblue;

%%% y/z grid for streamfunction plots
% makePsiGrid;
zz_psi = zz_f;
yy_psi = yy;
[ZZ_psi,YY_psi] = meshgrid(zz_psi,yy_psi);
for j=1:Ny      
  
  %%% Adjust height of top point
  ZZ_psi(j,1) = 0;
  
  %%% Calculate depth of bottom cell  
  hFacS_col = squeeze(hFacS_f(1,j,:));  
  kmax = length(hFacS_col(hFacS_col>0)); 
  if (kmax > 0)
    ZZ_psi(j,kmax) = - sum(delRf.*hFacS_col');
  end
  
  %%% Force streamfunction to be zero at boundaries
  psi_z(j,1) = 0;
  psie_z(j,1) = 0;
  psim_z(j,1) = 0;
  if (kmax > 0)
    psi_z(j,kmax) = 0;  
    psie_z(j,kmax) = 0;  
    psim_z(j,kmax) = 0;
  end
  
end

[ZZ,YY] = meshgrid(zz,yy);

%%% Plot the residual overturning in y/z space
handle = figure(10);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psi_z,[psimin:0.1:psimax],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);
% [C,h]=contour(YY_psi/1000,ZZ_psi/1000,psi_z,[psimin:0.025:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
% [C,h]=contour(YY/1000,ZZ_f/1000,psi_z,[psimin:0.01:psimax],'EdgeColor','k');  
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,[-0.5:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap redblue;
xlabel('Latitude $y$ (km)','interpreter','latex');
ylabel('Depth $z$ (km)','interpreter','latex');
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{res}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Isopycnal overturning streamfunction');

%%% Plot the mean streamfunction in y/z space
handle = figure(11);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psim_z,[psimin:0.1:psimax],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);
% [C,h]=contour(YY_psi,ZZ_psi,psim_z,[psimin:0.05:-0.05 0.05:0.05:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,[-0.5:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap redblue;
xlabel('Latitude $y$ (km)','interpreter','latex');
ylabel('Depth $z$ (km)','interpreter','latex');
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{mean}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Mean overturning streamfunction');

%%% Plot the eddy streamfunction in y/z space
handle = figure(12);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psie_z,[psimin:0.1:psimax],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);
% [C,h]=contour(YY_psi,ZZ_psi,psie_z,[psimin:0.05:-0.05 0.05:0.05:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,[-0.5:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap redblue;
xlabel('Latitude $y$ (km)','interpreter','latex');
ylabel('Depth $z$ (km)','interpreter','latex');
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{eddy}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Eddy overturning streamfunction');

%%% Fine-grid potential temperature
figure(13);
clf;
axes('FontSize',16);
[ZZ YY] = meshgrid(zz_f,yy);
contourf(YY,ZZ,pt_f_xtavg,ptlevs);
colorbar;
colormap jet;

%%% Coarse-grid potential temperature
figure(14);
clf;
axes('FontSize',16);
[ZZ YY] = meshgrid(zz,yy);
contourf(YY,ZZ,pt_xtavg,ptlevs);
colorbar;
colormap jet;
