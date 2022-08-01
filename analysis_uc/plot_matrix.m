

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    prodir = '/Users/csi/MITgcm_UC/products_uc/';

    load([prodir 'matrix.mat'],'EXPNAME',...
        'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'MeltRate_m','MeltRate_Gt',...
        'detady','TAUiox','TAUioy','TAUiox_estimate','TAUioy_estimate',...
        'min_slope_2805','max_slope_2800','db_520','db_490')
    
%     figure()
%     scatter(detady,min_slope_2805)

    corrcoef(detady,min_slope_2805)
    corrcoef(Ub_east_max,max_slope_2800)
    corrcoef(Ub_east_max,min_slope_2805)
    corrcoef(Ub_west_avg,min_slope_2805)
    corrcoef(Ub_avg,min_slope_2805)

    corrcoef(MeltRate_m,max_slope_2800)
    corrcoef(MeltRate_m,min_slope_2805)
    corrcoef(MeltRate_m,U_west_avg)
    corrcoef(MeltRate_m,Ub_west_min)

    corrcoef(MeltRate_m,Tot_east_Sv)
    corrcoef(MeltRate_m,Tot_west_Sv)
    corrcoef(MeltRate_m,Tot_Sv)

    corrcoef(MeltRate_m,Ub_east_max)
    corrcoef(MeltRate_m,Ub_avg)
    corrcoef(MeltRate_m,U_east_avg)
    corrcoef(MeltRate_m,Ub_east_avg)
    %%% Ice shelf melt rate has strong correlation with maximum undercurrent
    %%% strength (r=0.71) and total eastward transport (0.63), but it has
    %%% even stronger correlation with the total westward transport
    %%% (r=0.76) or total transport (east+west, r=0.79).

    corrcoef(MeltRate_m,detady)
    %%% Ice shelf melt rate is also correlated with SSH gradient (r=-0.78)

    %%% Zonal sea surface stress is not correlated with ice shelf melt rate or
    %%% undercurrent strength. (Need to check surface stress curl.)


    %%% Undercurrent strength is strongly correlated with cross-slope
    %%% buoyancy gradient (r=0.76~0.89, depending on depth)
    corrcoef(U_east_avg,db_490)
    corrcoef(U_east_avg,db_520,'Rows','pairwise')
    corrcoef(Ub_east_avg,db_490)
    corrcoef(Ub_east_avg,db_520,'Rows','pairwise')
%     corrcoef(Ub_east_max,db_490)
%     corrcoef(Ub_east_max,db_520,'Rows','pairwise')

    fontsize = 15;

    figure(1)
    subplot(1,2,1)
    idx_excludenan=[1:15 17 19 20 22];
    f=fit(db_520(idx_excludenan)',Ub_east_avg(idx_excludenan)','poly1');
    plot(f,db_520(idx_excludenan),Ub_east_avg(idx_excludenan))
    set(gca,'FontSize',fontsize)
    xlim([0 max(db_520)])
    ylim([0 max(Ub_east_avg)])
    xlabel('Buoyancy gradient at z = -520 m (kg/m^3/30km)')
    ylabel('Mean eastward bottom velocity (m/s)')
    title('Correlation coefficient = 0.89')

    subplot(1,2,2)
    f=fit(db_490',Ub_east_avg','poly1');
    plot(f,db_490,Ub_east_avg)
    set(gca,'FontSize',fontsize)
    xlim([0 max(db_490)])
    ylim([0 max(Ub_east_avg)])
    xlabel('Buoyancy gradient at z = -490 m (kg/m^3/30km)')
    ylabel('Mean eastward bottom velocity (m/s)')
    title('Correlation coefficient = 0.81')
    print('-dpng','-r150',[prodir 'corr1.png']);

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
    print('-dpng','-r150',[prodir 'corr2.png']);



%     corrcoef(Ub_west_avg,db_520,'Rows','pairwise')
%     corrcoef(Ub_west_min,db_520,'Rows','pairwise')
%     corrcoef(MeltRate_m,db_490)
%     corrcoef(MeltRate_m,db_520,'Rows','pairwise')
%     corrcoef(detady,db_520,'Rows','pairwise')



    