%%%
%%% fig6_new.m  --- This should be Fig. S3 in the manuscript 
%%%
%%% Sensitivity plots

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

    % XLIM_WDIA= [-0.002 0.5];
    XLIM_WDIA= [0 0.5];

    panelsize = [0.26 0.25];
    fontsize = 16;
    sz = 60;
    LineWidthsz = 1;

    group=1:20;
    % group = [1:5 7:20]
    % group2 = [1:14 17 18];  %%% exclude cases with Htr0
    % group2 = [1:5 7:8 12:14 17];
    group2 = [1:8 12:14 17]; %%% exclude cases with varying thermocline depth and Htr0
    % group2 = [1:5 7 8 12:14 17]; %%% exclude cases with varying thermocline depth, Htr0, and extreme diffusivity

    figure(2)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1000 1000]);

%%%% %%%% %%%% %%%% panel 1
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = MeltRate_m(group); 
    Ylabel='Ice shelf melt rate (m/yr)';
    cor1 = corrcoef(dataX,dataY);
    cor12 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = w_dia_is;
    dataY2 = [0 8 16 24]; 

    ax1 = subplot('position',[0.058 0.715 panelsize]);   
    fig6_scatters;
    % text(ax1,0.005,28.7,{'(a)'},'FontSize',fontsize+2)
    annotation('textbox',[0.055 0.98 0.15 0.01],'String','A','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 30])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])


%%%% %%%% %%%% %%%% panel 2
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = Cori_all(group)/1000; 
    Ylabel ='Coriolis term in the cavity (10^3 m^3/s^2)';
    cor2 = corrcoef(dataX,dataY);
    cor22 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = w_dia_is;
    dataY2 = Cori_all/1000; 

    ax2 = subplot('position',[0.394 0.715 panelsize]);
    fig6_scatters;
    axis ij;
    % text(ax2,0.005,-67,{'(b)'},'FontSize',fontsize+2)
    annotation('textbox',[0.39 0.98 0.15 0.01],'String','B','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([-70 0])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])


%%%% %%%% %%%% %%%% panel 3
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = BPTplusIPT_sb(group)/1000;
    Ylabel = 'Shelf-break pressure torque (10^3 m^3/s^2)';
    cor3 = corrcoef(dataX,dataY);
    cor32 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = w_dia_is;
    dataY2 = BPTplusIPT_sb/1000;

    ax3 = subplot('position',[0.725 0.715 panelsize]);
    fig6_scatters;
    % text(ax3,0.005,-7.6,{'(c)'},'FontSize',fontsize+2)
    annotation('textbox',[0.72 0.98 0.15 0.01],'String','C','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    axis ij;
    ylim([-7 2])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])


%%%% %%%% %%%% %%%% panel 4
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    % dataY = zeta_cdw_tr(group);
    dataY = zeta_cdw_sb_v2(group)/1e6;
    Ylabel = 'Integrated cyclonic vorticity (10^6 m^3/s)';
    cor4 = corrcoef(dataX,dataY);
    cor42 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = w_dia_is;
    dataY2 = zeta_cdw_sb_v2/1e6;

    ax4 = subplot('position',[0.058 0.38 panelsize]);
    fig6_scatters;
    % text(ax4,0.005,-9.6,{'(d)'},'FontSize',fontsize+2)
    annotation('textbox',[0.055 0.645 0.15 0.01],'String','D','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    axis ij;
    ylim([-9 0])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])



