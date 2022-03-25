%%%
%%% plotIceOceanStress.m
%%%
%%% Script to plot the ice-ocean stress.
%%%
close all;clear all;

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab; 
basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
% expdir = '/Volumes/LaCie/'
expname = 'ly0_2kmNr30Nly36_4bumps_atide0.05_ua-5va5_Hi1Ai1Sui0Svi0.1_Ta-10lwdown320Tis-0.65'
%   expname = 'ly01_2kmNr30Nly36_Hshelf500bumps4_atide0.05_ua-5va5_Hi1Ai1Sui0Svi0.1_Ta-10lwdown320Tis-0.65'


useLAYERS = false;
useSEAICE = true;

loadexp;

load([exppath '/' expname,'_ice-ocn-stress.mat']);

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

if (Lx == 400000)
    position_1 = [148   273   345   300];
    position_2 = [563   282   820   306];
    position_topview = [401   259   537   546];
else if (Lx == 200000)
     position_1 = [240   274   308   531];
     position_2 = [538   273   660   532];
     position_topview = [46   152   322   595];
    end
end

fignum = 1;

for m = 106:106
% for m = size(dumpIters,2):size(dumpIters,2)
% for m =99:size(dumpIters,2)
Ntime = navg(m*10-9:m*10);

    figure(fignum);
    fignum = fignum + 1;
    clf;
    % Monthly mean ice-ocean stress
    svx = 13; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
        squeeze(tao_iox(m,1:svx:end,1:svy:end))',squeeze(tao_ioy(m,1:svx:end,1:svy:end))');
    set(curr,'LineWidth',0.75,'MaxHeadSize',.1,'Color','k'); % 'AutoScaleFactor',0.8   
    hold on;
    depth=rdmds([exppath,'/results/Depth']);
    [c,h]=contour(xx'/1000,yy'/1000,depth',13);
     h.LevelList=round(h.LevelList,0);  %rounds levels to 3rd decimal place
     clabel(c,h,'FontSize',7);
    hold off;
%     currlegend = legend(curr,'1 N/m^2','LineWidth',0.75,'Location',[0.6776 0.0348 0.2421 0.0348]);
    xlim([0 inf]);
    xlabel('Alongshore distance (km)', 'FontSize', 15);
    ylabel('Offshore distance (km)','FontSize', 15);
    title(['Ice-ocean stress, t = ' num2str(m) ' ' TIME],'FontSize',13);
    set(gca,'fontsize',13);
    PLOT = gcf;
    PLOT.Position = position_topview;
    saveas(gcf,[exppath '/' imgname '/TAU_io_' TIME num2str(m) '.png']);
 
end









