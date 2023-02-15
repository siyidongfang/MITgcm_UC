


    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions; 
%     load('/Users/csi/MITgcm_UC/products_uc/shelfice_seaice/matrix_shelfice_seaice.mat')
%     load('/Users/csi/MITgcm_UC/products_uc/seaice_boundary/matrix_seaice_boundary.mat')
    load('/Users/csi/MITgcm_UC/products_uc/matrix_combined-group12-allLx.mat')

    figdir = '/Users/csi/MITgcm_UC/figures_uc/'; 
    savefigure = false;

%     dataY = MeltRate_m([1:36 40:42]);
%     ylabeltext = 'Ice shelf melt rate (m/yr)';
% %     dataX = U_east_avg([1:36 40:42])*100;
%      dataX = Ueast_transportweighted([1:36 40:42])*100;
%     xlabeltext = 'Undercurrent velocity (cm/s)';
%     titletext = {'The melt rate is correlated with the','undercurrent'};


    dataY = U_east_avg([1:36 40:42])*100;
%     dataY = Ueast_transportweighted([1:36 40:42])*100;
    ylabeltext='Undercurrent velocity (cm/s)';
    dataX = Ug_east_avg([1:36 40:42])*100;
%      dataX = Ug_east_transportweighted([1:36 40:42])*100;
    xlabeltext = 'Eastward thermal-wind velocity (cm/s)';
    titletext = {'The undercurrent is correlated with the','cross-slope buoyancy gradient'};

    f=fit(dataX',dataY','poly1');
    corr =  corrcoef(dataX,dataY)
%     f=fit(dataX([1:12 17:21 24:end])',dataY([1:12 17:21 24:end])','poly1');
%     corr =  corrcoef(dataX([1:12 17:21 24:end]),dataY([1:12 17:21 24:end]))


    xrange = max(dataX)-min(dataX);
    yrange = max(dataY)-min(dataY);
    xgrid = 0:xrange/100:max(dataX)+1;

    load_colors;

    fontsize = 22;
    sz = 120;
    LineWidthsz = 1;

    figure(1)
    clf;
    set(gcf,'color','w');
    set(gcf,'Position',[83 183 650 550]);
%     lfit = plot(xgrid,f.p1*xgrid+f.p2,'k','LineWidth',1);
    hold on;
