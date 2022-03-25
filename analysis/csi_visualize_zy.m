clear;
addpath ../.
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/exps_cross-slope-exchange/';
% expdir = '/home/csi/MITgcm_ASF-experiments';
% expname  = 'lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_sdiff3'
expname  = 'lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_ssurf30'

loadexp;


OUTPUT = 'avg'

switch (OUTPUT)
    case 'avg'
        imgname = 'img_yearly';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'years';
        fname = '.';
    case 'inst'
        imgname = 'img_analysis_inst';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = 'years, inst.';
        fname = '_inst.';
end

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

xx = xx + abs(xx(1));

% scrsz = get(0,'ScreenSize');
if (Lx == 400000)
    position_1 = [148   273   345   300]*1.5;
    position_2 = [563   282   820   306]*1.5;
    position_topview = [401   259   537   546];
else if (Lx == 200000)
     position_1 = [240   274   308   531]*1.5;
     position_2 = [538   273   660   532]*1.5;
     position_topview = [46   152   322   595];
    end
end

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 11;
% framepos = [0 scrsz(4)/2 700 550];
% plotloc = [0.15 0.15 0.7 0.75];

% for m = 1:size(dumpIters,2)
for m =1:1
Ntime = navg(m*10-9:m*10);

fignum = 1;

