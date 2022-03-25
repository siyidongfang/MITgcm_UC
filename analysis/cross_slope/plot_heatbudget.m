clear;
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/sensitivity/'

prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/'
load([prodir 'decompose_heatbudget.mat'])
fontsize=15;
dS = 0.2625;
Sshelf  = [[33;33] [33;33] [33;33] [33;33] [33;33] [33;33]...
    [33;33+dS] [33;33+2*dS] [33;33+3*dS] [33;33+4*dS]...
    [33.59;33.59+dS] [33.59;33.59+2*dS] [33.59;33.59+3*dS] [33.59;33.59+4*dS]...
    [34.12;34.12] [34.12;34.12+3*dS] [34.12;34.12+4*dS]...
    [33;33+dS] [33;33+dS] ...
    [34.12-dS;34.12+dS] ...
    [34.12;34.12+3*dS] ...
    [33.59-0.5*dS;33.59+0.5*dS] [33.59-dS;33.59+dS]...
    [34.12;34.12+3*dS] ...
    ];


idx_group = [2 7 8 9 10 11 12 13 14 15 16 17 ...
   ];
% idx_group= 1:24;

figure(1)
clf
hold on
scatter(Sshelf(2,idx_group),F_cavity(idx_group),100,'filled','d','LineWidth',1.5) 
scatter(Sshelf(2,idx_group),Fi_shelf(idx_group),100,'o','LineWidth',1.5) 
scatter(Sshelf(2,idx_group),Fi_slope(idx_group),100,'p','LineWidth',1) 
scatter(Sshelf(2,idx_group),Fi_deep(idx_group),100,'^','LineWidth',1) 
hold off
set(gca,'FontSize',fontsize)
leg1=legend('$F_\mathrm{cavity}$','$F^\mathrm{io}_\mathrm{shelf}$',...
    '$F^\mathrm{io}_\mathrm{slope}$','$F^\mathrm{io}_\mathrm{deep}$',...
    'interpreter','latex','FontSize',fontsize+4);
set(leg1,'Position',[0.1579 0.1644 0.1129 0.2122])
set(gcf,'InnerPosition',[7 54 670 470])
ylim([-0.5 0])

title('Decomposition of heat budget','FontSize',fontsize+4,'interpreter','latex')
xlabel('Ocean bottom salinity at the southern boundary (psu)','interpreter','latex','FontSize',fontsize+2)
ylabel('($10^12$ W)','interpreter','latex','FontSize',fontsize+2)
% print('-dpng','-r150',[outdir 'heat_budget_only_change_S_NoWinds.png']);
