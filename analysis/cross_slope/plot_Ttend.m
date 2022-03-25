%%% Calculate heat budget, following Abhisek Chakraborty & Jean-Michel Campin
%%% Reference: http://wwwcvs.mitgcm.org/viewvc/MITgcm/MITgcm/doc/Heat_Salt_Budget_MITgcm.pdf?revision=1.1&view=co


clear;

%%% Set path
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/newexp/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/'
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
% outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_check_heatbudget/'


%%% Load data

%     'ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'   %10-15yr
%     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25'    %10-15yr
%     'ssurf33_0dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25'      %10-15yr
%     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25' %10-15yr
%     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125'  %10-15yr
%     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'    %10-15yr
%     'ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' %15-20yr
%     'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' %15-20yr
%     'ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' %10-15yr
%     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' %10-15yr
%     'ssurf34.12_3dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25' %10-15yr


expname ='ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' 

loadexp;

load([prodir expname '_tavg_5yrs.mat'],'TOTTTEND');


[ZZ,YY] = meshgrid(zz,yy);
fontsize=15;


%%% Diagnosed tendency of Potential Temperature
Ttend =  TOTTTEND/86400; 
Ttend(Ttend==0)=NaN;

figure(2)
clf;
% Ttend(Ttend==0)=NaN;
Ttend_xavg = squeeze(nanmean(Ttend))*86400*365;

pcolor(yy/1000,-zz/1000,Ttend_xavg');shading interp;axis ij;
% colormap(redblue);
colormap(cmocean('balance',100));
colorbar;
caxis([-0.1 0.1]);
xlim([0 450])
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
set(gca,'FontSize',fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('Tendency of Potential Temperature ($^\circ$C/year)','FontSize', fontsize+5,'interpreter','latex');
[C,h]=contour(YY/1000,-ZZ/1000,Ttend_xavg,[0 0],'EdgeColor','w','LineWidth',2);
hold off;
% text(30,2.8,fname,'FontSize', fontsize+4,'interpreter','latex')
set(gcf,'OuterPosition',[91 155 599 500])
% print('-dpng','-r150',[outdir expname '_Ttend.png']);


