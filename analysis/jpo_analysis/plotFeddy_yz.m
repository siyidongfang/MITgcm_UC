 %%
% % % % % % % % % %%% Plotting options
% % % % % % % % % addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
% % % % % % % % % mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
% % % % % % % % % fontsize = 10;
% % % % % % % % % position_1 = [222 575 524 284.5000];
% % % % % % % % % 
% % % % % % % % % %%% Initialize figure
% % % % % % % % % figure(6);
% % % % % % % % % clf;
% % % % % % % % % scrsz = get(0,'ScreenSize');
% % % % % % % % % set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 900 640]);
% % % % % % % % % set(gcf,'Color','w');
% % % % % % % % %  
% % % % % % % % % %%% Quiver options
% % % % % % % % % headWidth = 6;
% % % % % % % % % headLength = 6;
% % % % % % % % % LineLength = 0.2;
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % %%%%%%%
% % % % % % % % % %%%%%%% subplot1
% % % % % % % % % ax1 = subplot('position',[0.06 0.55 0.36 0.4]);
% % % % % % % % % uvel=UVEL;
% % % % % % % % % uvel(idx_bathy) = NaN;
% % % % % % % % % aaa1=squeeze(nanmean(uvel,1));
% % % % % % % % % FIG = pcolor(yy/1000,-zz/1000,aaa1');
% % % % % % % % % box on
% % % % % % % % % shading interp;axis ij;
% % % % % % % % % set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% % % % % % % % % hold on;
% % % % % % % % % plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
% % % % % % % % % plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% % % % % % % % % % quiver(YY(jidx,kidx)/1000,-ZZ(jidx,kidx)/1000,Fmom_y(jidx,kidx),Fmom_z(jidx,kidx),'AutoScale','on','ShowArrowHead','on','LineWidth',1,'Color','k');
% % % % % % % % % % quiver(yy(jidx,kidx)/1000,-zz(jidx,kidx)/1000,Fmom_y(jidx,kidx),Fmom_z(jidx,kidx),'AutoScale','on','ShowArrowHead','on','LineWidth',1,'Color','k');
% % % % % % % % % hold off;
% % % % % % % % % set(gca,'fontsize',fontsize);
% % % % % % % % % ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % title('u (m/s)','FontSize', fontsize+3,'interpreter','latex');
% % % % % % % % % colormap(mycolormap);
% % % % % % % % % caxis([-0.4 0.4]);
% % % % % % % % % set(gca,'YTick',[0:1:4]);
% % % % % % % % % handle = colorbar;
% % % % % % % % % set(handle,'FontSize',fontsize);
% % % % % % % % % set(gca,'clim',[-0.4 0.4]);
% % % % % % % % % colormap(ax1,redblue(30));
% % % % % % % % % set(handle,'Position',[0.43 0.55 0.01 0.4]);
% % % % % % % % %  
% % % % % % % % % %%% Figure label
% % % % % % % % % handle = annotation('textbox',[0.06 0.54 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% % % % % % % % %  
% % % % % % % % %  
% % % % % % % % %  
% % % % % % % % % %%%%%%%
% % % % % % % % % %%%%%%% subplot2
% % % % % % % % % ax2 = subplot('position',[0.57 0.55 0.36 0.4]);
% % % % % % % % % FIG = pcolor(yy/1000,-zz/1000,-uv_eddy_mean');shading interp;axis ij;
% % % % % % % % % set(FIG,'alphadata',~isnan(uv_eddy_mean'));set(gca,'color',[0.6 0.6 0.6]);
% % % % % % % % % hold on;
% % % % % % % % % plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
% % % % % % % % % plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% % % % % % % % % hold off;
% % % % % % % % % ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % title('$-\overline{u^{\prime}v^{\prime}}$ \ Lateral momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % % title('$-\overline{u^{\prime}v^{\prime}}$ \ Lateral eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % colormap(mycolormap);
% % % % % % % % % handle = colorbar;
% % % % % % % % % set(handle,'FontSize',fontsize);
% % % % % % % % % set(gca,'clim',[-3 3]/1e4);
% % % % % % % % % caxis([-3 3]/1e4)
% % % % % % % % % set(gca,'YTick',[0:1:4]);
% % % % % % % % % colormap(ax2,redblue(40).^2);
% % % % % % % % % set(handle,'Position',[0.94 0.55 0.01 0.4]);
% % % % % % % % % handle = annotation('textbox',[0.57 0.54 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% % % % % % % % %  
% % % % % % % % % 
% % % % % % % % % %%%%%%%
% % % % % % % % % %%%%%%% subplot3
% % % % % % % % % 
% % % % % % % % % ax3 = subplot('position',[0.06 0.06 0.36 0.4]);
% % % % % % % % % FIG = pcolor(yy/1000,-zz/1000,-uw_eddy_mean');shading interp;axis ij;
% % % % % % % % % set(FIG,'alphadata',~isnan(uw_eddy_mean'));set(gca,'color',[0.6 0.6 0.6]);
% % % % % % % % % hold on;
% % % % % % % % % plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
% % % % % % % % % plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% % % % % % % % % hold off;
% % % % % % % % % set(gca,'fontsize',fontsize);
% % % % % % % % % xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % title('$-\overline{w^{\prime}u^{\prime}}$ \ Vertical momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % % title('$-\overline{w^{\prime}u^{\prime}}$ \ Vertical eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % handle = colorbar;
% % % % % % % % % set(handle,'FontSize',fontsize);
% % % % % % % % % set(gca,'clim',[-1 1]/1e4);
% % % % % % % % % caxis([-1 1]/1e4);
% % % % % % % % % set(gca,'YTick',[0:1:4]);
% % % % % % % % % colormap(mycolormap);
% % % % % % % % % set(handle,'Position',[0.43 0.06 0.01 0.4]);
% % % % % % % % % handle = annotation('textbox',[0.06 0.05 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% % % % % % % % %  
% % % % % % % % % %%%%%%%
% % % % % % % % % %%%%%%% subplot4
% % % % % % % % % 
% % % % % % % % % ax4 = subplot('position',[0.57 0.06 0.36 0.4]);
% % % % % % % % % FIG = pcolor(yy/1000,-zz/1000,-fs_eddy_mean');
% % % % % % % % % box on
% % % % % % % % % shading interp;axis ij;
% % % % % % % % % set(FIG,'alphadata',~isnan(fs_eddy_mean'));set(gca,'color',[0.6 0.6 0.6]);
% % % % % % % % % hold on;
% % % % % % % % % plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
% % % % % % % % % plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
% % % % % % % % % hold off;
% % % % % % % % % set(gca,'fontsize',fontsize);
% % % % % % % % % % contour(aaa1','LineColor','w')
% % % % % % % % % xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% % % % % % % % % title('$f_0\overline{v^{\prime}b^{\prime}}/\overline{b_z}$ \ Form stress (tides + eddies)','FontSize', fontsize+3,'interpreter','latex');
% % % % % % % % % % title('$f_0\overline{v^{\prime}\theta^{\prime}}/\overline{\theta_z}$ \ Eddy form stress','FontSize', fontsize+3,'interpreter','latex');
% % % % % % % % % colormap(mycolormap);
% % % % % % % % % handle = colorbar;
% % % % % % % % % set(handle,'FontSize',fontsize);
% % % % % % % % % set(gca,'clim',[-1 1]/1e4);
% % % % % % % % % caxis([-1 1]/1e4);
% % % % % % % % % set(gca,'YTick',[0:1:4]);
% % % % % % % % % set(handle,'Position',[0.94 0.06 0.01 0.4]);
% % % % % % % % % handle = annotation('textbox',[0.57 0.05 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% % % % % % % % % 
% % % % % % % % % saveas(gcf,[exppath '/' imgname '/momBudget.png']);
% % % % % % % % % % saveas(gcf,[expdir imgname '/' expname '_u.png']);
% % % % % % % % % 



%%
clear;
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
prodir = '/data/MITgcm_ASF-csi/products-hires/';

loadexp;
load([prodir expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL','UV_VEL_Z','WU_VEL','THETA','SALT','PHIHYD','VVELSLT','VVELTH')
calcFeddy;

%%% Plotting options
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
fontsize = 10;
position_1 = [222 575 524 320];

figure(1);
clf;
FIG = pcolor(yy/1000,-zz/1000,-uv_tran_eddy_xint'/Lx);shading interp;axis ij;
set(FIG,'alphadata',~isnan(uv_tran_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$-\overline{u^{\prime}v^{\prime}}$ \ Lateral momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
title('$-\bigg[\overline{u^{\prime}v^{\prime}}\bigg]$ \ Lateral transient eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
h1=colorbar;
set(gca,'fontsize',fontsize);
caxis([-1 1]/1e3)
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_tran_uv.png']);


figure(2)
FIG = pcolor(yy/1000,-zz/1000,-uw_tran_eddy_xint'/Lx);shading interp;axis ij;
set(FIG,'alphadata',~isnan(uw_tran_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$-\overline{w^{\prime}u^{\prime}}$ \ Vertical momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
title('$-\bigg[\overline{w^{\prime}u^{\prime}}\bigg]$ \ Vertical transient eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
h2=colorbar;set(gca,'fontsize',fontsize);
%  caxis([-2 2]/1e6);
caxis([-2 2]/1e4);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_tran_uw.png']);


figure(3)
FIG = pcolor(yy/1000,-zz/1000,fs_tran_eddy_xint'/Lx);
box on
shading interp;axis ij;
set(FIG,'alphadata',~isnan(fs_tran_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$f_0\overline{v^{\prime}b^{\prime}}/\overline{b_z}$ \ Form stress (tides + eddies)','FontSize', fontsize+3,'interpreter','latex');
% title('$f_0\overline{v^{\prime}\gamma^{\prime}}/\overline{\gamma_z}$ \ Transient eddy form stress','FontSize', fontsize+3,'interpreter','latex');
title('$\bigg[f(\beta\overline{v^{\prime}S^{\prime}} -\alpha\overline{v^{\prime}\theta^{\prime}}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$ \ Transient eddy form stress','FontSize', fontsize+3,'interpreter','latex');
colormap(mycolormap);
h3=colorbar;set(gca,'fontsize',fontsize);
caxis([-2 2]/1e4);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;

saveas(gcf,['eddyFormStress/' expname '_tran_form.png']);


figure(4)
FIG = pcolor(yy/1000,-zz/1000,(-uw_tran_eddy_xint+fs_tran_eddy_xint)'/Lx);
box on
shading interp;axis ij;
set(FIG,'alphadata',~isnan(fs_tran_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('$-\bigg[\overline{w^{\prime}u^{\prime}}\bigg]+\bigg[f(\beta\overline{v^{\prime}S^{\prime}} -\alpha\overline{v^{\prime}\theta^{\prime}}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$ ','FontSize', fontsize+3,'interpreter','latex');
colormap(mycolormap);
h3=colorbar;set(gca,'fontsize',fontsize);
caxis([-2 2]/1e4);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;

saveas(gcf,['eddyFormStress/' expname '_tran_vertical.png']);


% figure(4)
% FIG = pcolor(yy/1000,-zz/1000,dgamma_dz_xmean');
% shading interp;axis ij;colorbar
% colormap(mycolormap);
% caxis([-1 1]/1e7);
% % 
% 
% 
% figure(5)
% vgamma_tran_xint = squeeze(mean(vgamma_tran,1));
% FIG = pcolor(yy/1000,-zz/1000,vgamma_tran_xint');
% shading interp;axis ij;colorbar
% colormap(mycolormap);
% caxis([-1 1]/1e8);




figure(6);
clf;
FIG = pcolor(yy/1000,-zz/1000,-uv_std_eddy_xint'/Lx);shading interp;axis ij;
set(FIG,'alphadata',~isnan(uv_std_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$-\overline{u^{\prime}v^{\prime}}$ \ Lateral momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
title('$-\bigg[u^{\star}v^{\star}\bigg]$ \ Lateral standing eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
h1=colorbar;
set(gca,'fontsize',fontsize);
caxis([-1 1]/1e3)
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_std_uv.png']);


figure(7)
FIG = pcolor(yy/1000,-zz/1000,-uw_std_eddy_xint'/Lx);shading interp;axis ij;
set(FIG,'alphadata',~isnan(uw_std_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$-\overline{w^{\prime}u^{\prime}}$ \ Vertical momentum flux (tides + eddies)','FontSize', fontsize+2,'interpreter','latex');
title('$-\bigg[w^{\star}u^{\star}\bigg]$ \ Vertical standing eddy momentum flux','FontSize', fontsize+2,'interpreter','latex');
colormap(mycolormap);
h2=colorbar;set(gca,'fontsize',fontsize);
caxis([-3 3]/1e6);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_std_uw.png']);


figure(8)
FIG = pcolor(yy/1000,-zz/1000,fs_std_eddy_xint'/Lx);
box on
shading interp;axis ij;
set(FIG,'alphadata',~isnan(fs_std_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$f\overline{v^{\star}\gamma^{\star}}/\overline{\gamma_z}$ \ Standing eddy form stress','FontSize', fontsize+3,'interpreter','latex');
title('$\bigg[f(\beta v^{\star}S^{\star} -\alpha v^{\star}\theta^{\star}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$ \ Standing eddy form stress','FontSize', fontsize+3,'interpreter','latex');
colormap(mycolormap);
h3=colorbar;set(gca,'fontsize',fontsize);
caxis([-2 2]/1e4);
% caxis([-1 1]/1e5);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_std_form.png']);


figure(10)
FIG = pcolor(yy/1000,-zz/1000,(-uw_std_eddy_xint+fs_std_eddy_xint)'/Lx);
box on
shading interp;axis ij;
set(FIG,'alphadata',~isnan(fs_std_eddy_xint'/Lx));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
% title('$f\overline{v^{\star}\gamma^{\star}}/\overline{\gamma_z}$ \ Standing eddy form stress','FontSize', fontsize+3,'interpreter','latex');
title('$-\bigg[w^{\star}u^{\star}\bigg]+\bigg[f(\beta v^{\star}S^{\star} -\alpha v^{\star}\theta^{\star}) /(\beta \overline{S_z} - \alpha\overline{\theta_z})\bigg]$','FontSize', fontsize+3,'interpreter','latex');
colormap(mycolormap);
h3=colorbar;set(gca,'fontsize',fontsize);
caxis([-2 2]/1e4);
% caxis([-1 1]/1e5);
set(gca,'YTick',[0:1:4]);
set(gca,'XTick',[0:100:450]);
PLOT = gcf;
PLOT.Position = position_1;
saveas(gcf,['eddyFormStress/' expname '_std_vertical.png']);
