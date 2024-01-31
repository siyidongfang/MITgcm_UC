

    lw_markers = 2;

    xrange = max(dataX)-min(dataX);
    xgrid = min(dataX)-xrange/5:xrange/100:max(dataX)+xrange/5;
    f2 = fit(dataX(group2)',dataY(group2)','poly1');
    lfit = plot(xgrid,f2.p1*xgrid+f2.p2,'k','LineWidth',0.5);

    hold on;
    % pseudo0 = scatter(dataX2(1),dataY2(1),sz,blue,'*');
    % pseudo4 = scatter(dataX2(2),dataY2(2),sz*2,blue,'*');
    % pseudo12 = scatter(dataX2(3),dataY2(3),sz*3,blue,'*');
    % pseudo21 = scatter(dataX2(4),dataY2(4),sz*4,blue,'*');
    Wind_2 = scatter(dataX(2),dataY(2),sz,gold,'<','filled','MarkerEdgeColor',gold);
    Wind_8 = scatter(dataX(3),dataY(3),sz*2,yellow,'<','filled','MarkerEdgeColor',yellow);
    Hbed_0 = scatter(dataX(12),dataY(12),sz,RED3,'^','filled','MarkerEdgeColor',RED3);
    Hbed_150 = scatter(dataX(13),dataY(13),sz*1.5,RED2,'^','filled','MarkerEdgeColor',RED2);
    Hbed_450 = scatter(dataX(14),dataY(14),sz*2,RED1,'^','filled','MarkerEdgeColor',RED1);
    Wtr_15 = scatter(dataX(17),dataY(17),sz,blue,'p','filled','MarkerEdgeColor',blue,'LineWidth',2);
    Tide_25 =  scatter(dataX(7),dataY(7),sz,green,'h','filled','MarkerEdgeColor',green);
    Tide_50 =  scatter(dataX(8),dataY(8),sz*1.5,green2,'h','filled','MarkerEdgeColor',green2);
    Kmax_1 =  scatter(dataX(4),dataY(4),sz,BLUE1,'s','filled','MarkerEdgeColor',BLUE1);
    Kmax_10 =  scatter(dataX(5),dataY(5),sz*1.3,BLUE2,'s','filled','MarkerEdgeColor',BLUE2);
    Kmax_30 =  scatter(dataX(6),dataY(6),sz*1.5,BLUE3,'s','filled','MarkerEdgeColor',BLUE3);
    DeepThermo = scatter(dataX(9),dataY(9),sz*0.9,darkgray,'d','MarkerEdgeColor',darkgray,'LineWidth',lw_markers);
    DeepWind_8 = scatter(dataX(11),dataY(11),sz*1.1,brown2,'d','MarkerEdgeColor',brown2,'LineWidth',lw_markers);
    DeepWind_2 = scatter(dataX(10),dataY(10),sz*0.8,gold,'d','MarkerEdgeColor',gold,'LineWidth',lw_markers);
    DeepHbed_0 = scatter(dataX(18),dataY(18),sz,RED3,'d','MarkerEdgeColor',red,'LineWidth',lw_markers);
    Htr_0 = scatter(dataX(15),dataY(15),sz,'^','MarkerEdgeColor',green,'LineWidth',lw_markers);
    Hbed_0Htr_0 = scatter(dataX(16),dataY(16),sz,'^','MarkerEdgeColor',blue,'LineWidth',lw_markers);
    DeepHtr_0 = scatter(dataX(19),dataY(19),sz,'o','MarkerEdgeColor',green,'LineWidth',lw_markers);
    DeepHbed_0Htr_0 = scatter(dataX(20),dataY(20),sz,'o','MarkerEdgeColor',blue,'LineWidth',lw_markers);
    Ref = scatter(dataX(1),dataY(1),sz*2,'k','o','filled');
    ylabel(Ylabel)
    xlabel(Xlabel)
    set(gca,'FontSize',fontsize);grid on;grid minor;box on;
    hold off;



