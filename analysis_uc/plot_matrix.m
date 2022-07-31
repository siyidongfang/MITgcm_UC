

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    prodir = '/Users/csi/MITgcm_UC/products_uc/';

    load([prodir 'matrix_seaiceboundary.mat'])

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