%%%
%%% plotModelOverview_3D.m
%%%
%%%%%%%%%%%%%%%%%%%%
%%%%% 3D PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%


%%% Plotting options
Tmax = 0.6;
Tmin = -1.9;   
colorcontours = Tmin:0.1:Tmax;    
plotlabel = '$\theta$ ($^\circ$C)';    
Gmax = 28.55;
Gmin = 27.7;
blackcontours = [28.1 28.2 28.3 28.45];
linecolor = 'None';
kmin = 1; %%% Specifies minimum vertical index from which to plot 
           %%% - useful for cutting of the surface mixed layer           
plotgrad = 2;  %%% This is the only configuration parameter for the plot perspective. It
               %%% measures the gradients (with x/y in km and z in m) of the lines 
               %%% emanating from the bottom corner of the figure.

% %%% Experiment  
% expdir = './TS_prod_batch';
% expname = 'TS_tau0.075_Ws75_Hs500_Ymax25_Ly450_Sflux2.5e-3_res0.5km';
% plotIter = 1771686;
% 
% %%% Load the experiment data
% loadexp;
% 
% %%% Index of the field in the output file 
% outfidx = 1;
%   
% %%% Needed to fill in missing neutral density points
% addpath ~/Caltech/Utilities/Inpaint_nans/Inpaint_nans
%      
% %%% Load temperature data
% A_T = rdmds(fullfile(exppath,'results','T'),plotIter);        
% if (isempty(A_T))
%   error('Could not load MITgcm output data');
% end
% Txy = squeeze(A_T(:,2:Ny-1,kmin));
% Txz = squeeze(A_T(:,2,:));
% Tyz = squeeze(A_T(Nx,2:Ny-1,:));        
% 
% %%% Load salinity data
% A_S = rdmds(fullfile(exppath,'results','S'),plotIter);
% if (isempty(A_S))
%   error('Could not load MITgcm output data');
% end
% Sxy = squeeze(A_S(:,2:Ny-1,kmin));
% Sxz = squeeze(A_S(:,2,:));
% Syz = squeeze(A_S(Nx,2:Ny-1,:));      
%   
% %%% Calculate neutral density
% [ZZ_yz,YY_yz] = meshgrid(zz(kmin:Nr),yy(2:Ny-1)/1000);
% Gyz = gamma_n_pt(Tyz,Syz,YY_yz,ZZ_yz)';
% [YY_xy,XX_xy] = meshgrid(yy(2:Ny-1)/1000,xx/1000);
% ZZ_xy = zz(kmin)*ones(size(XX_xy));    
% Gxy = gamma_n_pt(Txy,Sxy,YY_xy,ZZ_xy)';    
% [ZZ_xz,XX_xz] = meshgrid(zz(kmin:Nr),xx);
% YY_xz = yy(2)*ones(size(XX_xz))/1000;  
% Gxz = gamma_n_pt(Txz,Sxz,YY_xz,ZZ_xz)';  
%     
% %%% Interpolate to fill in missing NaN values
% Gyz(Gyz < 27) = NaN;
% Gyz = inpaint_nans(Gyz,3);
% Gyz(Tyz==0) = NaN;
% Gxy(Gxy < 27) = NaN;
% Gxy = inpaint_nans(Gxy,3);
% Gxy(Txy==0) = NaN;
% Gxz(Gxz < 27) = NaN;
% Gxz = inpaint_nans(Gxz,3);
% Gxz(Txz==0) = NaN;
% 
% %%% Bottom topography
% hb = -bathy(1,:);
% 
% save JPO_3D_data.mat expdir expname plotIter xx yy zz hb Nx Ny Nr hFacC ... 
%   YY_yz ZZ_yz XX_xy YY_xy XX_xz ZZ_xz Txy Txz Tyz Sxy Sxz Syz Gxy Gxz Gyz;

%%% Load data from file
load JPO_3D_data.mat;

%%% Remove land points
Tyz(Tyz==0) = NaN;
Txz(Txz==0) = NaN;
Txy(Txy==0) = NaN;

