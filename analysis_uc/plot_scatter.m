%%%
%%% plot_scatter.m
%%%

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions; 
    load_colors;
    load('/Users/csi/MITgcm_UC/products_uc/matrix_combined.mat')

    figdir = '/Users/csi/MITgcm_UC/figures_uc/correlation/'; 

    %%%%% Make scatter plots
    fontsize = 18;
    sz = 120;
    LineWidthsz = 1;

    nexp1 = 16;
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
%      dataX=(avg_slope_2800-avg_slope_2805)*100*1000;
%      xlabeltext = 'Cross-slope change of layer thickness (z|_{\gamma = 28.00 kg/m^3} - z|_{\gamma = 28.00 kg/m^3}, m/100km)';

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
    dataX = TAUy_estimate;
    xlabeltext='Meridional ocean surface stress (N/m^2)';

%     dataY=U_east_avg;
%     ylabeltext = 'Mean undercurrent velocity (m/s)';
%     titletext = 'Undercurrent sensitivity';
    figname = 'MeltRate_m-TAUy_estimate';

    
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



    CORR_ALL = corrcoef(dataX,dataY);
    if(plotMeltrate)
    CORR_ALL = corrcoef(dataX([group1 group2 group4]),dataY([group1 group2 group4]));
    end
    CORR1 = corrcoef(dataX(group1),dataY(group1));
    CORR2 = corrcoef(dataX(group2),dataY(group2));
    CORR3 = corrcoef(dataX(group3),dataY(group3));
    corr_all = CORR_ALL(1,2);
    corr1 = CORR1(1,2);
    corr2 = CORR2(1,2);
    corr3 = CORR3(1,2);


    subplotsize = [0.53 0.85];
    figure(1)
    clf;
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

    g4=scatter(dataX(end),dataY(end),sz,orange,'d','filled','MarkerEdgeColor',boxcolor);

    hold off;
    xlim([min(dataX)-xrange/20 max(dataX)+xrange/20])
    ylim([min(dataY)-yrange/20 max(dataY)+yrange/20])
    set(gca,'FontSize',fontsize)
    xlabel(xlabeltext,'FontSize',fontsize);
    ylabel(ylabeltext,'FontSize',fontsize);
    title(titletext,'FontSize',fontsize+2);
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
        g1_deep_ref g1_deep_Hbed0Htr0 g1_tide_strong],...
        'Group1: Ref.',...
        'Group1: Varying zonal wind',...
        'Group1: 3D control of vertical diffusivity',...
        'Group1: Varying Hbed and Htr',...
        'Group1: Trough width=15km (default=30km)',...
        'Group1: deeper thermocline, ref. bathymetry',...
        'Group1: deeper thermocline, varying Hbed and Htr',...
        'Group1: Varying tides',...
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

    ah3=axes('position',get(gca,'position'),'visible','off');
    leg3 = legend(ah3,[g3_melt4 g3_5km_melt4 g3_10km_melt4],...
        'Group3: 2 km, varying prescribed meltwater','Group3: 5 km, varying prescribed meltwater','Group3: 10 km, varying prescribed meltwater',...
        'FontSize',fontsize-2,'Position',[0.6227 0.1214 0.3318 0.0867]);


    ah4=axes('position',get(gca,'position'),'visible','off');
    leg4 = legend(ah4,[g4],...
        'No sea ice',...
        'FontSize',fontsize-2,'Position',[0.6227 0.0733 0.1064 0.0320]);

    print('-dpng','-r150',[figdir figname '.png']);

%     leg1 = legend([sref swind1 swind2 ...
%         sdiff1 sdiff2 sdiff3 ...
%         Hbed0Htr0 Hbed0Htr200 Hbed300Htr0 sWtr ...
%         sdeep_ref sdeep_Hbed0Htr0 sdeep_Hbed0Htr200 sdeep_Hbed300Htr0 ...
%         suniform_ref suniform_wind1 suniform_wind2 suniform_tide ...
%         suniform_Zn450 suniform_Zsb500 suniform_dZs50 suniform_dZs200 suniform_longRelax...
%         ...
%         lfit],...
%         'Ref.','Ua=-2 m/s, Va=2 m/s','Ua=-8 m/s, Va=8 m/s',...
%         'kmax=0.0001 m^2/s','kmax=0.001 m^2/s','kmax=0.003 m^2/s',...
%         'Hbed=0, Htr=0m','Hbed=0, Htr=200m','Hbed=300m, Htr=0',...
%         'W_{trough}=15km',...
%         'Deeper thermocline: Ref.',...
%         'Deeper thermocline: Hbed=0, Htr=0m','Deeper thermocline: Hbed=0, Htr=200m','Deeper thermocline: Hbed=300m, Htr=0',...
%         'Uniform ice inflow: Ref.',...
%         'Uniform ice inflow: Ua=-2 m/s, Va=2 m/s',...
%         'Uniform ice inflow: Ua=-8 m/s, Va=8 m/s',...
%         'Uniform ice inflow: Atide = 0.02m/s',...
%         'Uniform ice inflow: Zn450',...
%         'Uniform ice inflow: Zsb500',...
%         'Uniform ice inflow: dZs50',...
%         'Uniform ice inflow: dZs200',...
%         'Uniform ice inflow: longRelax',...
%         'Fitted curve',...
%         'Location','SouthEast');
%     leg1=legendScatter({'SIZE','1','2','3','4','5', ...
%                 '6','7','8','9','10'},[1:1:10],10,'pk');
%     leg1.Location='SouthEast';
%     xlabel('Buoyancy gradient at z = -520 m (kg/m^3/30km)')
%     ylabel('Mean eastward bottom velocity (m/s)')
%     title('Correlation coefficient = 0.89')

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





    