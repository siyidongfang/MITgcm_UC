clear all;close all;


%  
% plotname1 = 'ADVr_TH';  
% plotname2 = 'ADVx_TH';  
% plotname3 = 'ADVy_TH';
% plotname4 = 'DFrE_TH';
% plotname5 = 'DFxE_TH';
% plotname6 = 'DFyE_TH';
% plotname7 = 'DFrI_TH';

% 
plotname1 = 'ADVr_SLT';  
plotname2 = 'ADVx_SLT';  
plotname3 = 'ADVy_SLT';
% plotname4 = 'DFrE_SLT';
% plotname5 = 'DFxE_SLT';
% plotname6 = 'DFyE_SLT';
% plotname7 = 'DFrI_SLT';


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/analysis_201c/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/';
addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;


expname = 'ardbeg_nonhyd_2ob_tide0.03'
loadexp
expname_notide = 'ardbeg_nonhyd_2ob_notide'


xx = xx + abs(xx(1));
dumpFreq = abs(diag_frequency(6)); 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');


% for m = size(dumpIters,2):size(dumpIters,2)   
for m = 110:110
Ntime = navg(m*10-9:m*10);
% Ntime = '0000319418';

aaaa=rdmds([expdir expname '/results/SALT.' Ntime]);
bathy = squeeze(aaaa(:,:,:));
idx_bathy = (bathy==0);


figure(1)
aaaa=rdmds([expdir expname '/results/' plotname1 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname1 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);
aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Vertical Advective Flux of Salinity (psu\cdotm^3/s)');colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar;
CAXIS = max(max(abs(aaa1)));
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_TSminus/' plotname1 '_minusday' num2str(m/2) '.png']);


figure(2)
aaaa=rdmds([expdir expname '/results/' plotname2 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname2 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);
aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Across-shelf Advective Flux of Salinity (psu\cdotm^3/s)');colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = max(max(abs(aaa1)))/1.8;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_TSminus/' plotname2 '_minusday' num2str(m/2) '.png']);



figure(3)
aaaa=rdmds([expdir expname '/results/' plotname3 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname3 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);
aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Along-shelf Advective Flux of Salinity (psu\cdotm^3/s)');colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = 4500;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_TSminus/' plotname3 '_minusday' num2str(m/2) '.png']);


% figure(4)
% aaaa=rdmds([expdir expname '/results/' plotname4 '.' Ntime]);
% aaaa_notide=rdmds([expdir expname_notide '/results/' plotname4 '.' Ntime]);
% aaaa_minus = aaaa - aaaa_notide;
% aaa1=squeeze(aaaa_minus);
% aaa1(idx_bathy) = NaN;
% FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% xlabel('Offshore distance (km)', 'FontSize', 15);
% ylabel('Depth (m)','FontSize', 15);
% title(plotname4);colormap('redblue');set(gca,'fontsize',13);
% xlim([25 80]);
% ylim([300 inf]);
% colorbar; 
% CAXIS = max(max(abs(aaa1)))/5;
% caxis([-CAXIS CAXIS]);
% PLOT = gcf;
% PLOT.Position = [561 553 405 290];
% saveas(gcf,[fullfile(expdir,expname_notide) '/img_TS_minus/' plotname4 '_minusday' num2str(m/2) '.png']);
% 
% 
% figure(5)
% aaaa=rdmds([expdir expname '/results/' plotname5 '.' Ntime]);
% aaaa_notide=rdmds([expdir expname_notide '/results/' plotname5 '.' Ntime]);
% aaaa_minus = aaaa - aaaa_notide;
% aaa1=squeeze(aaaa_minus);
% aaa1(idx_bathy) = NaN;
% FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% xlabel('Offshore distance (km)', 'FontSize', 15);
% ylabel('Depth (m)','FontSize', 15);
% title(plotname5);colormap('redblue');set(gca,'fontsize',13);
% xlim([25 80]);
% ylim([300 inf]);
% colorbar; 
% CAXIS = max(max(abs(aaa1)))/5;
% caxis([-CAXIS CAXIS]);
% PLOT = gcf;
% PLOT.Position = [561 553 405 290];
% saveas(gcf,[fullfile(expdir,expname_notide) '/img_TS_minus/' plotname5 '_minusday' num2str(m/2) '.png']);
% 
% figure(6)
% aaaa=rdmds([expdir expname '/results/' plotname6 '.' Ntime]);
% aaaa_notide=rdmds([expdir expname_notide '/results/' plotname6 '.' Ntime]);
% aaaa_minus = aaaa - aaaa_notide;
% aaa1=squeeze(aaaa_minus);
% aaa1(idx_bathy) = NaN;
% FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% xlabel('Offshore distance (km)', 'FontSize', 15);
% ylabel('Depth (m)','FontSize', 15);
% title(plotname6);colormap('redblue');set(gca,'fontsize',13);
% xlim([25 80]);
% ylim([300 inf]);
% colorbar; 
% CAXIS = max(max(abs(aaa1)))/5;
% caxis([-CAXIS CAXIS]);
% PLOT = gcf;
% PLOT.Position = [561 553 405 290];
% saveas(gcf,[fullfile(expdir,expname_notide) '/img_TS_minus/' plotname6 '_minusday' num2str(m/2) '.png']);
% 
% figure(7)
% aaaa=rdmds([expdir expname '/results/' plotname7 '.' Ntime]);
% aaaa_notide=rdmds([expdir expname_notide '/results/' plotname7 '.' Ntime]);
% aaaa_minus = aaaa - aaaa_notide;
% aaa1=squeeze(aaaa_minus);
% aaa1(idx_bathy) = NaN;
% FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
% set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% xlabel('Offshore distance (km)', 'FontSize', 15);
% ylabel('Depth (m)','FontSize', 15);
% title(plotname7);colormap('redblue');set(gca,'fontsize',13);
% xlim([25 80]);
% ylim([300 inf]);
% colorbar; 
% CAXIS = max(max(abs(aaa1)))/5;
% caxis([-CAXIS CAXIS]);
% PLOT = gcf;
% PLOT.Position = [561 553 405 290];
% saveas(gcf,[fullfile(expdir,expname_notide) '/img_TS_minus/' plotname7 '_minusday' num2str(m/2) '.png']);
% 



end



