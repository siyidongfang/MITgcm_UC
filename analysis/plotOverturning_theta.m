%%%
%%% plotOverturning.m
%%%
%%% Plots the overturning circulation in potential density space.
%%%

%%% Load experiment and pre-computed MOC data
loadexp;
% load([expdir '/' expname '/' expname '_MOC_pt_5yrs.mat']);
load([outdir '/' expname '_MOC_theta.mat']);

imgname = 'img_5yrs';


%%% Set colormap
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 16;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];
psimin = -0.8;
psimax = 0.8;

%%% Calculate zonal-mean density
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
vflux_xint = squeeze(nanmean(vflux_tavg(:,:,:)))*Lx;
vflux_m_xint = squeeze(nanmean(vflux_m(:,:,:)))*Lx;

% % % % %%% Overturning in y/pt space
% % % % figure(6);
% % % % clf;
% % % % axes('FontSize',16);
% % % % [PT YY] = meshgrid(ptlevs,yy);
% % % % contourf(YY/1000,PT,psi_pt,[psimin:0.005:psimax],'EdgeColor','None');
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % caxis([psimin -psimin]);
% % % % set(gca,'FontSize',15);
% % % % ylim([1036.2 1037.2]);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');
% % % % saveas(gcf,[exppath '/' imgname '/Y-RHOspace_res.png']);
% % % % 
% % % % 
% % % % %%% Mean overturning in y/pt space
% % % % figure(7);
% % % % clf;
% % % % axes('FontSize',16);
% % % % [PT YY] = meshgrid(ptlevs,yy);
% % % % contourf(YY/1000,PT,psim_pt,[psimin:0.005:psimax],'EdgeColor','None');
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % caxis([psimin -psimin]);
% % % % ylim([1036.2 1037.2]);
% % % % set(gca,'FontSize',fontsize);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');
% % % % saveas(gcf,[exppath '/' imgname '/Y-RHOspace_mean.png']);
% % % % 
% % % % %%% Eddy overturning in y/pt space
% % % % figure(8);
% % % % clf;
% % % % axes('FontSize',16);
% % % % [PT YY] = meshgrid(ptlevs,yy);
% % % % contourf(YY/1000,PT,psie_pt,[psimin:0.005:psimax],'EdgeColor','None');
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % caxis([psimin -psimin]);
% % % % set(gca,'FontSize',fontsize);
% % % % ylim([1036.2 1037.2]);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');
% % % % saveas(gcf,[exppath '/' imgname '/Y-RHOspace_eddy.png']);
% % % % 
% % % % %%% Isopycnal fluxes in y/pt space
% % % % figure(9);
% % % % clf;
% % % % axes('FontSize',16);
% % % % [PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
% % % % contourf(YY/1000,PT,vflux_xint,30);
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % ylim([1036.2 1037.2]);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');
% % % % 
% % % % %%% Isopycnal fluxes in y/pt space
% % % % figure(10);
% % % % clf;
% % % % axes('FontSize',fontsize);
% % % % [PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
% % % % contourf(YY/1000,PT,vflux_m_xint,30);
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % ylim([1036.2 1037.2]);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');
% % % % 
% % % % %%% Isopycnal fluxes in y/pt space
% % % % figure(11);
% % % % clf;
% % % % axes('FontSize',fontsize);
% % % % [PT YY] = meshgrid((ptlevs(2:end)+ptlevs(1:end-1))/2,yy);
% % % % contourf(YY/1000,PT,vflux_xint-vflux_m_xint,30);
% % % % colorbar;
% % % % colormap(mycolormap);
% % % % ylim([1036.2 1037.2]);
% % % % xlabel('y (km)');
% % % % ylabel('\rho (kg/m^3)');

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
handle = figure(12);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psi_z,[-inf psimin:0.002:psimax inf],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% [C,h]=contour(YY_psi/1000,ZZ_psi/1000,psi_z,[psimin:0.025:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
% [C,h]=contour(YY/1000,ZZ_f/1000,psi_z,[psimin:0.01:psimax],'EdgeColor','k');  
% [C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,[-0.5:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
colormap(mycolormap);
xlabel('Offshore distance $y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]/3);
set(gca,'fontsize',fontsize);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{res}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Isopycnal overturning streamfunction','FontSize',fontsize+2);

saveas(gcf,[exppath '/' imgname '/layers_IsopycnalOverturn_theta.png']);


%%% Plot the mean streamfunction in y/z space
handle = figure(13);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psim_z,[-inf psimin:0.005:psimax inf],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% [C,h]=contour(YY_psi,ZZ_psi,psim_z,[psimin:0.05:-0.05 0.05:0.05:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap(mycolormap);
xlabel('Offshore distance $y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
set(gca,'fontsize',fontsize);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{mean}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Mean overturning streamfunction','FontSize',fontsize+2);

saveas(gcf,[exppath '/' imgname '/layers_MeanOverturn_theta.png']);


%%% Plot the eddy streamfunction in y/z space
handle = figure(14);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psie_z,[-inf psimin:0.005:psimax inf],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% [C,h]=contour(YY_psi,ZZ_psi,psie_z,[psimin:0.05:-0.05 0.05:0.05:psimax],'EdgeColor','k');  
% clabel(C,h,'manual','Color','w','FontSize',fontsize-10);
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,'EdgeColor','k');
hold off;
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap(mycolormap);
xlabel('Offshore distance $y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
set(gca,'fontsize',fontsize);
annotation('textbox',[0.75 0.05 0.3 0.05],'String','$\psi_{\mathrm{eddy}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Eddy overturning streamfunction','FontSize',fontsize+2);

saveas(gcf,[exppath '/' imgname '/layers_EddyOverturn_theta.png']);


%%% Fine-grid potential density
handle = figure(15);
clf;
axes('FontSize',16);
set(handle,'Position',framepos);
[ZZ YY] = meshgrid(zz_f,yy);
% contourf(YY/1000,-ZZ/1000,pt_f_xtavg-1000,ptlevs(:,1)-1000);
contourf(YY/1000,-ZZ/1000,pt_f_xtavg,ptlevs);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
hold off;
handle = colorbar;colormap jet;
set(handle,'FontSize',fontsize);
xlabel('Offshore distance $y$ (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth $z$ (km)','interpreter','latex','FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
title('Potential Temperature (degC)');
% set(gca,'clim',[1036.2 1037.2]-1000);
set(gca,'fontsize',fontsize);

saveas(gcf,[exppath '/' imgname '/layers_theta.png']);

% %%% Coarse-grid potential density
% figure(16);
% clf;
% axes('FontSize',16);
% [ZZ YY] = meshgrid(zz,yy);
% contourf(YY/1000,ZZ,pt_xtavg,ptlevs);
% hold on;
% plot(yy/1000,bathy(1,:),'k','LineWidth',2);
% hold off;
% colorbar;colormap jet;set(gca,'fontsize',13);
% title('Potential Density (kg/m^3)');
% caxis([1036.2 1037.2]);
% PLOT = gcf;
% PLOT.Position = [240 554 377 290];