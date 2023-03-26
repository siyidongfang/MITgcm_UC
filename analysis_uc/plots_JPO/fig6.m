%%%
%%% fig6.m
%%%
%%% Sensitivity plots

%    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/cbarrow;


    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv


    load_colors;


    panelsize = [0.26 0.38];
    fontsize = 16;
    sz = 60;
    LineWidthsz = 1;

    group=1:20;
    group1 = [1:14 17 18];  %%% exclude cases with Htr0
    group2 = [1:8 12:14 17]; %%% exclude cases with varying thermocline depth and Htr0
    % group2 = [1:5 7 8 12:14 17]; %%% exclude cases with varying thermocline depth, Htr0, and extreme diffusivity

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1200 700]);

    dataX = w_dia_is(group);
    dataY = MeltRate_m(group); 
    ax1 = subplot('position',[0.04 0.6 panelsize]);   
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Ice shelf melt rate (m/yr)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax1,0.005,29,{'(a)'},'FontSize',fontsize+2)


    leg1 = legend([Ref Wind_2 Wind_8 Hbed_0 Hbed_150 Hbed_450 Wtr_15 ...
        Tide_25 Tide_50 Kmax_1 Kmax_10 Kmax_30 ...
        DeepThermo DeepWind_2 DeepWind_8 DeepHbed_0 ...
        Htr_0 Hbed_0Htr_0 DeepHtr_0 DeepHbed_0Htr_0],...
        'Ref','Wind\_2', 'Wind\_8', 'Hbed\_0', 'Hbed\_150' ,'Hbed\_450' ,'Wtr\_15' ,...
        'Tide\_0.025' ,'Tide\_0.05' ,'Kmax\_1e-4' ,'Kmax\_1e-3', 'Kmax\_3e-3', ...
        'DeepThermo', 'DeepWind\_2', 'DeepWind\_8', 'DeepHbed\_0', ...
        'Htr\_0', 'Hbed\_0Htr\_0', 'DeepHtr\_0', 'Hbed\_0Htr\_0');
    % set(leg1,'Position',[0.8 0.4921 0.1775 0.2])


    

    dataY = Cori_all(group)/1000; 
    dataY2 = Adv_all(group)/1000;
    ax2 = subplot('position',[0.38 0.6 panelsize]);
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Coriolis term in the cavity')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax2,0.005,-58,{'(b)'},'FontSize',fontsize+2)


    dataY = Ug_east_transportweighted(group)*100; 
    cor3 = corrcoef(dataX(group2),dataY(group2))

    ax3 = subplot('position',[0.72 0.6 panelsize]);
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Thermal-wind velocity (cm/s)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax3,0.005,2.85,{'(c)'},'FontSize',fontsize+2)


    dataY = BPTplusIPT_sb(group)/1000;
    cor4 = corrcoef(dataX(group2),dataY(group2))

    ax4 = subplot('position',[0.04 0.09 panelsize]);
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Pressure torque over the shelf break')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax4,0.005,-5.8,{'(d)'},'FontSize',fontsize+2)


    dataY = zeta_cdw_sbtr_min(group)*1000;
    cor5 = corrcoef(dataX(group2),dataY(group2))

    ax5 = subplot('position',[0.38 0.09 panelsize]);
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Relative vorticity over the shelf break')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax5,0.005,-1.92,{'(e)'},'FontSize',fontsize+2)


    dataY = Ueast_transportweighted(group)*100;
    cor6 = corrcoef(dataX(group2),dataY(group2))

    ax6 = subplot('position',[0.72 0.09 panelsize]);
    hold on;
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,lightpurple,'s','filled','MarkerEdgeColor',lightpurple);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.5,purple,'s','filled','MarkerEdgeColor',purple);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*2,darkpurple,'s','filled','MarkerEdgeColor',darkpurple);
    DeepThermo = scatter(dataX(9),dataY(9),sz,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',1);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*2,yellow,'d','MarkerEdgeColor',green,'LineWidth',1);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz,gold,'d','MarkerEdgeColor',gold,'LineWidth',1);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',1);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',1);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',1);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',1);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',1);
    Ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    ylabel('Undercurrent velocity (cm/s)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax6,0.005,5.7,{'(f)'},'FontSize',fontsize+2)


    %%
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig6/';
%     print('-dpng','-r200',[figdir 'fig6.png']);






