clear all;close all;
 
 
basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/analysis_201c/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/';
addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;


expname = 'ardbeg_kpp_2ob_tide0.03'
loadexp

expname_notide = 'ardbeg_kpp_2ob_notide'


xx = xx + abs(xx(1));

dumpFreq = abs(diag_frequency(6)); 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');


for m =size(dumpIters,2):size(dumpIters,2)   

Ntime = navg(m*10-9:m*10);
figure(1)

aaaa=rdmds([expdir expname '/results/UBotDrag.' Ntime]);
bathy = squeeze(aaaa(:,:,:));
idx_bathy = (bathy==0);
aaaa_notide=rdmds([expdir expname_notide '/results/UBotDrag.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;

aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(xx/1000,-zz,aaa1','LineColor','w')
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('UBotDrag');colormap('redblue');set(gca,'fontsize',13);
colorbar('southoutside');
% caxis([-0.4 0.4]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];

saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/UBotDrag_diff_day' num2str(m/2) '.png']);


figure(2)
aaaa=rdmds([expdir expname '/results/Um_Advec.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/Um_Advec.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(xx/1000,-zz,aaa1','LineColor','w')
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Um_Advec');colormap('redblue');set(gca,'fontsize',13);
colorbar('southoutside');
% caxis([-0.055 0.055]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/Um_Advec_diff_day' num2str(m/2) '.png']);


figure(3)
aaaa=rdmds([expdir expname '/results/Um_Advec.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/Um_Advec.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(xx/1000,-zz,aaa1','LineColor','w')
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Um_Advec');colormap('redblue');set(gca,'fontsize',13);
colorbar('southoutside');
% caxis([-0.055 0.055]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/Um_Advec_diff_day' num2str(m/2) '.png']);



figure(4)
aaaa=rdmds([expdir expname '/results/Um_dPHdx.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/Um_dPHdx.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
hold on;
contour(xx/1000,-zz,aaa1','LineColor','w')
hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Um_dPHdx');colormap('redblue');set(gca,'fontsize',13);
colorbar('southoutside');
% caxis([-0.055 0.055]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/Um_dPHdx_diff_day' num2str(m/2) '.png']);


end



