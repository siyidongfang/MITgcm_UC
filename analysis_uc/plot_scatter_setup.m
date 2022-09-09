%%%
%%% plot_scatter.m
%%%

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions; 
    load('/Users/csi/MITgcm_UC/products_uc/matrix_combined.mat')

    figdir = '/Users/csi/MITgcm_UC/figures_uc/correlation/'; 
    savefigure = false;
   
    nexp1 = 19;
    nexp2 = 18;
    nexp3 = 9;
    nexp4 = 1;
    group1 = 1:nexp1;
    group2 = (nexp1+1):(nexp1+nexp2);
    group3 = (nexp1+nexp2+1):(nexp1+nexp2+nexp3);
    group4 = nexp1+nexp2+nexp3+nexp4;

    plotMeltrate = true;
    excludeLOWRES = true;
    if(plotMeltrate)
       excludegroup3 = true;
    else
       excludegroup3 = false;
    end
%     excludegroup3 = false;


dataX = Tc_bc_cdw_mean;
xlabeltext = 'Total CDW heat transport at the ice front, T_{uc}+T_{bc} (TW)';
%     dataX = -detady;
%     xlabeltext = 'Cross-slope SSH gradient';
%     xlabeltext='Mean geostrophic undercurrent velocity (m/s)';
%      dataY=Tot_west_Sv;
%      ylabeltext = 'Total westward transport over the slope (Sv)';
% dataY = MeltRate_m;
%     ylabeltext = 'Ice shelf melt rate (m/yr)';
dataY = MeltRate_m;
    ylabeltext = 'Ice shelf melt rate (m/yr)';
%     figname = 'Tot_east_Sv-Totg_east_Sv';
%     ylabeltext='Mean undercurrent velocity (m/s)';
%     titletext = 'Undercurrent sensitivity';
%     titletext='Undercurrent vs thermal-wind shear'
titletext ='Melt rate vs T_{uc}+T_{bc}'

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

   