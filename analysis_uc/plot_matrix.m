

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    prodir = '/Users/csi/MITgcm_UC/products_uc/';

    load([prodir 'matrix_seaiceboundary.mat'],'EXPNAME',...
        'U_east_avg','U_west_avg','Tot_east_Sv','Tot_west_Sv','Tot_Sv',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'MeltRate_m','MeltRate_Gt',...
        'detady','TAUiox','TAUioy','TAUiox_estimate','TAUioy_estimate',...
        'min_slope_2805','max_slope_2800')

    
    figure()
    scatter(detady,min_slope_2805)
    corrcoef(detady,min_slope_2805)

    

%     figure()
%     scatter(Tot_Sv,MeltRate_m)
% 
%     figure()
%     scatter(Tot_east_Sv,MeltRate_m)
% 
%     figure()
%     scatter(Tot_west_Sv,MeltRate_m)
% 
%     figure()
%     scatter(detady,MeltRate_m)
% 
%     figure()
%     scatter(U_east_avg,MeltRate_m)
% 
%     figure()
%     scatter(Ub_east_avg,MeltRate_m)
% 
%     figure()
%     scatter(Ub_east_max,MeltRate_m)

%     figure()
%     scatter(U_west_avg,detady)

%     figure()
%     scatter(Ub_east_max,TAUiox_estimate)