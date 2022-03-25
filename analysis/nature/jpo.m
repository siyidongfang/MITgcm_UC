clear; close all;
load('/data/MITgcm_ASF-csi/products-hires/alongslopcirc_ystart125km_new.mat','EXPNAME',...
    'umax_upper','umax_lower','Tbt_slope_2layer','Tbc_slope_2layer','Ttotal_slope_2layer',...
    'umax','ubotmax', 'Tbt_slope','Tbc_slope','Ttot_slope','usurfmax');
load('/data/MITgcm_ASF-csi/products-hires/MomScalingMatrix_slope_ystart125km.mat',...
    'pTAUoi','pSIinternal','pTopogform','pDissipation','EXPNAME');
load('products_1D_202104.mat','EXPNAME_1D','uu_os_max_1D','uu_ob_max_1D',...
    'Tbt_slope_1D','Tbc_slope_1D','pTAUIOX_1D','pICEINTERNAL_1D',...
    'pBOTTOMFRICTION_1D','pTFS_1D');

% umax = umax_upper;
% ubotmax = umax_lower;
% Tbt_slope = Tbt_slope_2layer;
% Tbc_slope = Tbc_slope_2layer;


pTAUOIX = pTAUoi;
pICEINTERNAL = pSIinternal;
pTOPOGFORM = pTopogform;
pBOTTOMFRIC = pDissipation;

nAtide  = 1:5;
Atide = [0 0.025 0.05 0.075 0.1];
nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];
nhi0 = 14:19;
hi0  = [0.2 0.6 1 1.4 1.8 2.2];
nws = 20:24;
ws = [25 50 75 100 125];
Ys = [150 175 200 225 250];


idx = [nAtide nabs_ua nva nhi0 nws];

nAtide_1D  = nAtide;
nabs_ua_1D = nabs_ua;
nva_1D = nva;
nhi0_1D = nhi0;
nws_1D = nws;
idx_1D = idx;

idx_mom = idx([1:5 7:end]); %%% When Ua0 = 0, the normalized momentum budget terms is Inf


nExp = length(idx);

for i = 1:nExp
    EXPNAME{idx(i)};
    EXPNAME_1D{idx_1D(i)};
end

idx_ref3D = 3;
idx_ref1D = 3;


%% Initialize figure

blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;
darkgray = [150 150 150]/255;

figure(6);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 900 900]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 12;
boxcolor = [225 225 225]/255;
subplotsize = [0.41 0.39];









%%% Make the plot
clf
sz = 35;
LineWidthsz = 1;

