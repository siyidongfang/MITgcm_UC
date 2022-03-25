clear all;close all;

 
plotname1 = 'Um_Diss';  % m/s^2|U momentum tendency from Dissipation
plotname2 = 'Vm_Diss';  % m/s^2|V momentum tendency from Dissipation
plotname3 = 'momKE';
plotname4 = 'momHDiv';
plotname5 = 'KPPviscA';
plotname6 = 'KPPhbl';
plotname7 = 'MXLDEPTH';  % m|Mixed-Layer Depth (>0)



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
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(plotname1);colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar;
CAXIS = max(max(abs(aaa1)))/10;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname1 '_minusday' num2str(m/2) '.png']);


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
title(plotname2);colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = max(max(abs(aaa1)))/20;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname2 '_minusday' num2str(m/2) '.png']);



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
title(plotname3);colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = max(max(abs(aaa1)))/5;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname3 '_minusday' num2str(m/2) '.png']);


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
title(plotname4);colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = max(max(abs(aaa1)))/5;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname4 '_minusday' num2str(m/2) '.png']);


figure(5)
aaaa=rdmds([expdir expname '/results/' plotname5 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname5 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
aaa1=squeeze(aaaa_minus);
aaa1(idx_bathy) = NaN;
FIG = pcolor(xx/1000,-zz,aaa1');shading interp;axis ij;
set(FIG,'alphadata',~isnan(aaa1'));set(gca,'color',[0.6 0.6 0.6]);
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel('Depth (m)','FontSize', 15);
title(plotname5);colormap('redblue');set(gca,'fontsize',13);
xlim([25 80]);
ylim([300 inf]);
colorbar; 
CAXIS = max(max(abs(aaa1)))/5;
caxis([-CAXIS CAXIS]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname5 '_minusday' num2str(m/2) '.png']);


figure(6)
aaaa=rdmds([expdir expname '/results/' plotname6 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname6 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
plot(xx/1000,aaaa_minus');shading interp;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel(plotname6,'FontSize', 15);
title(plotname6);set(gca,'fontsize',13);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname6 '_day' num2str(m/2) '.png']);


figure(7)
aaaa=rdmds([expdir expname '/results/' plotname7 '.' Ntime]);
aaaa_notide=rdmds([expdir expname_notide '/results/' plotname7 '.' Ntime]);
aaaa_minus = aaaa - aaaa_notide;
plot(xx/1000,aaaa_minus');shading interp;
xlabel('Offshore distance (km)', 'FontSize', 15);
ylabel(plotname7,'FontSize', 15);
title(plotname7);set(gca,'fontsize',13);
% xlim([45 Inf]);
PLOT = gcf;
PLOT.Position = [561 553 405 290];
saveas(gcf,[fullfile(expdir,expname_notide) '/img_energy_minus/' plotname7 '_day' num2str(m/2) '.png']);

end



