close all;clear all;
%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
% expdir = '/Volumes/LaCie/'
expname = 'testice9_2wind_positiveNSviceNuice_Suice0_lw330_Taminus10_tide'
loadexp;

OUTPUT = 'avg'

switch (OUTPUT)
    case 'avg'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(1)); 
        TIME = 'mon';
        fname = '.';
    case 'inst'
        imgname = 'img';
        dumpFreq = abs(diag_frequency(end)); 
        TIME = '_5d';
        fname = '_inst.';
end

nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

xx = xx + abs(xx(1));


% for m =1:120:size(dumpIters,2)
for m =1:12:size(dumpIters,2)
Ntime = navg(m*10-9:m*10);

figure(1)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIdHbATC' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['H_i rate by air-ice flux (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-4 4]/10^8);
subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIdHbOCN' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['H_i rate by ocean-ice flux (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-4 4]/10^7);
PLOT = gcf;
PLOT.Position = [561 553 857 290];
saveas(gcf,[exppath '/' imgname '/SIdHbATC-OCN_' TIME num2str(m) '.png']);

figure(2)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIdAbATC' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['A_i rate by air-ice flux (1/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-2 2]/10^7);
subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIdAbOCN' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['A_i rate by ocean-ice flux (1/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-2 2]/10^7);
PLOT = gcf;
PLOT.Position = [561 553 857 290];
saveas(gcf,[exppath '/' imgname '/SIdSbATC-OCN_' TIME num2str(m) '.png']);

% figure(3)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIdSbATC' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Snow rate by air-ice flux (m/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',13);
% % caxis([-6 -1.5]);
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIdSbOCN' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Snow rate by ocean-ice flux (m/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',13);
% % caxis([-6 -1.5]);
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/SIdSbATC-OCN_' TIME num2str(m) '.png']);

end