ax1 = subplot('position',[0.072 0.58 subplotsize]);
annotation('textbox',[0.072 0.92 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

s00 = scatter(usurfmax(idx),uu_os_max_1D(idx_1D),sz,'black','o');
hold on;
linearCoef_us = polyfit(usurfmax(idx),uu_os_max_1D(idx_1D),1);
linearFit = polyval(linearCoef_us,0:0.01:1);
plot(0:0.01:1,linearFit,'-','color',gray);

s1 = scatter(usurfmax(nAtide),uu_os_max_1D(nAtide_1D),sz,green,'o','filled');
s2 = scatter(usurfmax(nabs_ua),uu_os_max_1D(nabs_ua_1D),sz,lightblue,'o','filled');
s3 = scatter(usurfmax(nva),uu_os_max_1D(nva_1D),sz,lightred,'o','filled');
s4 = scatter(usurfmax(nhi0),uu_os_max_1D(nhi0_1D),sz,brown,'o','filled');
s5 = scatter(usurfmax(nws),uu_os_max_1D(nws_1D),sz,yellow,'o','filled');
s0 = scatter(usurfmax(idx_ref3D),uu_os_max_1D(idx_ref1D),sz*2,'black','o','filled');

b00 = scatter(ubotmax(idx),uu_ob_max_1D(idx_1D),sz,'black','o','LineWidth',0.1);
linearCoef_ub = polyfit(ubotmax(idx),uu_ob_max_1D(idx_1D),1);
linearFit = polyval(linearCoef_ub,0:0.01:1);
plot(0:0.01:1,linearFit,'--','color',gray);

b1 = scatter(ubotmax(nAtide),uu_ob_max_1D(nAtide_1D),sz,green,'o','LineWidth',LineWidthsz);
b2 = scatter(ubotmax(nabs_ua),uu_ob_max_1D(nabs_ua_1D),sz,lightblue,'o','LineWidth',LineWidthsz);
b3 = scatter(ubotmax(nva),uu_ob_max_1D(nva_1D),sz,lightred,'o','LineWidth',LineWidthsz);
b4 = scatter(ubotmax(nhi0),uu_ob_max_1D(nhi0_1D),sz,brown,'o','LineWidth',LineWidthsz);
b5 = scatter(ubotmax(nws),uu_ob_max_1D(nws_1D),sz,yellow,'o','LineWidth',LineWidthsz);
b0 = scatter(ubotmax(idx_ref3D),uu_ob_max_1D(idx_ref1D),sz*2,'black','o','LineWidth',LineWidthsz+0.5);
hold off;
grid on;
box on;
xlim([0 0.4])
ylim([0 0.4])
yticks([0 0.08 0.16 0.24 0.32 0.4])
xticks([0 0.08 0.16 0.24 0.32 0.4])
ylabel('Reduced-order model', 'FontSize', fontsize-1,'interpreter','latex');
xlabel('MITgcm', 'FontSize', fontsize-1,'interpreter','latex');
title('Maximum westward ocean velocities (m/s)','FontSize',fontsize+1,'interpreter','latex');
rho_us = corr(usurfmax(idx)',uu_os_max_1D(idx_1D)');
rho_ub = corr(ubotmax(idx)',uu_ob_max_1D(idx_1D)');
RMSE_us = sqrt(sum((usurfmax(idx)-uu_os_max_1D(idx_1D)).^2)/length(idx));
RMSE_ub = sqrt(sum((ubotmax(idx)-uu_ob_max_1D(idx_1D)).^2)/length(idx));

leg1 = legend([s0 b0],['Surface velocity: $r$=' num2str(roundn(rho_us,-2)) ', RMSE=' num2str(roundn(RMSE_us,-2))],...
        ['Bottom velocity: $r$=' num2str(roundn(rho_ub,-2)) ', RMSE=' num2str(roundn(RMSE_ub,-2))],...
        'FontSize', fontsize-0.3,'interpreter','latex');
set(leg1,'position',[0.145 0.58 0.3262 0.0525])
    
    


ax2 = subplot('position',[0.575 0.58 subplotsize]);
annotation('textbox',[0.575 0.92 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

s00 = scatter(Tbc_slope(idx),Tbc_slope_1D(idx_1D),sz,'black','d');
hold on;
linearCoef_Tbc = polyfit(Tbc_slope(idx),Tbc_slope_1D(idx_1D),1);
linearFit = polyval(linearCoef_Tbc,0:0.01:1);
plot(0:0.01:1,linearFit,'-','color',gray);
s1 = scatter(Tbc_slope(nAtide),Tbc_slope_1D(nAtide_1D),sz,green,'d','filled');
s2 = scatter(Tbc_slope(nabs_ua),Tbc_slope_1D(nabs_ua_1D),sz,lightblue,'d','filled');
s3 = scatter(Tbc_slope(nva),Tbc_slope_1D(nva_1D),sz,lightred,'d','filled');
s4 = scatter(Tbc_slope(nhi0),Tbc_slope_1D(nhi0_1D),sz,brown,'d','filled');
s5 = scatter(Tbc_slope(nws),Tbc_slope_1D(nws_1D),sz,yellow,'d','filled');
s0 = scatter(Tbc_slope(idx_ref3D),Tbc_slope_1D(idx_ref1D),sz*2,'black','d','filled');

b00 = scatter(Tbt_slope(idx),Tbt_slope_1D(idx_1D),sz,'black','d','LineWidth',0.1);
linearCoef_Tbt = polyfit(Tbt_slope(idx),Tbt_slope_1D(idx_1D),1);
linearFit = polyval(linearCoef_Tbt,0:0.01:1);
plot(0:0.01:1,linearFit,'--','color',gray);

b1 = scatter(Tbt_slope(nAtide),Tbt_slope_1D(nAtide_1D),sz,green,'d','LineWidth',LineWidthsz);
b2 = scatter(Tbt_slope(nabs_ua),Tbt_slope_1D(nabs_ua_1D),sz,lightblue,'d','LineWidth',LineWidthsz);
b3 = scatter(Tbt_slope(nva),Tbt_slope_1D(nva_1D),sz,lightred,'d','LineWidth',LineWidthsz);
b4 = scatter(Tbt_slope(nhi0),Tbt_slope_1D(nhi0_1D),sz,brown,'d','LineWidth',LineWidthsz);
b5 = scatter(Tbt_slope(nws),Tbt_slope_1D(nws_1D),sz,yellow,'d','LineWidth',LineWidthsz);
b0 = scatter(Tbt_slope(idx_ref3D),Tbt_slope_1D(idx_ref1D),sz*2,'black','d','LineWidth',LineWidthsz+0.5);
hold off;
grid on;
box on;
xlim([0 0.55])
ylim([0 0.55])
ylabel('Reduced-order model', 'FontSize', fontsize-1,'interpreter','latex');
xlabel('MITgcm', 'FontSize', fontsize-1,'interpreter','latex');
title('Barotropic and baroclinic transports (Sv/km)','FontSize',fontsize+1,'interpreter','latex');
rho_Tbc = corr(Tbc_slope(idx)',Tbc_slope_1D(idx_1D)');
rho_Tbt = corr(Tbt_slope(idx)',Tbt_slope_1D(idx_1D)');
RMSE_Tbc = sqrt(sum((Tbc_slope(idx)-Tbc_slope_1D(idx_1D)).^2)/length(idx));
RMSE_Tbt = sqrt(sum((Tbt_slope(idx)-Tbt_slope_1D(idx_1D)).^2)/length(idx));

leg2 = legend([s0 b0],['Baroclinic transport: $r$=' num2str(roundn(rho_Tbc,-2)) ', RMSE=' num2str(roundn(RMSE_Tbc,-2))],...
        ['Barotropic transport: $r$=' num2str(roundn(rho_Tbt,-2)) ', RMSE=' num2str(roundn(RMSE_Tbt,-2))],...
        'FontSize', fontsize-0.3,'interpreter','latex');
set(leg2,'position',[0.573 0.8636 0.3842 0.0525])
    

%%

ax3 = subplot('position',[0.072 0.1 subplotsize]);
annotation('textbox',[0.072 0.44 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

s00 = scatter(-pICEINTERNAL(idx_mom),-pICEINTERNAL_1D(idx_mom),sz,'black','>','LineWidth',0.1);
hold on;
linearCoef_iceInternal = polyfit(-pICEINTERNAL(idx_mom),-pICEINTERNAL_1D(idx_mom),1);
linearFit = polyval(linearCoef_iceInternal,-0.2:0.01:2);
plot(-0.2:0.01:2,linearFit,'-','color',gray);

s1 = scatter(-pICEINTERNAL(nAtide),-pICEINTERNAL_1D(nAtide_1D),sz,green,'>','LineWidth',LineWidthsz);
s2 = scatter(-pICEINTERNAL(nabs_ua(2:end)),-pICEINTERNAL_1D(nabs_ua_1D(2:end)),sz,lightblue,'>','LineWidth',LineWidthsz);
s3 = scatter(-pICEINTERNAL(nva),-pICEINTERNAL_1D(nva_1D),sz,lightred,'>','LineWidth',LineWidthsz);
s4 = scatter(-pICEINTERNAL(nhi0),-pICEINTERNAL_1D(nhi0_1D),sz,brown,'>','LineWidth',LineWidthsz);
s5 = scatter(-pICEINTERNAL(nws),-pICEINTERNAL_1D(nws_1D),sz,yellow,'>','LineWidth',LineWidthsz);
s0 = scatter(-pICEINTERNAL(idx_ref3D),-pICEINTERNAL_1D(idx_ref1D),sz*2,'black','>','LineWidth',LineWidthsz+0.5);


b00 = scatter(-pTAUOIX(idx_mom),pTAUIOX_1D(idx_mom),sz,'black','.','LineWidth',LineWidthsz);
linearCoef_TAOio = polyfit(-pTAUOIX(idx_mom),pTAUIOX_1D(idx_mom),1);
linearFit = polyval(linearCoef_TAOio,-0.2:0.01:2);
plot(-0.2:0.01:2,linearFit,'--','color',gray);

b1 = scatter(-pTAUOIX(nAtide),pTAUIOX_1D(nAtide_1D),sz,green,'*','LineWidth',LineWidthsz);
b2 = scatter(-pTAUOIX(nabs_ua(2:end)),pTAUIOX_1D(nabs_ua_1D(2:end)),sz,lightblue,'*','LineWidth',LineWidthsz);
b3 = scatter(-pTAUOIX(nva),pTAUIOX_1D(nva_1D),sz,lightred,'*','LineWidth',LineWidthsz);
b4 = scatter(-pTAUOIX(nhi0),pTAUIOX_1D(nhi0_1D),sz,brown,'*','LineWidth',LineWidthsz);
b5 = scatter(-pTAUOIX(nws),pTAUIOX_1D(nws_1D),sz,yellow,'*','LineWidth',LineWidthsz);
b0 = scatter(-pTAUOIX(idx_ref3D),pTAUIOX_1D(idx_ref1D),sz*2,'black','*','LineWidth',LineWidthsz+0.5);
hold off;
grid on;
box on;
xlim([-0.2 1.5])
ylim([-0.2 1.5])
yticks([-0.2 0 0.3 0.6 0.9 1.2 1.5])
xticks([-0.2 0 0.3 0.6 0.9 1.2 1.5])
ylabel('Reduced-order model', 'FontSize', fontsize-1,'interpreter','latex');
xlabel('MITgcm', 'FontSize', fontsize-1,'interpreter','latex');
title('Normalized zonal force balance','FontSize',fontsize+1,'interpreter','latex');
rho_TAUio = corr(-pTAUOIX(idx_mom)',pTAUIOX_1D(idx_mom)');
rho_iceinternal = corr(-pICEINTERNAL(idx_mom)',-pICEINTERNAL_1D(idx_mom)');
RMSE_TAUio = sqrt(sum((-pTAUOIX(idx)-pTAUIOX_1D(idx_1D)).^2)/length(idx));
RMSE_iceinternal = sqrt(sum((pICEINTERNAL(idx)-pICEINTERNAL_1D(idx_1D)).^2)/length(idx));

leg3 = legend([s0 b0],['\begin{tabular}{c} Sea ice internal stress divergence:\\$r$=' num2str(roundn(rho_iceinternal,-2)) ', RMSE=' num2str(roundn(RMSE_iceinternal,-2)) '\end{tabular}'],...
        ['Ice-ocean stress: $r$=' num2str(roundn(rho_TAUio,-2)) ', RMSE=' num2str(roundn(RMSE_TAUio,-2))],...
        'FontSize', fontsize-0.3,'interpreter','latex');
set(leg3,'position',[0.1463 0.1 0.3446 0.0675])




ax4 = subplot('position',[0.575 0.1 subplotsize]);
annotation('textbox',[0.575 0.44 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

s00 = scatter(-pTOPOGFORM(idx_mom),-pTFS_1D(idx_mom),sz,'white','s','LineWidth',0.1);
hold on;


linearCoef_Topog = polyfit(-pTOPOGFORM(idx_mom),-pTFS_1D(idx_mom),1);
linearFit = polyval(linearCoef_Topog,0:0.01:2);
plot(0:0.01:2,linearFit,'-','color',gray);
s1 = scatter(-pTOPOGFORM(nAtide),-pTFS_1D(nAtide_1D),sz,green,'s','LineWidth',LineWidthsz);
s2 = scatter(-pTOPOGFORM(nabs_ua(2:end)),-pTFS_1D(nabs_ua_1D(2:end)),sz,lightblue,'s','LineWidth',LineWidthsz);
s3 = scatter(-pTOPOGFORM(nva),-pTFS_1D(nva_1D),sz,lightred,'s','LineWidth',LineWidthsz);
s4 = scatter(-pTOPOGFORM(nhi0),-pTFS_1D(nhi0_1D),sz,brown,'s','LineWidth',LineWidthsz);
s5 = scatter(-pTOPOGFORM(nws),-pTFS_1D(nws_1D),sz,yellow,'s','LineWidth',LineWidthsz);
s0 = scatter(-pTOPOGFORM(idx_ref3D),-pTFS_1D(idx_ref1D),sz*2,'black','s','LineWidth',LineWidthsz+0.5);

b00 = scatter(-pBOTTOMFRIC(idx_mom),-pBOTTOMFRICTION_1D(idx_mom),sz,'black','h','LineWidth',0.1);
linearCoef_fric = polyfit(-pBOTTOMFRIC(idx_mom),-pBOTTOMFRICTION_1D(idx_mom),1);
linearFit = polyval(linearCoef_fric,0:0.01:2);
plot(0:0.01:2,linearFit,'--','color',gray);

b1 = scatter(-pBOTTOMFRIC(nAtide),-pBOTTOMFRICTION_1D(nAtide_1D),sz,green,'h','LineWidth',LineWidthsz);
b2 = scatter(-pBOTTOMFRIC(nabs_ua(2:end)),-pBOTTOMFRICTION_1D(nabs_ua_1D(2:end)),sz,lightblue,'h','LineWidth',LineWidthsz);
b3 = scatter(-pBOTTOMFRIC(nva),-pBOTTOMFRICTION_1D(nva_1D),sz,lightred,'h','LineWidth',LineWidthsz);
b4 = scatter(-pBOTTOMFRIC(nhi0),-pBOTTOMFRICTION_1D(nhi0_1D),sz,brown,'h','LineWidth',LineWidthsz);
b5 = scatter(-pBOTTOMFRIC(nws),-pBOTTOMFRICTION_1D(nws_1D),sz,yellow,'h','LineWidth',LineWidthsz);
b0 = scatter(-pBOTTOMFRIC(idx_ref3D),-pBOTTOMFRICTION_1D(idx_ref1D),sz*2,'black','h','LineWidth',LineWidthsz+0.5);
hold off;
grid on;
box on;
xlim([0 1.8])
ylim([0 1.8])
yticks([0 0.3 0.6 0.9 1.2 1.5 1.8])
xticks([0 0.3 0.6 0.9 1.2 1.5 1.8])
ylabel('Reduced-order model', 'FontSize', fontsize-1,'interpreter','latex');
xlabel('MITgcm', 'FontSize', fontsize-1,'interpreter','latex');
title('Normalized zonal force balance','FontSize',fontsize+1,'interpreter','latex');

rho_TFS = corr(-pTOPOGFORM(nAtide)',-pTFS_1D(nAtide_1D)');
rho_friction = corr(-pBOTTOMFRIC(idx_mom)',-pBOTTOMFRICTION_1D(idx_mom)');
RMSE_TFS = sqrt(sum((pTOPOGFORM(idx)-pTFS_1D(idx_1D)).^2)/length(idx));
RMSE_friction = sqrt(sum((pBOTTOMFRIC(idx)-pBOTTOMFRICTION_1D(idx_1D)).^2)/length(idx));

leg4 = legend([s0 b0],['TFS: $r$=' num2str(roundn(rho_TFS,-2)) ', RMSE=' num2str(roundn(RMSE_TFS,-2))],...
        ['Bottom friction: $r$=' num2str(roundn(rho_friction,-2)) ', RMSE=' num2str(roundn(RMSE_friction,-2))],...
        'FontSize', fontsize-0.3,'interpreter','latex');
set(leg4,'position',[0.575 0.3603 0.3407 0.0526])



ann0 = annotation('textbox',[0.25    0.01    0.1698    0.03],...
    'String','\textbf{Ref.}','Color','k',...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize+1,'interpreter','latex');
ann1 = annotation('textbox',[0.35    0.01    0.1698    0.03],...
    'String','$\bf A_{\textbf{tide}}$','Color',green,...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize,'interpreter','latex');
ann2 = annotation('textbox',[0.45    0.01    0.1698    0.03],...
    'String','$\bf U_{\textbf{a0}}$','Color',lightblue,...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize,'interpreter','latex');
ann3 = annotation('textbox',[0.55    0.01    0.1698    0.03],...
    'String','$\bf V_{\textbf{a0}}$','Color',lightred,...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize,'interpreter','latex');
ann4 = annotation('textbox',[0.65    0.01    0.1698    0.03],...
    'String','$\bf h_{\textbf{i0}}$','Color',brown,...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize,'interpreter','latex');
ann5 = annotation('textbox',[0.75    0.01    0.1698    0.03],...
    'String','$\bf W_{\textbf{s}}$','Color',yellow,...
    'FontWeight','bold','Edgecolor','w','FitBoxToText','on','FontSize',fontsize,'interpreter','latex');

ann00 = annotation('textbox',[0.225    0.005    0.6    0.035],...
    'String','','FontWeight','bold','Edgecolor','black',...
    'FitBoxToText','off','FontSize',fontsize,'interpreter','latex');





%% Write to file
print('-dpng','-r200','2layer_sensitivity.png');


% figure(1)
% scatter(umax(idx),max(uu_os_max_1D(idx_1D),uu_ob_max_1D(idx_1D)))
% title('Maximum westward velocity (m/s)')
% ylabel('Reduced-order model')
% xlabel('MITgcm')
% 
% figure(2)
% scatter(Tbt_slope(idx),Tbt_slope_1D(idx_1D))
% title('Barotropic transport (Sv/km)')
% ylabel('Reduced-order model')
% xlabel('MITgcm')
% figure(3)
% scatter(Tbc_slope(idx),Tbc_slope_1D(idx_1D))
% title('Baroclinic transport (Sv/km)')
% ylabel('Reduced-order model')
% xlabel('MITgcm')
% 
% figure(4)
% scatter(-pTAUOIX(idx),pTAUIOX_1D(idx_1D))
% title('Normalized ice-ocean stress over the slope')
% ylabel('Reduced-order model')
% xlabel('MITgcm')
% 
% figure(5)
% scatter(-pICEINTERNAL(idx),-pICEINTERNAL_1D(idx_1D))
% title('Normalized sea ice internal stress divergence over the slope')
% ylabel('Reduced-order model')
% xlabel('MITgcm')





