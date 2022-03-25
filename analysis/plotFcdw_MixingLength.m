clear;
prodir = '/Users/csi/MITgcm_ASF-csi/products-lores/';
% close all;
load([prodir 'calcFcdw_MixingLength_-0.5degC_totalEKE.mat'])
fontsize = 15;
size_marker = 100;

figureloc = '../../MITgcm_ASF-csi/cross_slope_exchange/figures_mixinglength/'


MAX = max(-Fcdw_simulation);

% figure(1)
% subplot(1,2,1)
% scatter(Fcdw_theory_s,Fcdw_theory_Rh);
% hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
% ylabel('Predicted $F_{CDW}$, Rhines scale (Sv)','FontSize', fontsize+2,'interpreter','latex');
% xlabel('Predicted $F_{CDW}$, slope width (Sv)','FontSize', fontsize+2,'interpreter','latex');
% subplot(1,2,2)
% scatter(Fcdw_test_s,Fcdw_test_Rh);
% hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
% ylabel('Predicted $F_{CDW}$, Rhines scale (Sv)','FontSize', fontsize+2,'interpreter','latex');
% xlabel('Predicted $F_{CDW}$, slope width (Sv)','FontSize', fontsize+2,'interpreter','latex');
% print('-dpng','-r150',[figureloc 'ls_lRh_-0.5degC_totalEKE.png']);
% % print('-dpng','-r150',[figureloc 'ls_lRh_-0.5degC_removeTidalEKE.png']);

Fcdw_simulation(Fcdw_simulation>0)=0;

figure(3)
subplot(2,2,1)
scatter(-Fcdw_simulation,Fcdw_theory_Rh)
hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
title('Mixing length = Rhines scale','FontSize', fontsize+4,'interpreter','latex');
ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');


subplot(2,2,2)
scatter(-Fcdw_simulation,Fcdw_test_Rh)
hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
title('Mixing length = Rhines scale','FontSize', fontsize+4,'interpreter','latex');
ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');


subplot(2,2,3)
scatter(-Fcdw_simulation,Fcdw_theory_s)
hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
title('Mixing length = 2*slope width','FontSize', fontsize+4,'interpreter','latex');
ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');


subplot(2,2,4)
scatter(-Fcdw_simulation,Fcdw_test_s)
hold on; plot(0:0.01:MAX, 0:0.01:MAX,'--');hold off;
title('Mixing length = 2*slope width','FontSize', fontsize+4,'interpreter','latex');
ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');



% print('-dpng','-r150',[figureloc 'Fcdw_-0.5degC_removeTidalEKE.png']);
% print('-dpng','-r150',[figureloc 'Fcdw_-0.5degC_totalEKE.png']);










% figure(2)
% subplot(1,2,1)
% g1 = scatter(Fcdw_simulation(10),Fcdw_theory_Rh(10),size_marker,'o','filled');
% hold on;
% plot(0:0.1:0.45, 0:0.1:0.45)
% g2 = scatter(Fcdw_simulation(3),Fcdw_theory_Rh(3),size_marker,'*');
% g3 = scatter(Fcdw_simulation(11),Fcdw_theory_Rh(11),size_marker,'s','filled');
% g4 = scatter(Fcdw_simulation(13:15),Fcdw_theory_Rh(13:15),size_marker,'d','filled');
% g5 = scatter(Fcdw_simulation(16),Fcdw_theory_Rh(16),size_marker,'h','filled');
% g6 = scatter(Fcdw_simulation([5 8 9 18 27 30 31 32]),Fcdw_theory_Rh([5 8 9 18 27 30 31 32]),size_marker,'d');
% g7 = scatter(Fcdw_simulation(6:7),Fcdw_theory_Rh(6:7),size_marker,'p','filled');
% 
% hold off;
% % xlim([0 0.1]*N)
% ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
% xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');
% title('Mixing length = Rhines scale, C =$C_{Rh}$=0.015','FontSize', fontsize+4,'interpreter','latex');
% 
% legend([g1,g2,g3,g4,g5,g6,g7],{'Reference simulation','Varying slope width',...
%     'Varying tidal amplitude','Varying wind stress','Varying sea ice thickness',...
%     'Varying cross-slope buoyancy gradients','Varying horizontal resolution'},'FontSize', fontsize,'interpreter','latex');
% 
% 
% 
% subplot(1,2,2)
% g1 = scatter(Fcdw_simulation(10),Fcdw_theory_s(10),size_marker,'o','filled');
% hold on;
% plot(0:0.1:0.45, 0:0.1:0.45)
% g2 = scatter(Fcdw_simulation(3),Fcdw_theory_s(3),size_marker,'*');
% g3 = scatter(Fcdw_simulation(11),Fcdw_theory_s(11),size_marker,'s','filled');
% g4 = scatter(Fcdw_simulation(13:15),Fcdw_theory_s(13:15),size_marker,'d','filled');
% g5 = scatter(Fcdw_simulation(16),Fcdw_theory_s(16),size_marker,'h','filled');
% g6 = scatter(Fcdw_simulation([5 8 9 18 27 30 31 32]),Fcdw_theory_s([5 8 9 18 27 30 31 32]),size_marker,'d');
% g7 = scatter(Fcdw_simulation(6:7),Fcdw_theory_s(6:7),size_marker,'p','filled');
% 
% hold off;
% % xlim([0 0.1]*N)
% ylabel('$F_{CDW}$, theory (Sv)', 'FontSize', fontsize+2,'interpreter','latex');
% xlabel('$F_{CDW}$, simulation (Sv)','FontSize', fontsize+2,'interpreter','latex');
% title('Mixing length = slope width, C =$C_{Rh}/2$=0.0075','FontSize', fontsize+4,'interpreter','latex');
% 
% legend([g1,g2,g3,g4,g5,g6,g7],{'Reference simulation','Varying slope width',...
%     'Varying tidal amplitude','Varying wind stress','Varying sea ice thickness',...
%     'Varying cross-slope buoyancy gradients','Varying horizontal resolution'},'FontSize', fontsize,'interpreter','latex');
% 
% % saveas(gcf,'FCDW_s.png');
