%%%
%%% plotMomBudget_xint.m
%%%
%%% Plots the time-mean momentum budget terms.
%%%
clear all;

basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/experiments/products;



expdir = '/data/MITgcm_ASF-csi/experiments/';
outdir = '/data/MITgcm_ASF-csi/experiments/products';
expnames = {   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5' 
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'   
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25'
  'fresh02-bumps4depth600-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  'fresh02-bumps8depth300-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'  
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2' 
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'... 
};


%%% model blew up
%   'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...

%%% no oceTAUX, oceTAUY
%   'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...

%%% integrated to 10 years
%   'fresh02-ice4_Hi1.8Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
%   'fresh02-ice5_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
%   'fresh02-td5_atide0.125Umax1.75Ua-6Va6Hi1Ai1_2kmNr30Ws25'


Nexp = length(expnames);
fontsize = 15;

imgname = 'figures_momentum_zint'


% for n=3:Nexp
for n=1:1

expname = expnames{n};
calcMomBudget_xint;

%%% Plot terms in momentum budget
figure(n)
l1 = plot(yy/1000,windStress_xint/1e4,'LineWidth',1.5);
hold on;
l8 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l2 = plot(yy/1000,IceOceanDrag/1e4,'LineWidth',1.5);
l3 = plot(yy/1000,formStress_zint/1e4,'LineWidth',1.5);
l4 = plot(yy/1000,Um_Diss_xzint/1e4,'LineWidth',1.5);
l5 = plot(yy/1000,advConv_mean/1e4,'LineWidth',1.5);
l6 = plot(yy/1000,advConv_eddy/1e4,'LineWidth',1.5);
l7 = plot(yy/1000,coriolisfv/1e4,'LineWidth',1.5);
l9 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',1.5,'color',[0.5 0.5 0.5]);
axis ij
hold off;
ylabel('Zonal force balance (10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance (km)', 'FontSize', fontsize,'interpreter','latex');
% title(titlenames{n},'FontSize',fontsize,'interpreter','latex');
legend([l1 l2 l3 l4 l5 l6 l7 l8],'Wind stress','Ice-ocean drag','Topog. form stress','Bottom friction',...
    'Mean advection','Eddy advection','Coriolis term','Residual term');
%         set(LegendStress,'Position',[0.3302,0.4177,0.1784,0.1034]);
xlim([20,430])
% ylim([-10 10])
set(gca,'fontsize',15);
set(gcf,'position',[225 321 759 617]);

% saveas(gcf,[outdir '/' imgname '/' expname '_MomentumZint.png']);
end