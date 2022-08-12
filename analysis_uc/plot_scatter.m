%%%
%%% plot_scatter.m
%%%

%     clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions; 
    load_colors;
    load('/Users/csi/MITgcm_UC/products_uc/matrix_combined.mat')

    %%%%% Make scatter plots
    fontsize = 17;
    sz = 100;
    LineWidthsz = 1;

    nexp1 = 16;
    nexp2 = 18;
    nexp3 = 9;
    nexp4 = 1;
    group1 = 1:nexp1;
    group2 = (nexp1+1):(nexp1+nexp2);
    group3 = (nexp1+nexp2+1):(nexp1+nexp2+nexp3);


    dataX = U_west_avg;
    dataY = detady;
    f=fit(dataX',dataY','poly1');
    f1 = fit(dataX(group1)',dataY(group1)','poly1');
    f2 = fit(dataX(group2)',dataY(group2)','poly1');
    f3 = fit(dataX(group3)',dataY(group3)','poly1');


    figure(1)
    clf;
    lfit = plot(f,'k');
    hold on;
    lfit1 = plot(f1,'r--');
    lfit2 = plot(f2,'g-.');
    lfit3 = plot(f3,'b:');

    % scatter(dataX,dataY)
   
    g1_ref = scatter(dataX(1),dataY(1),sz,'k','o','filled');
    g1_wind1 = scatter(dataX(2),dataY(2),sz*0.75,red,'<','filled','MarkerEdgeColor',boxcolor);
    g1_wind2 = scatter(dataX(3),dataY(3),sz*1.5,red,'<','filled','MarkerEdgeColor',boxcolor);
    
    g1_diff1 =  scatter(dataX(4),dataY(4),sz*0.75,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff2 =  scatter(dataX(5),dataY(5),sz,green,'s','filled','MarkerEdgeColor',boxcolor);
    g1_diff3 =  scatter(dataX(6),dataY(6),sz*1.5,green,'s','filled','MarkerEdgeColor',boxcolor);

    g1_Hbed0Htr0 = scatter(dataX(7),dataY(7),sz*1.5,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed0Htr200 = scatter(dataX(8),dataY(8),sz,pink,'^','filled','MarkerEdgeColor',boxcolor);
    g1_Hbed300Htr0 = scatter(dataX(9),dataY(9),sz*0.75,pink,'^','filled','MarkerEdgeColor',boxcolor);

    g1_Wtr = scatter(dataX(10),dataY(10),sz*1.3,gold,'p','filled','MarkerEdgeColor',boxcolor);

    g1_deep_ref = scatter(dataX(11),dataY(11),sz,brown,'d','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr0 = scatter(dataX(12),dataY(12),sz*1.5,brown,'d','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed0Htr200 = scatter(dataX(13),dataY(13),sz,brown,'d','filled','MarkerEdgeColor',boxcolor);
    g1_deep_Hbed300Htr0 = scatter(dataX(14),dataY(14),sz*0.75,brown,'d','filled','MarkerEdgeColor',boxcolor);

    g1_tide_weak =  scatter(dataX(15),dataY(15),sz*0.75,purple,'h','filled','MarkerEdgeColor',boxcolor);
    g1_tide_strong = scatter(dataX(16),dataY(16),sz*1.5,purple,'h','filled','MarkerEdgeColor',boxcolor);


    ne = nexp1;

    g2_ref = scatter(dataX(1+ne),dataY(1+ne),sz,'k','o');
    g2_wind1 = scatter(dataX(2+ne),dataY(2+ne),sz*0.5,red,'<','MarkerEdgeColor',red);
    g2_wind2 = scatter(dataX(3+ne),dataY(3+ne),sz*1.5,red,'<','MarkerEdgeColor',red);
    g2_tide = scatter(dataX(4+ne),dataY(4+ne),sz*1.5,red,'<','MarkerEdgeColor',red);
    g2_Zn450 = scatter(dataX(5+ne),dataY(5+ne),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    g2_Zsb500 = scatter(dataX(6+ne),dataY(6+ne),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    g2_dZs50 = scatter(dataX(7+ne),dataY(7+ne),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    g2_dZs200 = scatter(dataX(8+ne),dataY(8+ne),sz*1.5,olive,'p','MarkerEdgeColor',olive);
    g2_longRelax = scatter(dataX(9+ne),dataY(9+ne),sz,green,'d','MarkerEdgeColor',green);

    g2_5km_wind2 = scatter(dataX(10+ne),dataY(10+ne),sz*0.5,green,'d','MarkerEdgeColor',black);
    g2_5km_wind3 = scatter(dataX(11+ne),dataY(11+ne),sz,green,'d','MarkerEdgeColor',black);
    g2_5km_wind4 = scatter(dataX(12+ne),dataY(12+ne),sz*1.5,green,'d','MarkerEdgeColor',black);
    g2_10km_wind2 = scatter(dataX(13+ne),dataY(13+ne),sz*0.5,green,'d','MarkerEdgeColor',orange);
    g2_10km_wind3 = scatter(dataX(14+ne),dataY(14+ne),sz,green,'d','MarkerEdgeColor',orange);
    g2_10km_wind4 = scatter(dataX(15+ne),dataY(15+ne),sz*1.5,green,'d','MarkerEdgeColor',orange);
    g2_10km_wind2_gmredi = scatter(dataX(16+ne),dataY(16+ne),sz*0.5,green,'d','MarkerEdgeColor',gray);
    g2_10km_wind3_gmredi = scatter(dataX(17+ne),dataY(17+ne),sz,green,'d','MarkerEdgeColor',gray);
    g2_10km_wind4_gmredi = scatter(dataX(18+ne),dataY(18+ne),sz*1.5,green,'d','MarkerEdgeColor',gray);


    ne = nexp1+nexp2;
    g3_melt4=scatter(dataX(ne+1),dataY(ne+1),sz*0.5,pink,'o','filled','MarkerEdgeColor',boxcolor);
    g3_melt12=scatter(dataX(ne+2),dataY(ne+2),sz,pink,'o','filled','MarkerEdgeColor',boxcolor);
    g3_melt21=scatter(dataX(ne+3),dataY(ne+3),sz*1.5,pink,'o','filled','MarkerEdgeColor',boxcolor);
    g3_5km_melt4=scatter(dataX(ne+4),dataY(ne+4),sz*0.5,yellow,'o','filled','MarkerEdgeColor',boxcolor);
    g3_5km_melt12=scatter(dataX(ne+5),dataY(ne+5),sz,yellow,'o','filled','MarkerEdgeColor',boxcolor);
    g3_5km_melt21=scatter(dataX(ne+6),dataY(ne+6),sz*1.5,yellow,'o','filled','MarkerEdgeColor',boxcolor);
    g3_10km_melt4=scatter(dataX(ne+7),dataY(ne+7),sz*0.5,green,'o','filled','MarkerEdgeColor',boxcolor);
    g3_10km_melt12=scatter(dataX(ne+8),dataY(ne+8),sz,green,'o','filled','MarkerEdgeColor',boxcolor);
    g3_10km_melt21=scatter(dataX(ne+9),dataY(ne+9),sz*1.5,green,'o','filled','MarkerEdgeColor',boxcolor);



    hold off;
    grid on;grid minor;
    set(gca,'FontSize',fontsize)
%     xlim([min(dataX) max(dataX)])
%     ylim([min(dataY) max(dataY)])
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





    