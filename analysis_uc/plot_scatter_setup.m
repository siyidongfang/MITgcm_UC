%%%
%%% plot_scatter.m
%%%

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions; 
    load('/Users/csi/MITgcm_UC/products_uc/matrix_combined.mat')

    figdir = '/Users/csi/MITgcm_UC/figures_uc/correlation_new/'; 

   
    nexp1 = 19;
    nexp2 = 18;
    nexp3 = 9;
    nexp4 = 1;
    group1 = 1:nexp1;
    group2 = (nexp1+1):(nexp1+nexp2);
    group3 = (nexp1+nexp2+1):(nexp1+nexp2+nexp3);
    group4 = nexp1+nexp2+nexp3+nexp4;

    plotMeltrate=true;

%     dataX = -detady;
%     xlabeltext = 'Cross-slope SSH gradient (m/100km)';
%     dataX = Hcdw;
%     xlabeltext = 'CDW thickness over the trough (m)';
%     dataX=Tcdw;
%     xlabeltext = 'CDW temperature in the trough (^oC)';
%     dataX=Ub_avg;
%     xlabeltext = 'Mean bottom velocity over the slope (m/s)';
%     dataX=avg_slope_2800*100*1000;
%     xlabeltext = 'Cross-slope depth change of isopycnal \gamma = 28.00 kg/m^3 (m/100km)';
%     dataX=avg_slope_2805*100*1000;
%     xlabeltext = 'Cross-slope depth change of isopycnal \gamma = 28.05 kg/m^3 (m/100km)';
     dataX=(avg_slope_2800-avg_slope_2805)*100*1000;
     xlabeltext = 'Cross-slope change of layer thickness (z|_{\gamma = 28.00 kg/m^3} - z|_{\gamma = 28.00 kg/m^3}, m/100km)';

%      dataX=Tot_west_Sv;
%      xlabeltext = 'Total westward transport over the shelf and slope (Sv)';

%     dataX=Ub_east_avg;
%     xlabeltext = 'Undercurrent velocity at seafloor (m/s)';
%     dataX=Ub_east_max;
%     xlabeltext = 'Maximum undercurrent velocity at seafloor (m/s)';
%     dataX=db_490;
%     xlabeltext = 'Cross-slope density change at 490-m depth (kg/m^3)';
%     dataX=Vcdw;
%     xlabeltext = 'Depth-integrated meridional CDW volume flux in the trough (m^2/s)';
%     dataX=Fheatcdw_icefront_all;
%     xlabeltext = 'CDW heat flux at the ice shelf front';

%     dataY = Fheatcdw_icefront_trough;
%     ylabeltext = 'CDW heat flux in the trough';
%     titletext='Heat transport sensitivity'

%     dataY = U_west_avg_upper;
%     ylabeltext = 'Mean upper ocean westward velocity over the shelf and slope (m/s)';
%     titletext='Upper ocean transport sensitivity'
%     dataY = Umin;
%     ylabeltext = 'Strongest westward velocity over the shelf and slope (m/s)';
%     titletext='Upper ocean transport sensitivity'

    dataY = MeltRate_m;
    ylabeltext = 'Ice shelf melt rate (m/yr)';
    titletext='Melt rate sensitivity'
%     dataY = Tot_Sv;
%     ylabeltext = 'Total along-slope transport (Sv)';
%     titletext = 'Along-slope transport sensitivity';
%     dataY = Ub_east_max;
%     ylabeltext = 'Maximum undercurrent velocity at seafloor (m/s)';
%     dataY=Ub_east_avg;
%     ylabeltext = 'Undercurrent velocity at seafloor (m/s)';
%     dataY=Umax;
%     ylabeltext = 'Strongest undercurrent velocity over the shelf and slope (m/s)';

%     dataY=Tot_east_Sv;
%     ylabeltext = 'Total eastward transport over the shelf and slope (Sv)';

%     dataX = TAUx_estimate;
%     xlabeltext='Zonal ocean surface stress (N/m^2)';
%     dataX = TAUy_estimate;
%     xlabeltext='Meridional ocean surface stress (N/m^2)';

%     dataY=Ub_east_avg;
%     ylabeltext = 'Mean bottom undercurrent velocity (m/s)';
%     titletext = 'Undercurrent sensitivity';
    figname = 'MeltRate_m-avg_slope_2800-avg_slope_2805';

    
    xrange = max(dataX)-min(dataX);
    yrange = max(dataY)-min(dataY);

    xrange1 = max(dataX(group1))-min(dataX(group1));
    xrange2 = max(dataX(group2))-min(dataX(group2));
    xrange3 = max(dataX(group3))-min(dataX(group3));


    xgrid = min(dataX):xrange/100:max(dataX);
    x1grid = min(dataX(group1)):xrange1/100:max(dataX(group1));
    x2grid = min(dataX(group2))-xrange2/10:xrange2/100:max(dataX(group2))+xrange2/10;
    x3grid = min(dataX(group3))-xrange3/8:xrange3/100:max(dataX(group3)+xrange3/4);

    f=fit(dataX',dataY','poly1');
    if(plotMeltrate)
    f = fit(dataX([group1 group2 group4])',dataY([group1 group2 group4])','poly1');
    end
    f1 = fit(dataX(group1)',dataY(group1)','poly1');
    f2 = fit(dataX(group2)',dataY(group2)','poly1');
    f3 = fit(dataX(group3)',dataY(group3)','poly1');


    lores = [29:37 41:46];
    no_lores = [1:28 38:40 47:49];


    CORR_ALL = corrcoef(dataX(no_lores),dataY(no_lores));
    if(plotMeltrate)
    CORR_ALL = corrcoef(dataX([group1([1:10 15:19]) group2(1:9) group4]),dataY([group1([1:10 15:19]) group2(1:9) group4]));
    end
    CORR1 = corrcoef(dataX(group1([1:10 15:19])),dataY(group1([1:10 15:19])));
    CORR2 = corrcoef(dataX(group2(1:9)),dataY(group2(1:9)));
    CORR3 = corrcoef(dataX(group3(1:3)),dataY(group3(1:3)));
    corr_all = CORR_ALL(1,2);
    corr1 = CORR1(1,2);
    corr2 = CORR2(1,2);
    corr3 = CORR3(1,2);

    plot_scatter

   