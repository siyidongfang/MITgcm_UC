%%%
%%% fig_pseudo.m
%%%
%%% plot heat transport of 4 simulations with pseudo ice shelf

   clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;

    load_colors;

    subplotsize = [0.43 0.2];
    fontsize = 16;
    sz = 60;
    LineWidthsz = 1;

    %%
    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 800 1000]);



    ax1 = subplot('position',[0.065 0.77 subplotsize]);
    annotation('textbox',[0.455 0.745 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax2 = subplot('position',[0.56 0.77 subplotsize]);
    annotation('textbox',[0.95 0.745 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax3 = subplot('position',[0.065 0.53 subplotsize]);
    annotation('textbox',[0.455 0.505 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax4 = subplot('position',[0.56 0.53 subplotsize]);
    annotation('textbox',[0.95 0.505 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax5 = subplot('position',[0.065 0.29 subplotsize]);
    annotation('textbox',[0.455 0.265 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax6 = subplot('position',[0.56 0.29 subplotsize]);
    annotation('textbox',[0.95 0.265 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax7 = subplot('position',[0.065 0.05 subplotsize]);
    annotation('textbox',[0.455 0.025 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');


    ax8 = subplot('position',[0.56 0.05 subplotsize]);
    annotation('textbox',[0.95 0.025 0.05 0.05],'String','(h)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');