%%% Ensure that contours are plotted over the same ranges
Txz(1,kmin) = Tmax;
Txz(Nx,kmin) = Tmin;
Txz(~isnan(Txz)) = min(Txz(~isnan(Txz)),Tmax);
Txz(~isnan(Txz)) = max(Txz(~isnan(Txz)),Tmin);
Tyz(1,kmin) = Tmin;
Tyz(Ny-2,kmin) = Tmax;
Tyz(~isnan(Tyz)) = min(Tyz(~isnan(Tyz)),Tmax);
Tyz(~isnan(Tyz)) = max(Tyz(~isnan(Tyz)),Tmin);
Txy(1,Ny-2) = Tmax;
Txy(1,1) = Tmin;
Txy(~isnan(Txy)) = min(Txy(~isnan(Txy)),Tmax);
Txy(~isnan(Txy)) = max(Txy(~isnan(Txy)),Tmin);
  
%%% Ensure that contours are plotted over the same ranges
Gxz(1,kmin) = Gmax;
Gxz(Nx,kmin) = Gmin;
Gxz(~isnan(Gxz)) = min(Gxz(~isnan(Gxz)),Gmax);
Gxz(~isnan(Gxz)) = max(Gxz(~isnan(Gxz)),Gmin);
Gyz(1,kmin) = Gmin;
Gyz(Ny-2,kmin) = Gmax;
Gyz(~isnan(Gyz)) = min(Gyz(~isnan(Gyz)),Gmax);
Gyz(~isnan(Gyz)) = max(Gyz(~isnan(Gyz)),Gmin);
Gxy(1,Ny-2) = Gmax;
Gxy(1,1) = Gmin;
Gxy(~isnan(Gxy)) = min(Gxy(~isnan(Gxy)),Gmax);
Gxy(~isnan(Gxy)) = max(Gxy(~isnan(Gxy)),Gmin);

%%% Initialize the plot axes
ax4 = subplot('position',[0.04 0.02 0.4 0.4]);

