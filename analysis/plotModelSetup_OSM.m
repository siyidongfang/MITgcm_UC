%%%
%%% plotModelSetup_NSF.m
%%%
%%% Plots the experiment setup for our NSF proposal.
%%%

%%% Select simulation
proddir = '/Volumes/Kilchoman/UCLA/Projects/MITgcm_ACC/products';
expdir = '/Volumes/Kilchoman/UCLA/Projects/MITgcm_ACC/experiments';
expname = 'ACC_tau0.15_b500_hires';

%%% Load data
loadexp;
load(fullfile(proddir,[expname,'_tavg.mat']));
uu = UVEL;
tt = THETA;

%%% Plotting options
mac_plots = 1;
scrsz = get(0,'ScreenSize');
fontsize = 16;
framepos = [scrsz(3)/4 scrsz(4)/4 600 600];
ucntrs = -.3:.01:.3;
idx = Nx/2;
m1km = 1000;
Ls = 100*m1km; %%% Shelf width
Ln = 100*m1km; %%% Width of northern boundary layer

%%% Mesh grid 
[ZZ YY] = meshgrid(zz,yy);
for j=1:Ny      
  
  %%% Adjust height of top point
  ZZ(j,1) = 0;
  
  %%% Calculate depth of bottom cell  
  hFacC_col = squeeze(hFacC(1,j,:));  
  kmax = length(hFacC_col(hFacC_col>0));
  if (kmax > 0)
    ZZ(j,kmax) = - sum(delR.*hFacC_col');
  end   
  
end

%%% Mask topography
uu(uu==0) = NaN;
% uu_plot = squeeze(nanmean(uu,1));
uu_plot = squeeze(uu(idx,:,:));
uu_plot(uu_plot==0) = NaN;
tt(tt==0) = NaN;
% tt_plot = squeeze(nanmean(tt,1));
tt_plot = squeeze(tt(idx,:,:));
tt_plot(tt_plot==0) = NaN;

%%% Plot the zonal-mean stratification and zonal velocity
handle = figure(21);
clf;
set(handle,'Position',framepos);

subplot(3,1,2);
plot(yy/1000,zonalWind(1,:),'b-','LineWidth',2);
hold on;
plot(yy/1000,0*yy,'k--','LineWidth',0.5);
hold off;
set(gca,'Position',[0.13 0.75 0.73 0.22]);     
set(gca,'FontSize',fontsize);
set(gca,'XTick',[500:500:2000]);
set(gca,'YLim',[-0.1 0.175]);
xlabel('');
ylabel({'Zonal wind';'stress (N/m$^2$)'},'FontSize',fontsize,'interpreter','latex');

BB = repmat(bathy(idx,:)',[1 Nr]);
msk_shade = NaN*YY;
msk_shade(((YY>Ly-Ln) & (ZZ>BB))) = 1;
msk_alpha = 0.4*msk_shade;
msk_shade(msk_shade == 1) = 0;

subplot(3,1,3);
[C,h]=contourf(YY/1000,-ZZ,uu_plot,ucntrs,'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(idx,:),'k','LineWidth',3);
[C,h]=contour(YY/1000,-ZZ,tt_plot,[0:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
clabel(C,h,'FontSize',fontsize-2,'LabelSpacing',400);
hold off;
axis([0 2000 0 4000]);
handle=colorbar;
set(handle,'FontSize',fontsize);
set(handle,'Position',[0.8967    0.12000    0.0233    0.5600]);
caxis([min(ucntrs) max(ucntrs)]);
colormap(gca,cmocean('balance',length(ucntrs)));
set(gca,'YDir','reverse');
xlabel('Latitude $y$ (km)','FontSize',fontsize,'interpreter','latex');
ylabel('Depth (m)','FontSize',fontsize,'interpreter','latex');
set(gca,'Position',[0.13 0.12 0.73 0.56]);     
set(gca,'clim',[min(ucntrs) max(ucntrs)]);
set(gca,'FontSize',fontsize);
set(gca,'XTick',[500:500:2000]);

hold on;
h = pcolor(YY/1000,-ZZ,msk_shade);
set(h,'FaceAlpha','flat');
set(h,'AlphaDataMapping','none');
set(h,'AlphaData',msk_alpha);
shading flat;
set(h,'facecolor','k');
hold off;

annotation('textbox',[0.8 0.022 0.3 0.05],'String',{'Zonal';'velocity (m/s)'},'interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% annotation('textbox',[0.02 0.76 0.05 0.04],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% annotation('textbox',[0.02 0.54 0.05 0.04],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% annotation('textbox',[0.02 0.05 0.05 0.04],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

text(2450,1500,'Restoring','Rotation',270,'FontSize',fontsize);
