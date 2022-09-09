%%%
%%% plot_scatter.m
%%%


    load_colors;

    fontsize = 16;
    sz = 120;
    LineWidthsz = 1;
    subplotsize = [0.53 0.85];

    %%%%% Make scatter plots
    figure(1)
    clf;
    set(gcf,'color','w');
    set(gcf,'Position',[83 183 1100 750]);
    ax1 = subplot('position',[0.08 0.08 subplotsize]);
    lfit = plot(xgrid,f.p1*xgrid+f.p2,'k','LineWidth',1);
    hold on;
    lfit1 = plot(x1grid,f1.p1*x1grid+f1.p2,'r--','LineWidth',1);
    lfit2 = plot(x2grid,f2.p1*x2grid+f2.p2,'g--','LineWidth',1);
    if(~plotMeltrate)
    lfit3 = plot(x3grid,f3.p1*x3grid+f3.p2,'b--','LineWidth',1);
    end
   
    g1_ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    g1_wind1 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.8,gold,'<','filled','MarkerEdgeColor',boxcolor);
    
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz*1.1,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.8,green,'s','filled','MarkerEdgeColor',boxcolor);

    g1_Hbed0Htr0 = scatter(dataX(7),dataY(7),sz*0.75,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(8),dataY(8),sz*1,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(9),dataY(9),sz*1.5,pink,'^','filled','MarkerEdgeColor',boxcolor);

    g1_Wtr = scatter(dataX(10),dataY(10),sz*1.5,pink,'p','filled','MarkerEdgeColor',pink,'LineWidth',2);

    g1_deep_ref = scatter(dataX(11),dataY(11),sz,darkgray,'o','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(12),dataY(12),sz*0.75,darkgray,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr200 = scatter(dataX(13),dataY(13),sz*1,darkgray,'^','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed300Htr0 = scatter(dataX(14),dataY(14),sz*1.5,darkgray,'^','filled','MarkerEdgeColor',boxcolor);

    g1_tide_weak =  scatter(dataX(15),dataY(15),sz*1.3,seagreen,'h','filled','MarkerEdgeColor',boxcolor);
    g1_tide_strong = scatter(dataX(16),dataY(16),sz*2.3,seagreen,'h','filled','MarkerEdgeColor',boxcolor);

    g1_Nr100 = scatter(dataX(17),dataY(17),sz*1.5,blue,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Nr100_1narrow = scatter(dataX(18),dataY(18),sz*2.2,blue,'o','filled','MarkerEdgeColor',boxcolor);
    g1_Nr100_2iceshelves = scatter(dataX(19),dataY(19),sz*3,blue,'o','filled','MarkerEdgeColor',boxcolor);

    ne = nexp1;

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
    g2_10km_wind2_gmredi = scatter(dataX(16+ne),dataY(16+ne),sz*0.75,'_','MarkerEdgeColor',gold,'LineWidth',3);
    g2_10km_wind3_gmredi = scatter(dataX(17+ne),dataY(17+ne),sz,'_','MarkerEdgeColor',gold,'LineWidth',3);
    g2_10km_wind4_gmredi = scatter(dataX(18+ne),dataY(18+ne),sz*1.5,'_','MarkerEdgeColor',gold,'LineWidth',3);


    if(~excludegroup3)
    ne = nexp1+nexp2;
    g3_melt4=scatter(dataX(ne+1),dataY(ne+1),sz*0.5,'*','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_melt12=scatter(dataX(ne+2),dataY(ne+2),sz*1.2,'*','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_melt21=scatter(dataX(ne+3),dataY(ne+3),sz*2.2,'*','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_5km_melt4=scatter(dataX(ne+4),dataY(ne+4),sz*0.5,'x','filled','MarkerEdgeColor',lightblue,'LineWidth',2.5);
    g3_5km_melt12=scatter(dataX(ne+5),dataY(ne+5),sz*1.2,'x','filled','MarkerEdgeColor',lightblue,'LineWidth',2.5);
    g3_5km_melt21=scatter(dataX(ne+6),dataY(ne+6),sz*2.2,'x','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_10km_melt4=scatter(dataX(ne+7),dataY(ne+7),sz*0.5,'+','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_10km_melt12=scatter(dataX(ne+8),dataY(ne+8),sz*1.2,'+','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    g3_10km_melt21=scatter(dataX(ne+9),dataY(ne+9),sz*2.2,'+','filled','MarkerEdgeColor',lightblue,'LineWidth',2);
    end
    
    ne = nexp1+nexp2+nexp3;
    g4_ref=scatter(dataX(ne+1),dataY(ne+1),sz*0.7,orange,'d','filled','MarkerEdgeColor',boxcolor);
    g4_wind1=scatter(dataX(ne+2),dataY(ne+2),sz*1,orange,'<','filled','MarkerEdgeColor',boxcolor);
    g4_wind2=scatter(dataX(ne+3),dataY(ne+3),sz*1.8,orange,'<','filled','MarkerEdgeColor',boxcolor);

    hold off;
    xlim([min(dataX)-xrange/20 max(dataX)+xrange/20])
    ylim([min(dataY)-yrange/20 max(dataY)+yrange/20])
    set(gca,'FontSize',fontsize)
    xlabel(xlabeltext,'FontSize',fontsize+2);
    ylabel(ylabeltext,'FontSize',fontsize+2);
    title(titletext,'FontSize',fontsize+3);
    grid on;grid minor;

    if(~plotMeltrate)
       leg0 = legend([lfit lfit1 lfit2 lfit3],['Fitted curve: all exps, r = ' num2str(corr_all,'%.2f')],...
            ['Fitted curve: group 1, r = ' num2str(corr1,'%.2f')],...
            ['Fitted curve: group 2, r = ' num2str(corr2,'%.2f')],...
            ['Fitted curve: group 3, r = ' num2str(corr3,'%.2f')],...
            'FontSize',fontsize-2,'Position', [0.6227 0.7127 0.2373 0.1140]);
    else
       leg0 = legend([lfit lfit1 lfit2],['Fitted curve: all exps (excluding group3), r = ' num2str(corr_all,'%.2f')],...
            ['Fitted curve: group 1, r = ' num2str(corr1,'%.2f')],...
            ['Fitted curve: group 2, r = ' num2str(corr2,'%.2f')],...
            'FontSize',fontsize-2,'Position', [0.6227 0.7273 0.3555 0.0867]);
    end

    a1 = annotation('textbox',[0.63 0.9 0.5 0.03],'String','Group 1: Varying ice velocity at zonal boundaries','FontSize',fontsize-2,'EdgeColor','none');
    a2 = annotation('textbox',[0.63 0.87 0.5 0.03],'String','Group 2: Fix ice velocity at zonal boundaries','FontSize',fontsize-2,'EdgeColor','none');
    a3 = annotation('textbox',[0.63 0.84 0.5 0.03],'String','Group 3: Pseudo ice shelf + prescribed meltwater','FontSize',fontsize-2,'EdgeColor','none');
  

    ah1=axes('position',get(gca,'position'),'visible','off');
    leg1 = legend(ah1,[g1_ref g1_wind1 g1_diff2 g1_Hbed0Htr200 g1_Wtr ...
        g1_deep_ref g1_deep_Hbed0Htr0 g1_tide_strong g1_Nr100 g1_Nr100_1narrow g1_Nr100_2iceshelves],...
        'Group1: Ref.',...
        'Group1: Varying zonal wind',...
        'Group1: 3D control of vertical diffusivity',...
        'Group1: Varying Hbed and Htr',...
        'Group1: Trough width=15km (default=30km)',...
        'Group1: deeper thermocline, ref. bathymetry',...
        'Group1: deeper thermocline, varying Hbed and Htr',...
        'Group1: Varying tides',...
        'Group1: Ref., Nr=100',...
        'Group1: 1 narrow ice shelf, Nr=100',...
        'Group1: 2 narrow ice shelves, Nr=100',...
        'FontSize',fontsize-2,'Position',[0.6227 0.4713 0.3682 0.2233]);

    ah2=axes('position',get(gca,'position'),'visible','off');
    leg2 = legend(ah2,[g2_ref g2_wind1 g2_tide g2_Zsb500 g2_longRelax ...
        g2_5km_wind2 g2_10km_wind2 g2_10km_wind2_gmredi],...
        'Group2: Ref.','Group2: Varying zonal wind','Group2: Varying tides',...
        'Group2: Varying isopycal geometry',...
        'Group2: Long relaxation time for sponges',...
        'Group2: 5 km, varying zonal wind',...
        'Group2: 10 km, varying zonal wind',...
        'Group2: 10 km + GM Redi, varying zonal wind',...
        'FontSize',fontsize-2,'Position',[0.6227 0.2260 0.3373 0.2233]);

    if(~excludegroup3)
    ah3=axes('position',get(gca,'position'),'visible','off');
    leg3 = legend(ah3,[g3_melt4 g3_5km_melt4 g3_10km_melt4],...
        'Group3: 2 km, varying prescribed meltwater','Group3: 5 km, varying prescribed meltwater','Group3: 10 km, varying prescribed meltwater',...
        'FontSize',fontsize-2,'Position',[0.6227 0.1214 0.3318 0.0867]);
    end

    ah4=axes('position',get(gca,'position'),'visible','off');
    leg4 = legend(ah4,[g4_ref g4_wind1],...
        'No sea ice: ref.',...
        'No sea ice: Varying zonal wind',...
        'FontSize',fontsize-2,'Position', [0.6218 0.0571 0.2118 0.0513]);

    if(savefigure)
    print('-dpng','-r150',[figdir figname '.png']);
    end

    