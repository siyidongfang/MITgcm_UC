close all;clear all;
%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
% expdir = '/Volumes/LaCie/'
expname = 'sIce5_5km_ai1hi1_Lx200_nobumps_atide0.05_2windZonal-0.1_2ob_Suice0Svice0.05_lwdown343Tis-0.65'
loadexp;

OUTPUT = 'inst'
% OUTPUT = 'inst'

switch (OUTPUT)
    case 'avg'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'mon';
        fname = '.';
    case 'inst'
        imgname = 'img_inst';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = 'days';
        fname = '_inst.';
end

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

xx = xx + abs(xx(1));


% for m = (9*365+180)/5:size(dumpIters,2)
% for m =52:52
for m =657:size(dumpIters,2)
Ntime = navg(m*10-9:m*10);

tt = m*5;

figure(1)
subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SALT' fname Ntime]);
bathy = squeeze(aaaa(1,:,:));
idx_bathy = (bathy==0);
aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(yy/1000,-zz,aaa1','LineColor','w');
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(['S (psu) at t = ' num2str(tt) ' ' TIME]);colormap('default');colorbar;set(gca,'fontsize',13);
caxis([34.2 34.75]);

subplot(1,2,1)
aaaa=rdmds([exppath,'/results/THETA' fname Ntime]);
aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(yy/1000,-zz,aaa1','LineColor','w');
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(['T (degC) at t = ' num2str(tt) ' ' TIME]);colormap('default');colorbar;set(gca,'fontsize',13);
 caxis([-1.8 0.9]);

PLOT = gcf;
PLOT.Position = [561 553 857 290];

saveas(gcf,[exppath '/' imgname '/TS_' TIME num2str(tt) '.png']);


figure(2)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/UVEL' fname Ntime]);
bathy = squeeze(aaaa(1,:,:));
idx_bathy = (bathy==0);
aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(aaa1','LineColor','w')
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(['u (m/s) at t = ' num2str(tt) ' ' TIME]);
colormap redblue;colorbar;set(gca,'fontsize',13);
% caxis([-0.4 0.4]);
caxis([-0.4 0.4]);

subplot(1,2,2)
aaaa=rdmds([exppath,'/results/VVEL' fname Ntime]);
aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(['v (m/s) at t = ' num2str(tt) ' ' TIME]);
colormap redblue;colorbar;set(gca,'fontsize',13);
% caxis([-0.5 0.5]);
caxis([-0.3 0.3]);

PLOT = gcf;
PLOT.Position = [561 553 857 290];
saveas(gcf,[exppath '/' imgname '/uv_' TIME num2str(tt) '.png']);

figure(10)
aaaa=rdmds([exppath,'/results/WVEL' fname Ntime]);
aaa1=squeeze(mean(aaaa,1));aaa1(idx_bathy) = NaN;
FIG = pcolor(yy/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(['w (m/s) at t = ' num2str(tt) ' ' TIME]);
colormap redblue;colorbar;set(gca,'fontsize',13);
caxis([-0.01 0.01]);

PLOT = gcf;
PLOT.Position = [240 554 377 290];
saveas(gcf,[exppath '/' imgname '/WVEL_' TIME num2str(tt) '.png']);



figure(8)
aaaa=rdmds([exppath,'/results/THETA' fname Ntime]);
aaa1=squeeze(aaaa(:,:,1));
pcolor(xx/1000,yy/1000,aaa1');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['SST (degC) at t = ' num2str(tt) ' ' TIME]);
colormap('jetvar');colorbar;set(gca,'fontsize',13);
% caxis([-1.8 -0.3]);
% caxis([-2.1 0.9]);
caxis([-1.9 -1.8]);

PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SST_' TIME num2str(tt) '.png']);


figure(4)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIuice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['U_{ice} (m/s) at t = ' num2str(tt) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.5 0.5]);
% caxis([-0.06 0.06]);


subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIvice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['V_{ice} (m/s) at t = ' num2str(tt) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.15 0.15]);


PLOT = gcf;
PLOT.Position = [538 318 660 532];
saveas(gcf,[exppath '/' imgname '/UVice_' TIME num2str(tt) '.png']);


figure(5)
aaaa=rdmds([exppath,'/results/SIarea' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Sea ice concentration at t = ' num2str(tt) ' ' TIME]);
colormap('gray');colorbar;
set(gca,'fontsize',13);
caxis([0 1]);

PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SIarea_' TIME num2str(tt) '.png']);

figure(11)
aaaa=rdmds([exppath,'/results/SIheff' fname Ntime]);
mean(mean(aaaa))
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Sea ice thickness (m) at t = ' num2str(tt) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([0 2]);

PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SIheff_' TIME num2str(tt) '.png']);


end



