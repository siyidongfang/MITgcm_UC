

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;  

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];

    load([prodir 'matrix_' exp_group '.mat'])
 
    %%%% Calculate the correlation coefficients
    [R1,P1,RL1,RU1] = corrcoef(detady,min_slope_2805);
    [R2,P2,RL2,RU2] = corrcoef(Ub_east_max,max_slope_2800);
    [R3,P3,RL3,RU3] = corrcoef(Ub_east_max,min_slope_2805);
    [R4,P4,RL4,RU4] = corrcoef(Ub_west_avg,min_slope_2805);
    [R5,P5,RL5,RU5] = corrcoef(Ub_avg,min_slope_2805);

    [R6,P6,RL6,RU6] = corrcoef(MeltRate_m,max_slope_2800);
    [R7,P7,RL7,RU7] = corrcoef(MeltRate_m,min_slope_2805);
    [R8,P8,RL8,RU8] = corrcoef(MeltRate_m,U_west_avg);
    [R9,P9,RL9,RU9] = corrcoef(MeltRate_m,Ub_west_min);

    [R10,P10,RL10,RU10] = corrcoef(MeltRate_m,Tot_east_Sv);
    [R11,P11,RL11,RU11] = corrcoef(MeltRate_m,Tot_west_Sv);
    [R12,P12,RL12,RU12] = corrcoef(MeltRate_m,Tot_Sv);

    [R13,P13,RL13,RU13] = corrcoef(MeltRate_m,Ub_east_max);
    [R14,P14,RL14,RU14] = corrcoef(MeltRate_m,Ub_avg);
    %     [R15,P15,RL15,RU15] = corrcoef(MeltRate_m,U_east_avg);
    %     [R16,P16,RL16,RU16] = corrcoef(MeltRate_m,Ub_east_avg);
    %%% Ice shelf melt rate has strong correlation with maximum undercurrent
    %%% strength (r=0.71) and total eastward transport (0.63), but it has
    %%% even stronger correlation with the total westward transport
    %%% (r=0.76) or total transport (east+west, r=0.79).

    [R17,P17,RL17,RU17] = corrcoef(MeltRate_m,detady);
    %%% Ice shelf melt rate is also correlated with SSH gradient (r=-0.78)

    %%% Zonal sea surface stress is not correlated with ice shelf melt rate or
    %%% undercurrent strength. (Need to check surface stress curl.)

    %%% Undercurrent strength is strongly correlated with cross-slope
    %%% buoyancy gradient (r=0.76~0.89, depending on depth)
    [R18,P18,RL18,RU18] = corrcoef(U_east_avg,db_490);
    [R19,P19,RL19,RU19] = corrcoef(U_east_avg,db_520,'Rows','pairwise');
    [R20,P20,RL20,RU20] = corrcoef(Ub_east_avg,db_490);
    [R21,P21,RL21,RU21] = corrcoef(Ub_east_avg,db_520,'Rows','pairwise');
    %     corrcoef(Ub_east_max,db_490);
    %     corrcoef(Ub_east_max,db_520,'Rows','pairwise');
    %     corrcoef(Ub_west_avg,db_520,'Rows','pairwise')
    %     corrcoef(Ub_west_min,db_520,'Rows','pairwise')
    %     corrcoef(MeltRate_m,db_490)
    %     corrcoef(MeltRate_m,db_520,'Rows','pairwise')
    %     corrcoef(detady,db_520,'Rows','pairwise')


[R211,P211,RL211,RU211] = corrcoef(Ub_east_avg,db_520,'Rows','pairwise');

corrcoef(detady,U_west_avg) %%% Very high correlation -0.97
corrcoef(detady,avg_slope_2805) 
corrcoef(Ub_east_max,avg_slope_2805) 
corrcoef(Ub_east_max,avg_slope_2800) 
corrcoef(U_east_avg,avg_slope_2800) 
corrcoef(U_west_avg,avg_slope_2805) 
corrcoef(MeltRate_m,avg_slope_2800) 
corrcoef(MeltRate_m,avg_slope_2805) 


corrcoef(MeltRate_m,Hcdw)