%%% Ploy y/z surface
[ZZ,YY] = meshgrid(zz(kmin:Nr),yy(2:Ny-1)/1000);
for j=1:Ny-2  
  hFacC_col = squeeze(hFacC(Nx,j+1,:));  
  kmax = length(hFacC_col(hFacC_col>0));  
  zz_botface = -sum(hFacC_col.*delR');
  ZZ(j,1) = 0;
  if (kmax>0)
    ZZ(j,kmax) = zz_botface;
  end
end
YY = YY-min(min(YY));
ZZ = ZZ-max(max(ZZ));
YY2 = YY;
ZZ2 = ZZ + plotgrad*YY;
contourf(YY2,ZZ2,Tyz(:,kmin:Nr),colorcontours,'EdgeColor',linecolor);
caxis([Tmin Tmax]);
hold on;
[C,h]=contour(YY2,ZZ2,Gyz(:,kmin:Nr),blackcontours,'EdgeColor','k');
clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',120);

%%% Plot x/z surface
[ZZ XX] = meshgrid(zz(kmin:Nr),xx/1000);
for i=1:Nx
  hFacC_col = squeeze(hFacC(i,2,:));  
  kmax = length(hFacC_col(hFacC_col>0));  
  zz_botface = -sum(hFacC_col.*delR');
  ZZ(i,1) = 0;
  if (kmax>0)
    ZZ(i,kmax) = zz_botface;
  end
end
XX = (XX-max(max(XX)));
ZZ = ZZ-max(max(ZZ));
XX3 = XX;
ZZ3 = ZZ - plotgrad*XX;
contourf(XX3,ZZ3,Txz(:,kmin:Nr),colorcontours,'EdgeColor',linecolor)
caxis([Tmin Tmax]);
contour(XX3,ZZ3,Gxz(:,kmin:Nr),blackcontours,'EdgeColor','k');
 
%%% Plot x/y surface
[XX YY] = meshgrid(xx/1000,yy(2:Ny-1)/1000);
XX = XX-min(min(XX));
YY = YY-min(min(YY));
YY4 = YY - XX;
XX4 = plotgrad*XX + plotgrad*YY;
contourf(YY4,XX4,flipdim(Txy',2),colorcontours,'EdgeColor',linecolor);
caxis([Tmin Tmax]);
contour(YY4,XX4,flipdim(Gxy',2),blackcontours,'EdgeColor','k');

%%% Draw bottom topography
hb_plot = hb(2:Ny-1)+zz(kmin);
yy_hb = (yy(2:Ny-1)-yy(2))/1000;
plot(yy_hb,-hb_plot+plotgrad*yy_hb,'k-','LineWidth',1);
hb_plot = repmat(hb(2),[1 Nx])+zz(kmin);
xx_hb = (xx-xx(Nx))/1000;
plot(xx_hb,-hb_plot-plotgrad*xx_hb,'k-','LineWidth',1);

%%% Draw the edges of the cuboid
linewidth = 1;
plot([YY2(1,1) YY2(1,end)],[ZZ2(1,1) ZZ2(1,end)],'k-','LineWidth',linewidth);
plot([YY2(1,1) YY2(end,1)],[ZZ2(1,1) ZZ2(end,1)],'k-','LineWidth',linewidth);
plot([YY2(end,1) YY2(end,end)],[ZZ2(end,1) ZZ2(end,end)],'k-','LineWidth',linewidth);
plot([YY2(end,end) YY2(1,end)],[ZZ2(end,end) ZZ2(1,end)],'k-','LineWidth',linewidth);
plot([XX3(1,1) XX3(1,end)],[ZZ3(1,1) ZZ3(1,end)],'k-','LineWidth',linewidth);
plot([XX3(1,1) XX3(end,1)],[ZZ3(1,1) ZZ3(end,1)],'k-','LineWidth',linewidth);
plot([XX3(end,1) XX3(end,end)],[ZZ3(end,1) ZZ3(end,end)],'k-','LineWidth',linewidth);
plot([XX3(end,end) XX3(1,end)],[ZZ3(end,end) ZZ3(1,end)],'k-','LineWidth',linewidth);
plot([YY4(1,1) YY4(1,end)],[XX4(1,1) XX4(1,end)],'k-','LineWidth',linewidth);
plot([YY4(1,1) YY4(end,1)],[XX4(1,1) XX4(end,1)],'k-','LineWidth',linewidth);
plot([YY4(end,1) YY4(end,end)],[XX4(end,1) XX4(end,end)],'k-','LineWidth',linewidth);
plot([YY4(end,end) YY4(1,end)],[XX4(end,end) XX4(1,end)],'k-','LineWidth',linewidth);

%%% Finish off the figure
hold off;
axis tight;
axis off;
set(gca,'XTick',[]);
set(gca,'YTick',[]);

%%% Create a colorbar
h = colorbar;
set(h,'FontSize',fontsize);
set(h,'Position',[0.46 0.09 0.01 0.26]);
caxis([Tmin Tmax]);
colormap(ax4,jet(length(colorcontours)-1)); 
annotation('textbox',[0.44 0.05 0.3 0.01],'String','$\theta$ ($^\circ$C)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

%%% Label domain sizes
annotation('doublearrow',[0.04 0.23],[0.08 0.01]);
annotation('textbox',[0.09 0.02 0.9 0.01],'String','$400\,$km','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% Create arrow
annotation('arrow',[0.07 0.128888888888889],...
  [0.113725490196078 0.0915032679738562]);
annotation('arrow',[0.07 0.0722222222222222],...
  [0.113725490196078 0.18]);
annotation('arrow',[0.07 0.123333333333333],...
  [0.113725490196078 0.130718954248366]);
annotation('textbox',...
  [0.127777777777778 0.0614379084967319 0.0988888888888889 0.0330718954248366],...
  'String','x',...
  'LineStyle','none',...
  'Interpreter','latex',...
  'FontSize',14,...
  'FitBoxToText','off');
annotation('textbox',...
  [0.08 0.163856209150326 0.0988888888888889 0.03],...
  'String','z',...
  'LineStyle','none',...
  'Interpreter','latex',...
  'FontSize',14,...
  'FitBoxToText','off');
annotation('textbox',...
  [0.125555555555556 0.111111111111111 0.0988888888888889 0.0330718954248366],...
  'String','y',...
  'LineStyle','none',...
  'Interpreter','latex',...
  'FontSize',14,...
  'FitBoxToText','off');


%%% Figure label
annotation('textbox',[0 0.02 0.05 0.01],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