figure(fignum);
fignum = fignum + 1;
clf;
subplot(1,2,2)
salt0=rdmds([exppath,'/results/SALT' fname Ntime]);
BATHY = salt0;
idx_bathy = (BATHY==0);
salt0(idx_bathy) = NaN;
salt=squeeze(nanmean(salt0,1));
FIG = pcolor(yy/1000,-zz,salt');shading interp;axis ij;
set(FIG,'alphadata',~isnan(salt'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(yy/1000,-zz,salt','LineColor','w');
plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
ylabel('Depth (m)','FontSize', fontsize+2);
title(['S (psu), t = ' num2str(m) ' ' TIME]);colormap('default');colorbar;set(gca,'fontsize',fontsize);
% caxis([33.3 34.75]); % fresh shelf
caxis([33.6 34.75]); % dense shelf

subplot(1,2,1)
theta0=rdmds([exppath,'/results/THETA' fname Ntime]);
theta0(idx_bathy) = NaN;
theta=squeeze(nanmean(theta0,1));
FIG = pcolor(yy/1000,-zz,theta');shading interp;axis ij;
set(FIG,'alphadata',~isnan(theta'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
% [c,h]= contourf(yy/1000,-zz,theta',layers_bounds(:,2),'LineColor','w');
%  h.LevelList=round(h.LevelList,3);  %rounds levels to 3rd decimal place
%  clabel(c,h,'FontSize',7);
% contour(yy/1000,-zz,theta',layers_bounds(:,2),'LineColor','w');
plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
ylabel('Depth (m)','FontSize', fontsize+2);
title(['T (degC), t = ' num2str(m) ' ' TIME]);colormap('default');colorbar;set(gca,'fontsize',fontsize);
% caxis([-2.5 1.2]);
 caxis([-2.1 1.2]);
PLOT = gcf;
PLOT.Position = position_2;
% saveas(gcf,[exppath '/' imgname '/TS_' TIME num2str(m) '.png']);

% figure(fignum);
% fignum = fignum + 1;
% clf;
% subplot(1,2,1)
% uvelth0=rdmds([exppath,'/results/UVELTH' fname Ntime]);
% uvelth0(idx_bathy) = NaN;
% uvelth=squeeze(nanmean(uvelth0,1));
% FIG = pcolor(yy/1000,-zz,uvelth');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(uvelth'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(yy/1000,-zz,uvelth','LineColor','w');
% plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
% plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
% hold off;
% xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Depth (m)','FontSize', fontsize+2);
% title({'Zonal Transport of Pot Temp'; ['(degC.m/s), t = ' num2str(m) ' ' TIME]});colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-0.5 0.5]);
% 
% subplot(1,2,2)
% uvelslt0=rdmds([exppath,'/results/UVELSLT' fname Ntime]);
% uvelslt0(idx_bathy) = NaN;
% uvelslt=squeeze(nanmean(uvelslt0,1));
% FIG = pcolor(yy/1000,-zz,uvelslt');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(uvelslt'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(yy/1000,-zz,uvelslt','LineColor','w');
% plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
% plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
% hold off;
% xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Depth (m)','FontSize', fontsize+2);
% title({'Zonal Transport of Salinity'; ['(psu.m/s), t = ' num2str(m) ' ' TIME]});colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-20 20]);
% PLOT = gcf;
% PLOT.Position = position_2;
% saveas(gcf,[exppath '/' imgname '/UVELTH_UVELSLT_' TIME num2str(m) '.png']);
% 
% figure(fignum);
% fignum = fignum + 1;
% clf;
% subplot(1,2,1)
% vvelth0=rdmds([exppath,'/results/VVELTH' fname Ntime]);
% vvelth0(idx_bathy) = NaN;
% vvelth=squeeze(nanmean(vvelth0,1));
% FIG = pcolor(yy/1000,-zz,vvelth');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(vvelth'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(yy/1000,-zz,vvelth','LineColor','w');
% plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
% plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
% hold off;
% xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Depth (m)','FontSize', fontsize+2);
% title({'Meridional Transport of Pot Temp'; ['(degC.m/s), t = ' num2str(m) ' ' TIME]});colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-0.03 0.03]);
%  
% subplot(1,2,2)
% vvelslt0=rdmds([exppath,'/results/VVELSLT' fname Ntime]);
% vvelslt0(idx_bathy) = NaN;
% vvelslt=squeeze(nanmean(vvelslt0,1));
% FIG = pcolor(yy/1000,-zz,vvelslt');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(vvelslt'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(yy/1000,-zz,vvelslt','LineColor','w');
% plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
% plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
% hold off;
% xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Depth (m)','FontSize', fontsize+2);
% title({'Meridional Transport of Salinity'; ['(psu.m/s), t = ' num2str(m) ' ' TIME]});colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% caxis([-1 1]);
% 
% PLOT = gcf;
% PLOT.Position = position_2;
% saveas(gcf,[exppath '/' imgname '/VVELTH_VVELSLT_' TIME num2str(m) '.png']);

figure(fignum);
fignum = fignum + 1;
clf;
pot_dens0 = densmdjwf(salt0,theta0,1982.8.*ones(size(salt0))); 
pot_dens0(idx_bathy) = NaN;
pot_dens=squeeze(nanmean(pot_dens0,1));
FIG = pcolor(yy/1000,-zz,pot_dens');shading interp;axis ij;
set(FIG,'alphadata',~isnan(pot_dens'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
% [c,h]= contourf(yy/1000,-zz,pot_dens',layers_bounds(:,1)+1000,'LineColor','w');
%  h.LevelList=round(h.LevelList,3);  %rounds levels to 3rd decimal place
%  clabel(c,h,'FontSize',7);
% contour(yy/1000,-zz,pot_dens',layers_bounds(:,1)+1000,'LineColor','w');
plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
hold off;
xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
ylabel('Depth (m)','FontSize', fontsize+2);
title(['Potential Density (kg/m^3), t = ' num2str(m) ' ' TIME]);
colormap('jetvar');colorbar;set(gca,'fontsize',fontsize);
caxis([1036.2 1037.3]); % fresh shelf
% caxis([1036.4 1037.3]); % dense shelf 
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/pot_dens_' TIME num2str(m) '.png']);



figure(fignum);
fignum = fignum + 1;
clf;
uvel=rdmds([exppath,'/results/UVEL' fname Ntime]);
uvel(idx_bathy) = NaN;
aaa1=squeeze(nanmean(uvel,1));
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
hold off;
% contour(aaa1','LineColor','w')
xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
ylabel('Depth (m)','FontSize', fontsize+2);
title(['u (m/s), t = ' num2str(m) ' ' TIME]);
colormap redblue;colorbar;set(gca,'fontsize',fontsize);
caxis([-0.4 0.4]);
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/u_' TIME num2str(m) '.png']);


% % % figure(fignum);
% % % fignum = fignum + 1;
% % % clf;
% % % vvel=rdmds([exppath,'/results/VVEL' fname Ntime]);
% % % vvel(idx_bathy) = NaN;
% % % depth=rdmds([exppath,'/results/Depth']);
% % % % subplot(1,2,1)
% % % % % Plan view of the monthly mean currents at the bottom boundary layer
% % % % u_bottom = uvel();
% % % % [c,h]=contourf(xx'/1000,yy'/1000,depth',13);
% % % %  h.LevelList=round(h.LevelList,0);  %rounds levels to 3rd decimal place
% % % %  clabel(c,h,'FontSize',7);
% % % % hold on;
% % % % svx = 2;  % ?Step? Value
% % % % svy = 3;
% % % % curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
% % % %     u_bottom(1:svx:end,1:svy:end)',v_bottom(1:svx:end,1:svy:end)',0.7);
% % % % curr.Color = 'w';
% % % % curr.LineWidth = 0.75;
% % % % hold off;
% % % % xlabel('Alongshore distance (km)', 'FontSize', 13);
% % % % ylabel('Offshore distance (km)','FontSize', 13);
% % % % title(['Near bottom mean currents, t = ' num2str(m) ' ' TIME],'FontSize',13);
% % % 
% % % % subplot(1,2,1)
% % % % Plan view of the depth-averaged monthly mean current 
% % % u_depthavg = squeeze(nanmean(uvel,3));
% % % v_depthavg = squeeze(nanmean(vvel,3));
% % % [c,h]=contour(xx'/1000,yy'/1000,depth',13);
% % %  h.LevelList=round(h.LevelList,0);  %rounds levels to 3rd decimal place
% % %  clabel(c,h,'FontSize',7);
% % % hold on;
% % % svx = 13;  % ?Step? Value
% % % svy = 8;
% % % curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
% % %     u_depthavg(1:svx:end,1:svy:end)',v_depthavg(1:svx:end,1:svy:end)');
% % % curr.Color = 'k';
% % % curr.LineWidth = 0.75;
% % % hold off;
% % % xlim([0 inf]);
% % % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % % title(['Depth-averaged mean currents, t = ' num2str(m) ' ' TIME],'FontSize',fontsize);
% % % set(gca,'fontsize',fontsize);
% % % PLOT = gcf;
% % % PLOT.Position = position_topview;
% % % saveas(gcf,[exppath '/' imgname '/Depth-averaged_UV_' TIME num2str(m) '.png']);
% % % 
% % % 
% % % figure(fignum);
% % % fignum = fignum + 1;
% % % clf;
% % % % Plan view of the monthly mean surface ocean currents
% % % u_surf = squeeze(uvel(:,:,1));
% % % v_surf = squeeze(vvel(:,:,1));
% % % [c,h]=contour(xx'/1000,yy'/1000,depth',13);
% % %  h.LevelList=round(h.LevelList,0);  %rounds levels to 3rd decimal place
% % %  clabel(c,h,'FontSize',7);
% % % hold on;
% % % svx = 13;  % ?Step? Value
% % % svy = 8;
% % % curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
% % %     u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
% % % curr.Color = 'k';
% % % curr.LineWidth = 0.75;
% % % hold off;
% % % xlim([0 inf]);
% % % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % % title(['Surface mean currents, t = ' num2str(m) ' ' TIME],'FontSize',fontsize);
% % % set(gca,'fontsize',fontsize);
% % % PLOT = gcf;
% % % PLOT.Position = position_topview;
% % % saveas(gcf,[exppath '/' imgname '/UV_Surf_plan_' TIME num2str(m) '.png']);
% % % 
% % % figure(fignum);
% % % fignum = fignum + 1;
% % % clf;
% % % subplot(1,2,1)
% % % pcolor(xx/1000,yy/1000,u_surf');shading interp;
% % % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % % title(['Surface u_{o} (m/s), t = ' num2str(m) ' ' TIME]);
% % % colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% % % caxis([-0.5 0.5]);
% % % subplot(1,2,2)
% % % pcolor(xx/1000,yy/1000,v_surf');shading interp;
% % % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % % title(['Surface v_{o} (m/s), t = ' num2str(m) ' ' TIME]);
% % % colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
% % % caxis([-0.2 0.2]*2);
% % % PLOT = gcf;
% % % PLOT.Position = position_2;
% % % saveas(gcf,[exppath '/' imgname '/UV_Surf_' TIME num2str(m) '.png']);
% % % 
% % % 
% % % if(useSEAICE)
    
figure(fignum);
fignum = fignum + 1;
clf;
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIuice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
hold on;
% contour(xx/1000,yy/1000,aaaa','LineColor','w');
hold off;
xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
ylabel('Offshore distance (km)','FontSize', fontsize+2);
title(['u_{ice} (m/s), t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
caxis([-0.5 0.5]);

subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIvice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
hold on;
% contour(xx/1000,yy/1000,aaaa','LineColor','w');
hold off;
xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
ylabel('Offshore distance (km)','FontSize', fontsize+2);
title(['v_{ice} (m/s), t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',fontsize);
caxis([-0.2 0.2]);
PLOT = gcf;
PLOT.Position = position_2;
% saveas(gcf,[exppath '/' imgname '/UVice_' TIME num2str(m) '.png']);

figure(fignum);
fignum = fignum + 1;
clf;
aaaa=rdmds([exppath,'/results/SIarea' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
hold on;
contour(xx/1000,yy/1000,aaaa','LineColor','r');
hold off;
xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
ylabel('Offshore distance (km)','FontSize', fontsize+2);
title(['Sea ice concentration, t = ' num2str(m) ' ' TIME]);
colormap('gray');colorbar;
set(gca,'fontsize',fontsize);
caxis([0 1]);
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/SIarea_' TIME num2str(m) '.png']);

figure(fignum);
fignum = fignum + 1;
clf;
aaaa=rdmds([exppath,'/results/SIheff' fname Ntime]);
meanHEFF = nanmean(nanmean(aaaa))
pcolor(xx/1000,yy/1000,aaaa');shading interp;
hold on;
contour(xx/1000,yy/1000,aaaa','LineColor','k');
hold off;
xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
ylabel('Offshore distance (km)','FontSize', fontsize+2);
title(['Sea ice thickness (m), t = ' num2str(m) ' ' TIME]);
colormap('jetvar');colorbar;set(gca,'fontsize',fontsize);
caxis([0 2]);
PLOT = gcf;
PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/SIheff_' TIME num2str(m) '.png']);

% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % subplot(1,2,1)
% % aaaa=rdmds([exppath,'/results/SIqnet' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', 15);
% % ylabel('Offshore distance (km)','FontSize', 15);
% % title(['Ocean surface heatflux (W/m^2), t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',10);
% % caxis([-40 40]);
% % subplot(1,2,2)
% % aaaa=rdmds([exppath,'/results/SIempmr' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['Ocean surface freshwater flux (kg/m^2/s), t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',fontsize);
% % caxis([-2 2]/10^4);
% % PLOT = gcf;
% % PLOT.Position = position_2;
% % saveas(gcf,[exppath '/' imgname '/SIqnet_empmr_' TIME num2str(m) '.png']);
% % 
% % 
% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % subplot(1,2,1)
% % aaaa=rdmds([exppath,'/results/SIareaPR' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa'-1);shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', 15);
% % ylabel('Offshore distance (km)','FontSize', 15);
% % title(['A_i preceeding ridging process, t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',10);
% % caxis([-5 5]/10^2);
% % subplot(1,2,2)
% % aaaa=rdmds([exppath,'/results/SIareaPT' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa'-1);shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['A_i preceeding thermodynamic growth/melt, t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',fontsize);
% % caxis([-5 5]/10^2);
% % PLOT = gcf;
% % PLOT.Position = position_2;
% % saveas(gcf,[exppath '/' imgname '/SIareaPR_areaPT_' TIME num2str(m) '.png']);
% % 
% % 
% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % aaaa=rdmds([exppath,'/results/SItices' fname Ntime])-273.15;
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['Surface T over Sea Ice, t = ' num2str(m) ' ' TIME]);
% % colormap('jetvar');colorbar;
% % set(gca,'fontsize',fontsize);
% % caxis([-3 0]);
% % meanSItices = nanmean(nanmean(aaaa(:,2:end)))
% % PLOT = gcf;
% % PLOT.Position = position_1;
% % saveas(gcf,[exppath '/' imgname '/SItices_' TIME num2str(m) '.png']);
% % 
% % 
% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % subplot(1,2,1)
% % aaaa=rdmds([exppath,'/results/SIdHbATC' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['dh_i/dt (air, m/s), t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',fontsize);
% % caxis([-1.5 1.5]/10^7);
% % subplot(1,2,2)
% % aaaa=rdmds([exppath,'/results/SIdHbOCN' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['dh_i/dt (ocean, m/s), t = ' num2str(m) ' ' TIME]);
% % colormap('redblue');colorbar;
% % set(gca,'fontsize',fontsize);
% % caxis([-2 2]/10^7);
% % PLOT = gcf;
% % PLOT.Position = position_2;
% % saveas(gcf,[exppath '/' imgname '/SIdHbATC-OCN_' TIME num2str(m) '.png']);

% 
% figure(fignum);
% fignum = fignum + 1;
% clf;
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIdAbATC' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title(['A_i rate by air-ice flux (1/s), t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',fontsize);
% caxis([-2 2]/10^7);
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIdAbOCN' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title(['A_i rate by ocean-ice flux (1/s), t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',fontsize);
% caxis([-2 2]/10^7);
% PLOT = gcf;
% PLOT.Position = position_2;
% saveas(gcf,[exppath '/' imgname '/SIdSbATC-OCN_' TIME num2str(m) '.png']);

% figure(fignum);
% fignum = fignum + 1;
% clf;
% aaaa=rdmds([exppath,'/results/SIsnPrcp' fname Ntime])-273.15;
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title(['Snow precip., t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;
% set(gca,'fontsize',fontsize);
% % caxis([-1.5 -0.3]);
% PLOT = gcf;
% PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/SIsnPrcp_' TIME num2str(m) '.png']);

end




% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % vvel=rdmds([exppath,'/results/VVEL' fname Ntime]);
% % vvel(idx_bathy) = NaN;
% % aaa1=squeeze(nanmean(vvel,1));
% % FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
% % set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% % hold on;
% % plot(yy/1000,-bathy(1,:),'--','color',[96,96,96]/255,'LineWidth',2.5);
% % plot(yy/1000,-bathy(25,:),'color',[96,96,96]/255,'LineWidth',2.5);
% % hold off;
% % % contour(aaa1','LineColor','w')
% % xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Depth (m)','FontSize', fontsize+2);
% % title(['v (m/s), t = ' num2str(m) ' ' TIME]);
% % colormap redblue;colorbar;set(gca,'fontsize',fontsize);
% % caxis([-0.005 0.005]*100);
% % PLOT = gcf;
% % PLOT.Position = position_1;
% % saveas(gcf,[exppath '/' imgname '/v_' TIME num2str(m) '.png']);
% % 

% figure(fignum);
% fignum = fignum + 1;
% clf;
% aaaa=rdmds([exppath,'/results/WVEL' fname Ntime]);
% aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
% FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% xlabel('Offshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Depth (m)','FontSize', fontsize+2);
% title(['w (m/s), t = ' num2str(m) ' ' TIME]);
% colormap redblue;colorbar;set(gca,'fontsize',fontsize);
% caxis([-1 1]/1000);
% PLOT = gcf;
% PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/WVEL_' TIME num2str(m) '.png']);


% figure(fignum);
% fignum = fignum + 1;
% clf;
% aaaa=rdmds([exppath,'/results/THETA' fname Ntime]);
% aaa1=squeeze(aaaa(:,:,1));
% pcolor(xx/1000,yy/1000,aaa1');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% ylabel('Offshore distance (km)','FontSize', fontsize+2);
% title(['SST (degC), t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',fontsize);
% caxis([-1.9 -0.5]);
% if(useSEAICE)
%     caxis([-1.9 -1.7]);
% end
% % caxis([-2.1 0.9]);
% 
% PLOT = gcf;
% PLOT.Position = position_1;
% saveas(gcf,[exppath '/' imgname '/SST_' TIME num2str(m) '.png']);

 
% % figure(fignum);
% % fignum = fignum + 1;
% % clf;
% % aaaa=rdmds([exppath,'/results/ETAN' fname Ntime]);
% % pcolor(xx/1000,yy/1000,aaaa');shading interp;
% % hold on;
% % contour(xx/1000,yy/1000,aaaa','LineColor','w');
% % hold off;
% % xlabel('Alongshore distance (km)', 'FontSize', fontsize+2);
% % ylabel('Offshore distance (km)','FontSize', fontsize+2);
% % title(['\eta (m), t = ' num2str(m) ' ' TIME]);
% % colormap('jetvar');colorbar;set(gca,'fontsize',fontsize);
% % caxis([-0.5 0.5]);
% % % caxis([-6 -4.5]);
% % 
% % PLOT = gcf;
% % PLOT.Position = position_1;
% % saveas(gcf,[exppath '/' imgname '/etan_' TIME num2str(m) '.png']);



% end



