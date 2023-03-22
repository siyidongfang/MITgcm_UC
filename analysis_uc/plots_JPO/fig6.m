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

%%



%     panelsize = [0.26 0.35];
panelsize = [0.26 0.38];
    fontsize = 16;
    sz = 60;
    LineWidthsz = 1;

%     group = [1:6 9 12:17 19 20];
    group=1:20;

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1200 700]);

    dataX = w_dia_is(group);
    dataY = MeltRate_m(group); 
    ax1 = subplot('position',[0.04 0.6 panelsize]);   
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    ylabel('Ice shelf melt rate (m/yr)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax1,0.005,24,{'(a)'},'FontSize',fontsize+2)



    dataY = Cori_all(group)/1000; 
    dataY2 = Adv_all(group)/1000;
    ax2 = subplot('position',[0.38 0.6 panelsize]);
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
%     g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o');
    ylabel('Coriolis term in the cavity')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax2,0.005,-58,{'(b)'},'FontSize',fontsize+2)


    dataY = Ug_east_transportweighted(group)*100; 
    ax3 = subplot('position',[0.72 0.6 panelsize]);
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    ylabel('Thermal-wind velocity (cm/s)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax3,0.005,2.85,{'(c)'},'FontSize',fontsize+2)

    dataY = BPTplusIPT_sb(group)/1000;
    ax4 = subplot('position',[0.04 0.09 panelsize]);
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    ylabel('Pressure torque over the shelf break')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax4,0.005,-5.8,{'(d)'},'FontSize',fontsize+2)


    dataY = zeta_cdw_sbtr_min(group)*1000;
    ax5 = subplot('position',[0.38 0.09 panelsize]);
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    ylabel('Relative vorticity over the shelf break')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    axis ij;
    text(ax5,0.005,-1.92,{'(e)'},'FontSize',fontsize+2)

    dataY = Ueast_transportweighted(group)*100;
    ax6 = subplot('position',[0.72 0.09 panelsize]);
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    hold on;
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_deep_ref = scatter(dataX(9),dataY(9),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(12),dataY(12),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(13),dataY(13),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(14),dataY(14),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(15),dataY(15),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Wtr = scatter(dataX(17),dataY(17),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    g1_deep_Hbed300Htr0 = scatter(dataX(19),dataY(19),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(20),dataY(20),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    ylabel('Undercurrent velocity (cm/s)')
    xlabel('Upwelling in the cavity (Sv)')
    set(gca,'FontSize',fontsize);grid on;box on;
    text(ax6,0.005,5.7,{'(f)'},'FontSize',fontsize+2)


    leg1 = legend([g1_ref g1_wind2 g1_diff3 ...
        g1_Hbed450Htr200 g1_Hbed300Htr0 g1_Hbed0Htr0 g1_Wtr ...
        g1_deep_ref g1_deep_Hbed300Htr0 g1_deep_Hbed0Htr0],...
        'Ref.','Winds','Diffusivity','Hbed','No trough','Hbed=0, Htr=0','Narrow trough',...
        'Deep thermocline','Deep thermo. Htr=0','Deep thermo. Hbed=Htr=0');
    set(leg1,'Position',[0.1625 0.4921 0.1775 0.2693])

    %%
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig6/';
%     print('-dpng','-r200',[figdir 'fig6.png']);






