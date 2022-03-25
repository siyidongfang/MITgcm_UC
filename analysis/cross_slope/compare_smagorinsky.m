clear;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/'
prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_check_heatbudget/';

fname1 = {'High-res,','fresh-shelf,','5-year mean'};
fname2 = {'Low-res,','fresh-shelf,','5-year mean'};


expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_60s';
loadexp;
yy_hires = yy;
bathy_hires =bathy;
expname = 'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod';
loadexp;
yy_lowres = yy;
bathy_lowres = bathy;


[ZZlores,YYlores] = meshgrid(zz,yy_lowres);
[ZZhires,YYhires] = meshgrid(zz,yy_hires);

load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_60s_tavg_5yrs.mat'],'UVEL','THETA','SALT');
THETA(THETA==0)=NaN;SALT(SALT==0)=NaN;UVEL(UVEL==0)=NaN;
tt_xavg_hires = squeeze(nanmean(THETA));
ss_xavg_hires = squeeze(nanmean(SALT));
uu_xavg_hires = squeeze(nanmean(UVEL));

clear THETA UVEL SALT
load([prodir 'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_tavg_5yrs.mat'],'UVEL','THETA','SALT');

THETA(THETA==0)=NaN;SALT(SALT==0)=NaN;UVEL(UVEL==0)=NaN;
tt_xavg_lowres = squeeze(nanmean(THETA));
ss_xavg_lowres = squeeze(nanmean(SALT));
uu_xavg_lowres = squeeze(nanmean(UVEL));


figure(5)
clf;
subplot(1,2,1)
pcolor(yy_hires/1000,-zz/1000,ss_xavg_hires')
hold on;plot(yy_hires/1000,-bathy_hires(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_hires/1000,-bathy_hires(49,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YYhires/1000,-ZZhires/1000,ss_xavg_hires,[32.3:0.1:34.6 34.61:0.01:34.7],'EdgeColor','w','LineWidth',1);

shading interp;axis ij;colormap('jet');colorbar
caxis([32.7 34.7])
title('Salinity (psu)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname1,'interpreter','latex','FontSize',15)


subplot(1,2,2)
pcolor(yy_lowres/1000,-zz/1000,ss_xavg_lowres')
hold on;plot(yy_lowres/1000,-bathy_lowres(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_lowres/1000,-bathy_lowres(25,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YYlores/1000,-ZZlores/1000,ss_xavg_lowres,[32.3:0.1:34.6 34.61:0.01:34.7],'EdgeColor','w','LineWidth',1);
shading interp;axis ij;colormap('jet');colorbar
caxis([32.7 34.7])
title('Salinity (psu)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname2,'interpreter','latex','FontSize',15)

print('-dpng','-r150',[outdir 'fresh_compare_resolution_S2.png']);


figure(1)
clf;
subplot(2,2,1)
pcolor(yy_hires/1000,-zz/1000,uu_xavg_hires');
hold on;plot(yy_hires/1000,-bathy_hires(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_hires/1000,-bathy_hires(49,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.4 0.4])
title('Zonal velociy (m/s)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname1,'interpreter','latex','FontSize',15)

subplot(2,2,2)
pcolor(yy_lowres/1000,-zz/1000,uu_xavg_lowres');
hold on;plot(yy_lowres/1000,-bathy_lowres(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_lowres/1000,-bathy_lowres(25,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.4 0.4])
title('Zonal velociy (m/s)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname2,'interpreter','latex','FontSize',15)


subplot(2,2,3)
pcolor(yy_hires/1000,-zz/1000,tt_xavg_hires')
hold on;plot(yy_hires/1000,-bathy_hires(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_hires/1000,-bathy_hires(49,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YYhires/1000,-ZZhires/1000,tt_xavg_hires,[-1.9:0.2:2],'EdgeColor','w','LineWidth',1);
[C,h]=contour(YYhires/1000,-ZZhires/1000,tt_xavg_hires,[0 0],'EdgeColor','green','LineWidth',2);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-1.8 1.8])
title('Potential temperature (degC)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname1,'interpreter','latex','FontSize',15)


subplot(2,2,4)
pcolor(yy_lowres/1000,-zz/1000,tt_xavg_lowres')
hold on;plot(yy_lowres/1000,-bathy_lowres(1,:)/1000,'k--','LineWidth',1.5);
plot(yy_lowres/1000,-bathy_lowres(25,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YYlores/1000,-ZZlores/1000,tt_xavg_lowres,[-1.9:0.2:2],'EdgeColor','w','LineWidth',1);
[C,h]=contour(YYlores/1000,-ZZlores/1000,tt_xavg_lowres,[0 0],'EdgeColor','green','LineWidth',2)
shading interp;axis ij;colormap('redblue');colorbar
caxis([-1.8 1.8])
title('Potential temperature (degC)')
ylabel('z (km)');xlabel('y (km)')
text(10,2.8,fname2,'interpreter','latex','FontSize',15)

print('-dpng','-r150',[outdir 'fresh_compare_resolution2.png']);
