%%%
%%% plot_scatter.m
%%%
%%% A convinent script to make a scatter plot for all the experiments

%     clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;  
    load_colors; 
    prodir = '/Users/csi/MITgcm_UC/products_uc/';

    load([prodir 'matrix.mat'],'EXPNAME',...
        'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'MeltRate_m','MeltRate_Gt',...
        'detady','TAUiox','TAUioy','TAUiox_estimate','TAUioy_estimate',...
        'min_slope_2805','max_slope_2800','db_520','db_490')

    %%%%% Make scatter plots
    fontsize = 15;
    sz = 70;
    LineWidthsz = 1;

    figure(1)
    subplot(1,2,1)
    idx_excludenan=[1:15 17 19 20 22];
    f=fit(db_520(idx_excludenan)',Ub_east_avg(idx_excludenan)','poly1');
    dataX = db_520;
    dataY = Ub_east_avg;

    lfit = plot(f,'k');
    hold on;
    sref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    swind = scatter(dataX(2),dataY(2),sz*0.8,red,'<','filled','MarkerEdgeColor',boxcolor);
    swind2 = scatter(dataX(3),dataY(3),sz*1.3,red,'<','filled','MarkerEdgeColor',boxcolor);
    
    sdiff =  scatter(dataX(13),dataY(13),sz*0.8,green,'s','filled','MarkerEdgeColor',boxcolor);
    sdiff2 =  scatter(dataX(14),dataY(14),sz,green,'s','filled','MarkerEdgeColor',boxcolor);
    sdiff3 =  scatter(dataX(15),dataY(15),sz*1.3,green,'s','filled','MarkerEdgeColor',boxcolor);

    sWtrough = scatter(dataX(19),dataY(19),sz*1.3,gold,'p','filled','MarkerEdgeColor',boxcolor);

%     s3 = 
%     s4 = 
%     s5 = 
%     s6 =
%     s7 = 
%     s8 =
%     s9 =
    hold off;
    grid on;grid minor;
    set(gca,'FontSize',fontsize)
    xlim([0 max(db_520)])
    ylim([0 max(Ub_east_avg)])
    leg1 = legend([sref swind sdiff sWtrough lfit],...
        'Ref.', ...
        'Varying winds',...
        '3D diffusivity',...
        'W_{trough}=15km',...
        'Fitted curve'...
        );
    xlabel('Buoyancy gradient at z = -520 m (kg/m^3/30km)')
    ylabel('Mean eastward bottom velocity (m/s)')
    title('Correlation coefficient = 0.89')

    %%

    subplot(1,2,2)
    f=fit(db_490',Ub_east_avg','poly1');
    plot(f,db_490,Ub_east_avg)
    set(gca,'FontSize',fontsize)
    xlim([0 max(db_490)])
    ylim([0 max(Ub_east_avg)])
    xlabel('Buoyancy gradient at z = -490 m (kg/m^3/30km)')
    ylabel('Mean eastward bottom velocity (m/s)')
    title('Correlation coefficient = 0.81')
%     print('-dpng','-r150',[prodir 'corr1.png']);

    figure(2)
    subplot(1,2,1)
    f=fit(detady',MeltRate_m','poly1');
    plot(f,detady,MeltRate_m)
    set(gca,'FontSize',fontsize)
    xlim([0 max(detady)+0.01])
    ylim([0 max(MeltRate_m)+1])
    xlabel('SSH gradient (m/100km)')
    ylabel('Ice shelf melt rate (m/yr)')
    title('Correlation coefficient = 0.78')

    subplot(1,2,2)
    f=fit(Ub_east_max',MeltRate_m','poly1');
    plot(f,Ub_east_max,MeltRate_m)
    set(gca,'FontSize',fontsize)
    xlim([0 max(Ub_east_max)+0.01])
    ylim([0 max(MeltRate_m)+1])
    xlabel('Max. eastward bottom velocity (m/s)')
    ylabel('Ice shelf melt rate (m/yr)')
    title('Correlation coefficient = 0.71')
%     print('-dpng','-r150',[prodir 'corr2.png']);






    