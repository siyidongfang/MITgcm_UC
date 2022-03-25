%%%
%%% plotEulerianMOC.m
%%%
%%% Compares mean MOC with Eulerian-mean MOC.
%%%

%%% Load experiment and pre-computed MOC data
loadexp;
load([expname,'_MOC_pt.mat']);
load([expname,'_tavg.mat'],'vv');
calcEulerianMOC;

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];
psimin = -2.7;
psimax = 2.7;

%%% Calculate zonal-mean density
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));

%%% y/z grid for streamfunction plots
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
  psim_z(j,1) = 0;
  if (kmax > 0)    
    psim_z(j,kmax) = 0;
  end
  
end

[ZZ,YY] = meshgrid(zz,yy);

%%% Plot the mean streamfunction in y/z space
handle = figure(11);
set(handle,'Position',framepos);
clf;
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
set(gca,'FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
title('$\psi_{\mathrm{mean}}$ (Sv)','interpreter','latex');

%%% y/z grid for streamfunction plots
zz_psi = [0 -cumsum(delR)];
yy_psi = [0 cumsum(delY)];
[ZZ_psi,YY_psi] = meshgrid(zz_psi,yy_psi);
for j=1:Ny      
  
  %%% Adjust height of top point
  ZZ_psi(j,1) = 0;
  
  %%% Calculate depth of bottom cell  
  hFacS_col = squeeze(hFacS(1,j,:));  
  kmax = length(hFacS_col(hFacS_col>0)); 
  if (kmax > 0)
    ZZ_psi(j,kmax) = - sum(delR.*hFacS_col');
  end
  
  %%% Force streamfunction to be zero at boundaries  
  psim_z(j,1) = 0;
  if (kmax > 0)    
    psim_z(j,kmax) = 0;
  end
  
end

%%% Plot the Eulerian-mean streamfunction in y/z space
handle = figure(12);
set(handle,'Position',framepos);
clf;
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psiE/1e6,[psimin:0.1:psimax],'EdgeColor','None');  
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
set(gca,'FontSize',fontsize);
set(gca,'Position',plotloc);     
set(gca,'YDir','reverse');
set(gca,'clim',[psimin -psimin]);
title('$\psi_{\mathrm{EM}}$ (Sv)','interpreter','latex');