%%%% %%%% %%%% %%%% panel 5
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = Ueast_transportweighted(group)*100;
    Ylabel = 'Undercurrent velocity (cm/s)';
    cor5 = corrcoef(dataX,dataY);
    cor52 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = w_dia_is;
    dataY2 = Ueast_transportweighted*100; 

    ax5 = subplot('position',[0.394 0.38 panelsize]);
    fig6_scatters;
    % text(ax5,0.005,7.6,{'(e)'},'FontSize',fontsize+2)
    annotation('textbox',[0.39 0.645 0.15 0.01],'String','E','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 10])
    % ylim([0 6])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])



    %%%% %%%% %%%% %%%% panel 6
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    

    dataX = Ueast_transportweighted(group)*100;
    Xlabel = 'Undercurrent velocity (cm/s)';
    dataY = -Tcdw_south_trough(group); 
    Ylabel='Onshore CDW transport in the trough (Sv)';
    cor6 = corrcoef(dataX,dataY);
    cor62 = corrcoef(dataX(group2),dataY(group2));

    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv
    dataX2 = Ueast_transportweighted*100;
    dataY2 = -Tcdw_south_trough;


    ax6 = subplot('position',[0.725 0.38 panelsize]);
    fig6_scatters;
    annotation('textbox',[0.72 0.645 0.15 0.01],'String','F','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 1])
    xlim([0 10])
    % dataX = MeltRate_m(group); 
    % Xlabel = 'Ice shelf melt rate (m/yr)';
    % dataY = Tot_east_Sv(group);
    % Ylabel = 'Undercurrent transport (Sv)';
    % load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice_vorticity.mat')
    % load('/Users/csi/MITgcm_UC/products/matrix_pseudo_shelfice_seaice.mat')
    % w_dia_is = w_dia_is/1e6; %%% convert to Sv
    % dataX2 = [0 8 16 24];
    % dataY2 = Tot_east_Sv; 
    % ylim([0 0.4])
    % xlim([0 30])



    leg11 = legend([Ref Hbed_0 Hbed_150 Hbed_450],...
        'Ref','Hbed\_0', 'Hbed\_150' ,'Hbed\_450');
    set(leg11,'Position',[0.1398    0.2215    0.1080    0.0775])
    legend boxoff;
     

    ah12=axes('position',get(ax1,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg12 = legend(ah12,[Wind_2 Wind_8 Tide_25 Tide_50],...
         'Wind\_2', 'Wind\_8','Tide\_0.025' ,'Tide\_0.05');
    legend boxoff;
    set(leg12,'Position', [0.2588    0.2215    0.1120    0.0775]) 


    ah13=axes('position',get(ax1,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg13 = legend(ah13,[Kmax_1 Kmax_10 Kmax_30 Wtr_15],...
        'Kmax\_1e-4' ,'Kmax\_1e-3', 'Kmax\_3e-3','Wtr\_15');
    legend boxoff;
    set(leg13,'Position', [0.3778    0.2215    0.1150    0.0775]) 
    

    ah=axes('position',get(ax1,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg2 = legend(ah,[DeepThermo DeepWind_2 DeepWind_8 DeepHbed_0],...
        'DeepThermo', 'DeepWind\_2', 'DeepWind\_8', 'DeepHbed\_0');
    legend boxoff;
    set(leg2,'Position', [0.6278    0.2215    0.1260    0.0775]) 

    
    ah2=axes('position',get(ax1,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg3 = legend(ah2,[Htr_0 Hbed_0Htr_0 DeepHtr_0 DeepHbed_0Htr_0],...
        'Htr\_0', 'Htr\_0Hbed\_0', 'Htr\_0Deep', 'Htr\_0Hbed\_0Deep');
    legend boxoff;
    set(leg3,'Position', [0.7728    0.2215    0.1610    0.0775]) 

    annotation('textbox',[0.225+0.01 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor12(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.01 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor1(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.33+0.01 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor22(1,2),'%.3f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.33+0.01 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor2(1,2),'%.3f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.67+0.01 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor32(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.67+0.01 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor3(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);

    annotation('textbox',[0.225+0.005 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor42(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.005 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor4(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.335+0.015 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor52(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.335+0.015 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor5(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.67+0.01 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor62(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.67+0.01 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor6(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);

    % annotation('textbox',[0.225 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor72(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor7(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % annotation('textbox',[0.225+0.335 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor82(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225+0.335 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor8(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % annotation('textbox',[0.225+0.67 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor92(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225+0.67 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor9(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);


    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig6/';
    % print('-dpng','-r200',[figdir 'fig6_includeVaryingThermo-v1.png']);
    print('-dpng','-r300',[figdir 'fig6.png']);


