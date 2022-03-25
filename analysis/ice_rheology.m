close all;clear all;


addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;

basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
expname = 'testrb2_tau1d_5yr_3Drbcs_lw295_2ob_wind_ice_tide_umax2'
loadexp;

OUTPUT = 'avg'

switch (OUTPUT)
    case 'avg'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'mon';
        fname = '.';
    case 'inst'
        imgname = 'img_inst';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = '_5days';
        fname = '_inst.';
end

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

xx = xx + abs(xx(1));


for m = 1:size(dumpIters,2)
% for m = 20:20
    
Ntime = navg(m*10-9:m*10);
% 
% figure(1)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIuice' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['U_{ice} (m/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;set(gca,'fontsize',13);
% caxis([-0.6 0.6]/60);
% % caxis([-0.1 0.1]);
% 
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIvice' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['V_{ice} (m/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;set(gca,'fontsize',13);
% caxis([-0.3 0.3]/600);
% % caxis([-0.005 0.005]);
% 
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/UVice_' TIME num2str(m) '.png']);
% 
% 
% figure(2)
% aaaa=rdmds([exppath,'/results/SIarea' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Sea ice concentration at t = ' num2str(m) ' ' TIME]);
% colormap('gray');colorbar;
% set(gca,'fontsize',13);
% caxis([0 1]);
% 
% PLOT = gcf;
% PLOT.Position = [240 554 377 290];
% saveas(gcf,[exppath '/' imgname '/SIarea_' TIME num2str(m) '.png']);
% 
% figure(3)
% aaaa=rdmds([exppath,'/results/SIheff' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Sea ice thickness (m) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% caxis([0 8]);
% 
% PLOT = gcf;
% PLOT.Position = [240 554 377 290];
% saveas(gcf,[exppath '/' imgname '/SIheff_' TIME num2str(m) '.png']);


figure(4)
aaaa=rdmds([exppath,'/results/SItices' fname Ntime])-273.15;
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Surface T over Sea Ice at t = ' num2str(m) ' ' TIME]);
colormap('jetvar');colorbar;
set(gca,'fontsize',13);
caxis([-3 -1]);

mean(mean(aaaa(:,2:end)))


PLOT = gcf;
PLOT.Position = [240 554 377 290];
saveas(gcf,[exppath '/' imgname '/SItices_' TIME num2str(m) '.png']);

% 
% figure(5)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIzeta' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['SIzeta (kg/s) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.6 0.6]);
% 
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIeta' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['SIeta (kg/s) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.005 0.005]);
% 
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/SIzeta_eta_' TIME num2str(m) '.png']);
% 
% 
% 
% figure(6)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIsig1' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['SIsig1 at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.6 0.6]);
% 
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIsig2' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['SIsig2 at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.3 0.3]);
% 
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/SIsig1_sig2_' TIME num2str(m) '.png']);
% 
% 
% 
% 
% figure(7)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIshear' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Ice shear deformation rate (1/s) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.6 0.6]);
% 
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIdelta' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Ice Delta deformation rate (1/s) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([-0.3 0.3]);
% 
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/SIshear_delta_' TIME num2str(m) '.png']);
% 
% 
% 
% figure(8)
% aaaa=rdmds([exppath,'/results/SIpress' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['SEAICE strength (N/m) at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;set(gca,'fontsize',13);
% % caxis([0 8]);
% 
% PLOT = gcf;
% PLOT.Position = [240 554 377 290];
% saveas(gcf,[exppath '/' imgname '/SIpress_' TIME num2str(m) '.png']);
% 
% 


end



