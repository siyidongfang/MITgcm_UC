%%%
%%% fig6.m
%%%
%%% Sensitivity plots

   clear;
   % close all;

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
    % group2 = [1:14 17 18];  %%% exclude cases with Htr0
    group2 = [1:8 12:14 17]; %%% exclude cases with varying thermocline depth and Htr0
    % group2 = [1:5 7 8 12:14 17]; %%% exclude cases with varying thermocline depth, Htr0, and extreme diffusivity

    figure(3)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1000 1000]);



%%%% %%%% %%%% %%%% panel 4
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
    load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')
    w_dia_is = w_dia_is/1e6; %%% convert to Sv

    dataX = Tcdw_cumulative(group);
    Xlabel = 'Heat transport at ice-shelf front (TW)';
    dataY = MeltRate_m(group); 
    Ylabel='Ice shelf melt rate (m/yr)';
    cor4 = corrcoef(dataX,dataY);
    cor42 = corrcoef(dataX(group2),dataY(group2));

    ax4 = subplot('position',[0.058 0.38 panelsize]);
    fig6_scatters;
    % text(ax4,0.025,28.7,{'(a)'},'FontSize',fontsize+2)
    annotation('textbox',[0.01 0.64 0.15 0.01],'String','a','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 30])
    xlim([0 3.3])




% %%%% %%%% %%%% %%%% panel 5
    dataX = w_dia_is(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = Ug_east_avg(group)*100; 
    Ylabel='Thermal-wind velocity (cm/s)';
    cor5 = corrcoef(dataX,dataY);
    cor52 = corrcoef(dataX(group2),dataY(group2));

    ax5 = subplot('position',[0.394 0.38 panelsize]);
    fig6_scatters;
    % text(ax5,0.005,1.57,{'(b)'},'FontSize',fontsize+2)
    annotation('textbox',[0.342 0.64 0.15 0.01],'String','b','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 2.1])
    xlim(XLIM_WDIA)
    xticks([0:0.1:0.5])



% %%%% %%%% %%%% %%%% panel 6
    % dataX = w_dia_is(group);
    dataX = Tot_east_Sv(group);
    Xlabel = 'Upwelling in the cavity (Sv)';
    dataY = -Tcdw_south_trough(group); 
    Ylabel='Thermal-wind velocity (cm/s)';
    cor6 = corrcoef(dataX,dataY);
    cor62 = corrcoef(dataX(group2),dataY(group2));

    ax6 = subplot('position',[0.72 0.38 panelsize]);
    fig6_scatters;
    annotation('textbox',[0.72 0.645 0.15 0.01],'String','f','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    % ylim([0 0.85])
    % xlim(XLIM_WDIA)
    % xticks([0:0.1:0.5])


%%%% %%%% %%%% %%%% panel 7
    dataX = BPTplusIPT_sb(group)/1000;
    Xlabel = 'Shelf-break pressure torque (10^3 m^3/s^2)';
    dataY = Ueast_transportweighted(group)*100;
    % dataY = U_east_avg(group)*100;
    Ylabel = 'Undercurrent velocity (cm/s)';
    % dataY = Tot_east_Sv(group);
    % Ylabel = 'Undercurrent transport (Sv)';

    cor7 = corrcoef(dataX,dataY);
    cor72 = corrcoef(dataX(group2),dataY(group2));

    ax7 = subplot('position',[0.058 0.052 panelsize]);
    fig6_scatters;
    % text(ax7,1.9,7.6,{'(c)'},'FontSize',fontsize+2)
    annotation('textbox',[0.01 0.31 0.15 0.01],'String','c','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    set(gca,'xdir','reverse')
    ylim([0 10])
    xlim([-7 2])
    % xticks([-8:2:2])


%%%% %%%% %%%% %%%% panel 8
    dataY = Ueast_transportweighted(group)*100;
    % dataY = U_east_avg(group)*100;
    Ylabel = 'Undercurrent velocity (cm/s)';
    dataX = Ug_east_avg(group)*100; 
    % dataX = Tot_east_Sv(group)*100; 
    Xlabel='Thermal-wind velocity (cm/s)';
    cor8 = corrcoef(dataX,dataY);
    cor82 = corrcoef(dataX(group2),dataY(group2));

    ax8 = subplot('position',[0.394 0.052 panelsize]);
    fig6_scatters;
    % text(ax8,0.005,7.6,{'(d)'},'FontSize',fontsize+2)
    annotation('textbox',[0.342 0.31 0.15 0.01],'String','d','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    ylim([0 10])
    xlim([0 2.1])
    % xticks([0:0.5:1.5])


    leg1 = legend([Ref Wind_2 Wind_8 Hbed_0 Hbed_150 Hbed_450 Wtr_15 ...
        Tide_25 Tide_50 Kmax_1 Kmax_10 Kmax_30 ],...
        'Ref','Wind\_2', 'Wind\_8', 'Hbed\_0', 'Hbed\_150' ,'Hbed\_450' ,'Wtr\_15' ,...
        'Tide\_0.025' ,'Tide\_0.05' ,'Kmax\_1e-4' ,'Kmax\_1e-3', 'Kmax\_3e-3');
    set(leg1,'Position',[0.7308-0.015-0.02 0.4125-0.03-0.17 0.1150 0.2195])
    legend boxoff;

    ah=axes('position',get(ax4,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg2 = legend(ah,[DeepThermo DeepWind_2 DeepWind_8 DeepHbed_0],...
        'DeepThermo', 'DeepWind\_2', 'DeepWind\_8', 'DeepHbed\_0');
    legend boxoff;
    set(leg2,'Position', [0.8383-0.02 0.5090-0.17 0.1260 0.0775]) 

    
    ah2=axes('position',get(ax4,'position'),'visible','off');
    set(gca,'FontSize',fontsize);
    leg3 = legend(ah2,[Htr_0 Hbed_0Htr_0 DeepHtr_0 DeepHbed_0Htr_0],...
        'Htr\_0', 'Htr\_0Hbed\_0', 'Htr\_0Deep', 'Htr\_0Hbed\_0Deep');
    legend boxoff;
    set(leg3,'Position', [0.8400-0.02 0.4085-0.17 0.1610 0.0775]) 

    % annotation('textbox',[0.225 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor12(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor1(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % annotation('textbox',[0.225+0.33 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor22(1,2),'%.3f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225+0.33 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor2(1,2),'%.3f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % annotation('textbox',[0.225+0.67 0.765 0.15 0.01],'String',['r_1 = ' num2str(cor32(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225+0.67 0.74 0.15 0.01],'String',['r_2 = ' num2str(cor3(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % 
    annotation('textbox',[0.225 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor42(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor4(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.335 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor52(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.335 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor5(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.67+0.01 0.765-0.335 0.15 0.01],'String',['r_1 = ' num2str(cor62(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.67+0.01 0.74-0.335 0.15 0.01],'String',['r_2 = ' num2str(cor6(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);

    annotation('textbox',[0.225 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor72(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor7(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    annotation('textbox',[0.225+0.335 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor82(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.225+0.335 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor8(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);
    % annotation('textbox',[0.225+0.67 0.765-0.665 0.15 0.01],'String',['r_1 = ' num2str(cor92(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None');
    % annotation('textbox',[0.225+0.67 0.74-0.665 0.15 0.01],'String',['r_2 = ' num2str(cor9(1,2),'%.2f')],'FontSize',fontsize,'LineStyle','None','Color',gray);


    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig6/';
    % print('-dpng','-r200',[figdir 'fig6_pseudo.png']);
    % print('-dpng','-r300',[figdir 'fig6_supp.png']);