%     scatter(dataX,dataY)
    
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);

    g1_Hbed0Htr200 = scatter(dataX(7),dataY(7),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed150Htr200 = scatter(dataX(8),dataY(8),sz*0.9,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed450Htr200 = scatter(dataX(9),dataY(9),sz*1.3,pink,'^','filled','MarkerEdgeColor',boxcolor);

    g1_Hbed0Htr0 = scatter(dataX(10),dataY(10),sz*0.5,green,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(11),dataY(11),sz*1.5,green,'^','filled','MarkerEdgeColor',boxcolor);

    g1_Wtr = scatter(dataX(12),dataY(12),sz*1.5,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);

    g1_deep_ref = scatter(dataX(13),dataY(13),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(14),dataY(14),sz*0.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr200 = scatter(dataX(15),dataY(15),sz*1,coral,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed300Htr0 = scatter(dataX(16),dataY(16),sz*1.5,darkgreen,'^','filled','MarkerEdgeColor',boxcolor);

    g1_tide_weak =  scatter(dataX(17),dataY(17),sz*1.3,seagreen,'h','filled','MarkerEdgeColor',boxcolor);
    g1_tide_strong = scatter(dataX(18),dataY(18),sz*2.3,seagreen,'h','filled','MarkerEdgeColor',boxcolor);

    g1_Nr100 = scatter(dataX(19),dataY(19),sz*1,blue,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Nr100_1narrow = scatter(dataX(20),dataY(20),sz*0.5,blue,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Nr100_2iceshelves = scatter(dataX(21),dataY(21),sz*1.5,blue,'o','filled','MarkerEdgeColor',boxcolor);

    g1_deep_wind1 = scatter(dataX(22),dataY(22),sz*1,darkgray,'<','filled','MarkerEdgeColor',boxcolor);
    g1_deep_wind2 = scatter(dataX(23),dataY(23),sz*1.8,darkgray,'<','filled','MarkerEdgeColor',boxcolor);
    g1_seaiceITER = scatter(dataX(24),dataY(24),sz*1.2,yellow,'o','filled','MarkerEdgeColor',boxcolor);


    ne = 24;

    g2_ref = scatter(dataX(1+ne),dataY(1+ne),sz*2,'k','o','LineWidth',2);
    g2_wind1 = scatter(dataX(2+ne),dataY(2+ne),sz,'<','MarkerEdgeColor',gold,'LineWidth',2);
    g2_wind2 = scatter(dataX(3+ne),dataY(3+ne),sz*1.3,'<','MarkerEdgeColor',gold,'LineWidth',2);
    g2_tide = scatter(dataX(4+ne),dataY(4+ne),sz*1.3,'h','MarkerEdgeColor',seagreen,'LineWidth',2);

    g2_dZs200 = scatter(dataX(8+ne),dataY(8+ne),sz*0.8,'p','MarkerEdgeColor',orange,'LineWidth',2);
    g2_Zn450 = scatter(dataX(5+ne),dataY(5+ne),sz*1.2,'p','MarkerEdgeColor',orange,'LineWidth',2);
    g2_Zsb500 = scatter(dataX(6+ne),dataY(6+ne),sz*1.6,'p','MarkerEdgeColor',orange,'LineWidth',2);
    g2_dZs50 = scatter(dataX(7+ne),dataY(7+ne),sz*2.2,'p','MarkerEdgeColor',orange,'LineWidth',2);

    g2_longRelax = scatter(dataX(9+ne),dataY(9+ne),sz,'o','MarkerEdgeColor',green,'LineWidth',2);

    g2_5km_wind2 = scatter(dataX(10+ne),dataY(10+ne),sz*0.7,'x','MarkerEdgeColor',gold,'LineWidth',2.5);
    g2_5km_wind3 = scatter(dataX(11+ne),dataY(11+ne),sz,'x','MarkerEdgeColor',gold,'LineWidth',2.5);
    g2_5km_wind4 = scatter(dataX(12+ne),dataY(12+ne),sz*1.8,'x','MarkerEdgeColor',gold,'LineWidth',2.5);
    g2_10km_wind2 = scatter(dataX(13+ne),dataY(13+ne),sz*0.7,'+','MarkerEdgeColor',gold,'LineWidth',2.5);
    g2_10km_wind3 = scatter(dataX(14+ne),dataY(14+ne),sz,'+','MarkerEdgeColor',gold,'LineWidth',2.5);
    g2_10km_wind4 = scatter(dataX(15+ne),dataY(15+ne),sz*1.8,'+','MarkerEdgeColor',gold,'LineWidth',2.5);
%     g2_10km_wind2_gmredi = scatter(dataX(16+ne),dataY(16+ne),sz*0.75,'_','MarkerEdgeColor',gold,'LineWidth',3);
%     g2_10km_wind3_gmredi = scatter(dataX(17+ne),dataY(17+ne),sz,'_','MarkerEdgeColor',gold,'LineWidth',3);
%     g2_10km_wind4_gmredi = scatter(dataX(18+ne),dataY(18+ne),sz*1.5,'_','MarkerEdgeColor',gold,'LineWidth',3);

    hold off;
    xlim([min(dataX)-xrange/20 max(dataX)+xrange/20])
    ylim([min(dataY)-yrange/20 max(dataY)+yrange/20])
    set(gca,'FontSize',fontsize)
    xlabel(xlabeltext,'FontSize',fontsize+1);
    ylabel(ylabeltext,'FontSize',fontsize+1);
    title(titletext,'FontSize',fontsize+3);
    grid on;grid minor;box on;
%     xlim([0 5.5])
%     ylim([0 8])
%     ylim([0 25])
%     xlim([0 8])



%      figdir = '/Users/csi/MITgcm_UC/figures_uc/';
%      print('-dpng','-r300',[figdir 'corr_UC.png']);
%      print('-dpng','-r300',[figdir 'corr_melt.png']);

