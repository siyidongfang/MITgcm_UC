close all;clear all;
%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
% expdir = '/Volumes/LaCie/'
expname = 'barotr4_2ob_nobumps_smalltide_2wind_LH30_Taminus10'
loadexp;

useSEAICE = true;

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

% for m = 73:73
for m = size(dumpIters,2):size(dumpIters,2)
% for m =37:12:size(dumpIters,2)
Ntime = navg(m*10-9:m*10);

figure(1)
aaaa=rdmds([exppath,'/results/THETA' fname Ntime]);
aaa1=squeeze(aaaa(:,:,1));
pcolor(xx/1000,yy/1000,aaa1');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['T (degC) at t = ' num2str(m) ' ' TIME]);
colormap('default');colorbar;set(gca,'fontsize',13);
caxis([-1.9 -0.5]);
if(useSEAICE)
    caxis([-1.92 -1.88]);
end
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/T_' TIME num2str(m) '.png']);

figure(2)
aaaa=rdmds([exppath,'/results/SALT' fname Ntime]);
aaa1=squeeze(aaaa(:,:,1));
pcolor(xx/1000,yy/1000,aaa1');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['S (psu) at t = ' num2str(m) ' ' TIME]);
colormap('default');colorbar;set(gca,'fontsize',13);
caxis([34.6 34.8]);
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/S_' TIME num2str(m) '.png']);


figure(3)
aaaa=rdmds([exppath,'/results/UVEL' fname Ntime]);
aaa1=squeeze(aaaa(:,:,1));
pcolor(xx/1000,yy/1000,aaa1');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['u (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.1 0.1]);
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/U_' TIME num2str(m) '.png']);

figure(4)
aaaa=rdmds([exppath,'/results/VVEL' fname Ntime]);
aaa1=squeeze(aaaa(:,:,1));
pcolor(xx/1000,yy/1000,aaa1');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['v (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.1 0.1]/500);
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/V_' TIME num2str(m) '.png']);



if(useSEAICE)
    
figure(7)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIuice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['U_{ice} (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.3 0.3]);
% caxis([-0.06 0.06]);


subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIvice' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['V_{ice} (m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([-0.1 0.1]);
PLOT = gcf;
PLOT.Position = [538 318 660 532];
saveas(gcf,[exppath '/' imgname '/UVice_' TIME num2str(m) '.png']);


figure(8)
aaaa=rdmds([exppath,'/results/SIarea' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Sea ice concentration at t = ' num2str(m) ' ' TIME]);
colormap('gray');colorbar;
set(gca,'fontsize',13);
caxis([0 1]);

PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SIarea_' TIME num2str(m) '.png']);

figure(9)
aaaa=rdmds([exppath,'/results/SIheff' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Sea ice thickness (m) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;set(gca,'fontsize',13);
caxis([0.5 1.5]);
idxTi = aaaa<=0;
aaaa(idxTi) = NaN;
meanHEFF = nanmean(nanmean(aaaa))
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SIheff_' TIME num2str(m) '.png']);


figure(10)
aaaa=rdmds([exppath,'/results/SItices' fname Ntime])-273.15;
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Surface T over Sea Ice at t = ' num2str(m) ' ' TIME]);
colormap('jetvar');colorbar;
set(gca,'fontsize',13);
caxis([-3 -1]);
idxTi = aaaa<-100;
aaaa(idxTi) = NaN;
meanSItices = nanmean(nanmean(aaaa(:,2:end)))
PLOT = gcf;
PLOT.Position = [240 386 308 531];
saveas(gcf,[exppath '/' imgname '/SItices_' TIME num2str(m) '.png']);



figure(11)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIdHbATC' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['dh_i/dt (air, m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-1.5 1.5]/10^8);
subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIdHbOCN' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['dh_i/dt (ocean, m/s) at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',13);
caxis([-2 2]/10^7);
PLOT = gcf;
PLOT.Position = [538 318 660 532];
saveas(gcf,[exppath '/' imgname '/SIdHbATC-OCN_' TIME num2str(m) '.png']);


% figure(12)
% subplot(1,2,1)
% aaaa=rdmds([exppath,'/results/SIdAbATC' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['A_i rate by air-ice flux (1/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',13);
% caxis([-2 2]/10^7);
% subplot(1,2,2)
% aaaa=rdmds([exppath,'/results/SIdAbOCN' fname Ntime]);
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['A_i rate by ocean-ice flux (1/s) at t = ' num2str(m) ' ' TIME]);
% colormap('redblue');colorbar;
% set(gca,'fontsize',13);
% caxis([-2 2]/10^7);
% PLOT = gcf;
% PLOT.Position = [561 553 857 290];
% saveas(gcf,[exppath '/' imgname '/SIdSbATC-OCN_' TIME num2str(m) '.png']);

figure(13)
subplot(1,2,1)
aaaa=rdmds([exppath,'/results/SIqnet' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Ocean surface heatflux at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',10);
caxis([-30 30]);
subplot(1,2,2)
aaaa=rdmds([exppath,'/results/SIempmr' fname Ntime]);
pcolor(xx/1000,yy/1000,aaaa');shading interp;
xlabel('Alongshore distance (km)', 'FontSize', 15);
ylabel('Offshore distance (km)','FontSize', 15);
title(['Ocean surface freshwater flux at t = ' num2str(m) ' ' TIME]);
colormap('redblue');colorbar;
set(gca,'fontsize',10);
caxis([-6 6]/10^5);
PLOT = gcf;
PLOT.Position = [538 318 660 532];
saveas(gcf,[exppath '/' imgname '/SIqnet_empmr_' TIME num2str(m) '.png']);


% figure(14)
% aaaa=rdmds([exppath,'/results/SIsnPrcp' fname Ntime])-273.15;
% pcolor(xx/1000,yy/1000,aaaa');shading interp;
% xlabel('Alongshore distance (km)', 'FontSize', 15);
% ylabel('Offshore distance (km)','FontSize', 15);
% title(['Snow precip. at t = ' num2str(m) ' ' TIME]);
% colormap('jetvar');colorbar;
% set(gca,'fontsize',13);
% % caxis([-1.5 -0.3]);
% PLOT = gcf;
% PLOT.Position = [240 386 308 531];
% saveas(gcf,[exppath '/' imgname '/SIsnPrcp_' TIME num2str(m) '.png']);




end

end



