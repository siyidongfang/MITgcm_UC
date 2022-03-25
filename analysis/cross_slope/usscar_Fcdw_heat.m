clear;
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
% prodir = '/Volumes/si/MITgcm_ASF-csi/products-lores/';
prodir = '/Users/csi/MITgcm_ASF-csi/products-lores/'
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_HeatSaltFlux/'

load([prodir 'Flux_zInteg_lores.mat'],'VVELTH_zint_xavg','yy','EXPNAME');
EXPNAME_heatflux = EXPNAME;
clear EXPNAME;
load([prodir 'calcFcdw_MixingLength_-0.5degC.mat'],'Fcdw_simulation','EXPNAME');
EXPNAME_Fcdw = EXPNAME;
clear EXPNAME;

rho_o = 1037;
Lx = 400000;
cp_o = 3850;
dy = 2000;
shelfregion = 25*1000:dy:99*1000;
shelfidx = 13:50;

heatflux_shelf = cp_o*rho_o*Lx*mean(VVELTH_zint_xavg(:,shelfidx),2)'/10^12;
fontsize=13;


%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 900 420]);
set(gcf,'Color','w');

%%% Plotting options
subplotsize = [0.4 0.84];
%%% Make the plot
clf;

ax1 = subplot('position',[0.08 0.1 subplotsize]);
annotation('textbox',[0.07 0.95 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None')
scatter (-heatflux_shelf,-Fcdw_simulation);
title('F$_\mathrm{CDW}$ v.s. heat transport','FontSize',fontsize+5,'interpreter','latex')
ylabel('Onshore CDW flux (Sv), averaged over the slope','FontSize',fontsize+2,'interpreter','latex')
xlabel('Onshore heat transport (10$^{12}$ W), averaged over the shelf','FontSize',fontsize+2,'interpreter','latex');
corr(-heatflux_shelf',-Fcdw_simulation')
box on;grid on;

load([prodir 'calcFcdw_MixingLength_-0.5degC.mat'])
% Fcdw_simulation(Fcdw_simulation>0)=0;
MAX = max(-Fcdw_simulation);

ax2 = subplot('position',[0.57 0.1 subplotsize]);
annotation('textbox',[0.56 0.95 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None')
scatter(-Fcdw_simulation,Fcdw_theory_s);
% hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
title('Mixing length = 2*slope width','FontSize', fontsize+5,'interpreter','latex');
ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');
box on;grid on;


% print('-dpng','-r200', 'place_holder.png');

