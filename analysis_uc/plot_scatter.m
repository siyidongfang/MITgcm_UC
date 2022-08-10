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
    fontsize = 17;
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
    sref = scatter(dataX(10),dataY(10),sz,'k','o','filled');
    swind1 = scatter(dataX(11),dataY(11),sz*0.5,red,'<','filled','MarkerEdgeColor',boxcolor);
    swind2 = scatter(dataX(12),dataY(12),sz*1.5,red,'<','filled','MarkerEdgeColor',boxcolor);
    
    sdiff1 =  scatter(dataX(13),dataY(13),sz*0.5,green,'s','filled','MarkerEdgeColor',boxcolor);
    sdiff2 =  scatter(dataX(14),dataY(14),sz,green,'s','filled','MarkerEdgeColor',boxcolor);
    sdiff3 =  scatter(dataX(15),dataY(15),sz*1.5,green,'s','filled','MarkerEdgeColor',boxcolor);

    Hbed0Htr0 = scatter(dataX(16),dataY(16),sz*1.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    Hbed0Htr200 = scatter(dataX(17),dataY(17),sz,pink,'^','filled','MarkerEdgeColor',boxcolor);
    Hbed300Htr0 = scatter(dataX(18),dataY(18),sz*0.5,pink,'^','filled','MarkerEdgeColor',boxcolor);

    sWtr = scatter(dataX(19),dataY(19),sz*1.3,gold,'p','filled','MarkerEdgeColor',boxcolor);

    sdeep_ref = scatter(dataX(20),dataY(20),sz,brown,'d','filled','MarkerEdgeColor',boxcolor);
    sdeep_Hbed0Htr0 = scatter(dataX(21),dataY(21),sz*1.5,brown,'d','filled','MarkerEdgeColor',boxcolor);
    sdeep_Hbed0Htr200 = scatter(dataX(22),dataY(22),sz,brown,'d','filled','MarkerEdgeColor',boxcolor);
    sdeep_Hbed300Htr0 = scatter(dataX(23),dataY(23),sz*0.5,brown,'d','filled','MarkerEdgeColor',boxcolor);

    suniform_ref = scatter(dataX(1),dataY(1),sz,'k','o');
    suniform_wind1 = scatter(dataX(2),dataY(2),sz*0.5,red,'<','MarkerEdgeColor',red);
    suniform_wind2 = scatter(dataX(3),dataY(3),sz*1.5,red,'<','MarkerEdgeColor',red);
    suniform_tide = scatter(dataX(4),dataY(4),sz*1.5,red,'<','MarkerEdgeColor',red);
    suniform_Zn450 = scatter(dataX(5),dataY(5),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    suniform_Zsb500 = scatter(dataX(6),dataY(6),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    suniform_dZs50 = scatter(dataX(7),dataY(7),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    suniform_dZs200 = scatter(dataX(8),dataY(8),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    suniform_longRelax = scatter(dataX(9),dataY(9),sz,green,'d','MarkerEdgeColor',green);
    hold off;
    grid on;grid minor;
    set(gca,'FontSize',fontsize)
    xlim([0 max(db_520)+0.01])
    ylim([0 max(Ub_east_avg)+0.001])
    leg1 = legend([sref swind1 swind2 ...
        sdiff1 sdiff2 sdiff3 ...
        Hbed0Htr0 Hbed0Htr200 Hbed300Htr0 sWtr ...
        sdeep_ref sdeep_Hbed0Htr0 sdeep_Hbed0Htr200 sdeep_Hbed300Htr0 ...
        suniform_ref suniform_wind1 suniform_wind2 suniform_tide ...
        suniform_Zn450 suniform_Zsb500 suniform_dZs50 suniform_dZs200 suniform_longRelax...
        ...
        lfit],...
        'Ref.','Ua=-2 m/s, Va=2 m/s','Ua=-8 m/s, Va=8 m/s',...
        'kmax=0.0001 m^2/s','kmax=0.001 m^2/s','kmax=0.003 m^2/s',...
        'Hbed=0, Htr=0m','Hbed=0, Htr=200m','Hbed=300m, Htr=0',...
        'W_{trough}=15km',...
        'Deeper thermocline: Ref.',...
        'Deeper thermocline: Hbed=0, Htr=0m','Deeper thermocline: Hbed=0, Htr=200m','Deeper thermocline: Hbed=300m, Htr=0',...
        'Uniform ice inflow: Ref.',...
        'Uniform ice inflow: Ua=-2 m/s, Va=2 m/s',...
        'Uniform ice inflow: Ua=-8 m/s, Va=8 m/s',...
        'Uniform ice inflow: Atide = 0.02m/s',...
        'Uniform ice inflow: Zn450',...
        'Uniform ice inflow: Zsb500',...
        'Uniform ice inflow: dZs50',...
        'Uniform ice inflow: dZs200',...
        'Uniform ice inflow: longRelax',...
        'Fitted curve',...
        'Location','SouthEast');
%     leg1=legendScatter({'SIZE','1','2','3','4','5', ...
%                 '6','7','8','9','10'},[1:1:10],10,'pk');
%     leg1.Location='SouthEast';
    xlabel('Buoyancy gradient at z = -520 m (kg/m^3/30km)')
    ylabel('Mean eastward bottom velocity (m/s)')
    title('Correlation coefficient = 0.89')

%     %%
% 
%     subplot(1,2,2)
%     f=fit(db_490',Ub_east_avg','poly1');
%     plot(f,db_490,Ub_east_avg)
%     set(gca,'FontSize',fontsize)
%     xlim([0 max(db_490)])
%     ylim([0 max(Ub_east_avg)])
%     xlabel('Buoyancy gradient at z = -490 m (kg/m^3/30km)')
%     ylabel('Mean eastward bottom velocity (m/s)')
%     title('Correlation coefficient = 0.81')
% %     print('-dpng','-r150',[prodir 'corr1.png']);
% 
%     figure(2)
%     subplot(1,2,1)
%     f=fit(detady',MeltRate_m','poly1');
%     plot(f,detady,MeltRate_m)
%     set(gca,'FontSize',fontsize)
%     xlim([0 max(detady)+0.01])
%     ylim([0 max(MeltRate_m)+1])
%     xlabel('SSH gradient (m/100km)')
%     ylabel('Ice shelf melt rate (m/yr)')
%     title('Correlation coefficient = 0.78')
% 
%     subplot(1,2,2)
%     f=fit(Ub_east_max',MeltRate_m','poly1');
%     plot(f,Ub_east_max,MeltRate_m)
%     set(gca,'FontSize',fontsize)
%     xlim([0 max(Ub_east_max)+0.01])
%     ylim([0 max(MeltRate_m)+1])
%     xlabel('Max. eastward bottom velocity (m/s)')
%     ylabel('Ice shelf melt rate (m/yr)')
%     title('Correlation coefficient = 0.71')
% %     print('-dpng','-r150',[prodir 'corr2.png']);
% 





    