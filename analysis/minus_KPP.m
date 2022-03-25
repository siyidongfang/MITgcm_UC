clear all;close all;



plotname1 = 'KPPviscA';  
plotname2 = 'KPPdiffS';  
plotname3 = 'KPPdiffT';
plotname4 = 'KPPghatK';


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/analysis_201c/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/';
addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;

expname = 'ardbeg_kpp_2ob_tide0.03'
loadexp
expname_notide = 'ardbeg_kpp_2ob_notide'

load('/Users/csi/Documents/MITgcm_ASF-csi/newexp_201c/ardbeg_kpp_2ob_notide/setParams.mat')

xx = xx + abs(xx(1));
dumpFreq = abs(diag_frequency(6)); 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');



for m = size(dumpIters,2):size(dumpIters,2)   

% Ntime = navg(m*10-9:m*10);
Ntime = '0000319418';

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
hold on;
plot(xx/1000,h,'w')
hold off;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('KPP vertical eddy viscosity coefficient (m^2/s)');colormap('redblue');set(gca,'fontsize',13);
xlim([15 50]);
ylim([0 1400]);
colorbar;
CAXIS = max(max(abs(aaa1)));
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];

saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/' plotname1 'minus_day' num2str(m/2) '.png']);



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
title('Vertical diffusion coefficient for heat and salt (m^2/s)');colormap('redblue');set(gca,'fontsize',13);
xlim([15 50]);
ylim([0 1400]);
colorbar; 
CAXIS = max(max(abs(aaa1)));
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/' plotname3 'minus_day' num2str(m/2) '.png']);


figure(4)
aaaa=rdmds([expdir expname '/results/' plotname4 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname4 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);
aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title('Nonlocal transport coefficient (s/m^2 )');colormap('redblue');set(gca,'fontsize',13);
xlim([15 50]);
ylim([0 1400]);
colorbar; 
CAXIS = max(max(abs(aaa1)));
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_paper/' plotname4 'minus_day' num2str(m/2) '.png']);


end



