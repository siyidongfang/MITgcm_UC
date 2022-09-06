
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
%     dataX = TAUy_estimate;
%     xlabeltext='Meridional ocean surface stress (N/m^2)';

%     dataY=Ub_east_avg;
%     ylabeltext = 'Mean bottom undercurrent velocity (m/s)';
%     titletext = 'Undercurrent sensitivity';
%     figname = 'MeltRate_m-avg_slope_2800-avg_slope_2805';
