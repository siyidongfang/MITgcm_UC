clear all; close all;
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

figure(1)
aaaa=rdmds([expdir expname '/results/THETA.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/THETA.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;

bathy = squeeze(aaaa(:,:,:));
idx_bathy = (bathy==0);

aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(xx/1000,-zz,aaa1','LineColor','w')
% hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('T_t_i_d_e - T_n_o_\__t_i_d_e (\circC)');colormap('redblue');set(gca,'fontsize',13);
colorbar;% colorbar('southoutside');
caxis([-0.05 0.05]);
xlim([25 80]);
ylim([300 inf]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];

saveas(gcf,[fullfile(expdir,expname_notide) '/img_TSminus/Ttideminusnotide_day' num2str(m/2+1) '.png']);




figure(2)

aaaa=rdmds([expdir expname '/results/SALT.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/SALT.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;

aaa1=squeeze(aaaa_minus);aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
% hold on;
% contour(xx/1000,-zz,aaa1','LineColor','w')
% hold off;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('S_t_i_d_e - S_n_o_\__t_i_d_e (psu)');colormap('redblue');set(gca,'fontsize',13);
colorbar;% colorbar('southoutside');
caxis([-0.004 0.004]);
xlim([25 80]);
ylim([300 inf]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_TSminus/Stideminusnotide_day' num2str(m/2+1) '.png']);


end
